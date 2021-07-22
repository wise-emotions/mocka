import Combine
import Vapor

/// The `AppServer` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class AppServer {

  // MARK: - Stored Properties

  /// The `Request`s created by the user.
  internal var requests: Set<Request> = []

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  /// The `BufferedSubject` of `LogEvent`s.
  /// This subject is used to send and subscribe to `LogEvent`s.
  /// - Note: This property is marked `private` to allow only the `Server` to send events.
  private let consoleLogsSubject = BufferedSubject<LogEvent, Never>()
  
  /// The custom middleware for the server that parses all the `Vapor.Response`s of the server to `NetworkExchange`s.
  private var networkExchangeMiddleware: NetworkExchangeMiddleware?

  /// The `BufferedSubject` of `NetworkExchange`s.
  /// This subject is used to send and subscribe to `NetworkExchange`s.
  /// - Note: This property is marked `private` to allow only the `Server` to send events.
  private var networkExchangesSubject = BufferedSubject<NetworkExchange, Never>()

  /// The `Set` containing the list of subscriptions.
  private var subscriptions = Set<AnyCancellable>()

  // MARK: - Computed Properties

  /// The `Publisher` of `LogEvent`s.
  public var consoleLogsPublisher: AnyPublisher<LogEvent, Never> {
    consoleLogsSubject.eraseToAnyPublisher()
  }

  /// The `Publisher` of `NetworkExchange`s.
  public var networkExchangesPublisher: AnyPublisher<NetworkExchange, Never> {
    networkExchangesSubject.eraseToAnyPublisher()
  }
  

  /// The host associated with the running instance's configuration.
  internal var host: String? {
    application?.http.server.configuration.hostname
  }

  /// The port associated with the running instance's configuration.
  internal var port: Int? {
    application?.http.server.configuration.port
  }

  /// The list of all routes managed by the server.
  ///
  /// This is especially because accessing `application?.routes.all` from the tests results in an empty array regardless for what we believe is a bug.
  /// In Vapor's `Application+Routes`, `self.storage[RoutesKey.self]` is never found even when the routes are actually set, thus instantiating a new `Routes` instance.
  /// Moreover, accessing `application?.routes.all` from here seems to return the actual routes.
  internal var routes: [Route] {
    application?.routes.all ?? []
  }

  // MARK: - Init

  /// Returns a new instance of `AppServer`.
  public init() {
    consoleLogsSubject
      .sink { print($0.message) }
      .store(in: &subscriptions)
  }

  // MARK: - Methods

  /// Starts a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func start(with configuration: ServerConfigurationProvider) throws {
    guard application == nil else {
      throw ServerError.instanceAlreadyRunning
    }

    do {
      let environment = try Environment.detect()
      application = Application(environment)
      networkExchangeMiddleware = NetworkExchangeMiddleware(host: host, port: port, scheme: URI.Scheme.http, subject: networkExchangesSubject)
    } catch {
      throw ServerError.vapor(error: error)
    }

    // Logger must be set at the beginning or it will result in missing the server start event.
    application?.logger = Logger(label: "Server Logger", factory: { _ in ConsoleLogHander(subject: consoleLogsSubject) })
    application?.http.server.configuration.port = configuration.port
    application?.http.server.configuration.hostname = configuration.hostname
    networkExchangeMiddleware.map {
      application?.middleware.use($0)
    }

    do {
      registerRoutes(for: configuration.requests)
      try application?.server.start()
    } catch {
      // The most common error would be when we try to run the server on a PORT that is already used.
      throw ServerError.vapor(error: error)
    }
  }

  /// Shuts down the currently running instance of `Application`, if any.
  public func stop() throws {
    application?.server.shutdown()
    try application?.server.onShutdown.wait()
    application = nil
  }

  /// Shuts down the currently running instance of `Application` if any,
  /// then starts a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func restart(with configuration: ServerConfigurationProvider) throws {
    try stop()
    try start(with: configuration)
  }

  /// Clears the buffered log events from the `consoleLogsSubject`.
  public func clearBufferedConsoleLogEvents() {
    consoleLogsSubject.clearBuffer()
  }

  /// Clears the buffered log events from the `networkExchangesSubject`.
  public func clearBufferedNetworkExchanges() {
    networkExchangeMiddleware?.networkExchangesSubject.clearBuffer()
  }

  /// Registers a route for every request.
  /// - Parameter requests: The list of requests to manage.
  private func registerRoutes(for requests: Set<Request>) {
    self.requests = requests

    requests.forEach {
      let requestedPath = $0.path.joined(separator: "/")
      let requestedResponse = $0.requestedResponse

      application?
        .on($0.method.vaporMethod, $0.vaporParameter) { [unowned self] request -> EventLoopFuture<ClientResponse> in
          // This property is force-unwrapped because it can never fail,
          // since the raw value passed is an identical copy of SwiftNIO's `HTTPMethod`.
          let httpMethod = HTTPMethod(rawValue: request.method.rawValue)!
          let receivedRequestTimeStamp = Date().timeIntervalSince1970

          var clientResponse: ClientResponse!
          var networkExchange: NetworkExchange {
            NetworkExchange(
              request: DetailedRequest(
                httpMethod: httpMethod,
                uri: URI(scheme: URI.Scheme.http, host: host, port: port, path: request.url.path, query: request.url.query),
                headers: request.headers,
                body: body(from: request.body.data),
                timestamp: receivedRequestTimeStamp
              ),
              response: DetailedResponse(
                uri: URI(scheme: URI.Scheme.http, host: host, port: port, path: requestedPath),
                headers: clientResponse.headers,
                status: clientResponse.status,
                body: body(from: clientResponse.body),
                timestamp: Date().timeIntervalSince1970
              )
            )
          }

          guard let responseBody = requestedResponse.body else {
            clientResponse = ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: nil)
            return request.eventLoop.makeSucceededFuture(clientResponse)
          }

          guard responseBody.isValidFileFormat() else {
            let failReason = "Invalid file format. Was expecting a .\(responseBody.contentType.expectedFileExtension!) file"
            clientResponse = ClientResponse(status: .badRequest, headers: [:], body: ByteBuffer(string: failReason))
            return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: failReason))
          }

          return request.fileio
            .collectFile(at: responseBody.pathToFile)
            .flatMap { buffer -> EventLoopFuture<ClientResponse> in
              clientResponse = ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: buffer)
              return request.eventLoop.makeSucceededFuture(clientResponse)
            }
            .flatMapError { error in
              // So far, only logical error is the file not being found.
              let failReason = "File not found at \(responseBody.pathToFile)"
              clientResponse = ClientResponse(status: .badRequest, headers: [:], body: ByteBuffer(string: failReason))
              return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: failReason))
            }
        }
    }
  }

  /// Transforms readable bytes in the buffer to data.
  /// - Parameter buffer: The `ByteBuffer` to read.
  /// - Returns: `Data` read from the `ByteBuffer`. `nil` if `ByteBuffer` is `nil`.
  private func body(from buffer: ByteBuffer?) -> Data? {
    guard var bufferCopy = buffer else {
      return nil
    }

    return bufferCopy.readData(length: bufferCopy.readableBytes)
  }
}

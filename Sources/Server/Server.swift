import Combine
import Vapor

/// The `Server` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class Server {

  // MARK: - Stored Properties

  /// The `Request`s created by the user.
  internal var requests: Set<Request> = []

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  /// The `PassthroughSubject` of `LogEvent`s.
  /// This subject is used to send and subscribe to `LogEvent`s.
  /// - Note: This property is marked `internal` to allow only the `Server` to send events.
  private let consoleLogsSubject = PassthroughSubject<LogEvent, Never>()

  /// The `PassthroughSubject` of `NetworkExchange`s.
  /// This subject is used to send and subscribe to `NetworkExchange`s.
  /// Anytime a request/response exchange happens, a detailed version of the actors is generated and injected in this object.
  /// - Note: This property is marked `internal` to allow only the `Server` to send events.
  private let networkExchangesSubject = PassthroughSubject<NetworkExchange, Never>()

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
  private var host: String? {
    application?.http.server.configuration.hostname
  }

  /// The port associated with the running instance's configuration.
  private var port: Int? {
    application?.http.server.configuration.port
  }

  // MARK: - Init

  /// Returns a new instance of `Server`.
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
    } catch {
      throw ServerError.vapor(error: error)
    }

    // Logger must be set at the beginning or it will result in missing the server start event.
    application?.logger = Logger(label: "Server Logger", factory: { _ in ConsoleLogHander(subject: consoleLogsSubject) })
    application?.http.server.configuration.port = configuration.port
    application?.http.server.configuration.hostname = configuration.hostname

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
          // since the raw value passed is an identical copy of SWIFTNIO's `HTTPMethod`.
          let httpMethod = HTTPMethod(rawValue: request.method.rawValue)!
          let receivedRequestTimeStamp = Date().timeIntervalSince1970

          var clientResponse: ClientResponse!
          var networkExchange: NetworkExchange {
            NetworkExchange(
              request: DetailedRequest(
                httpMethod: httpMethod,
                uri: URI(scheme: URI.Scheme.http, host: host, port: port, path: request.url.path, query: request.url.query),
                headers: request.headers,
                timestamp: receivedRequestTimeStamp
              ),
              response: DetailedResponse(
                httpMethod: httpMethod,
                uri: URI(scheme: URI.Scheme.http, host: host, port: port, path: requestedPath),
                headers: clientResponse.headers,
                status: clientResponse.status,
                timestamp: Date().timeIntervalSince1970
              )
            )
          }

          guard let content = requestedResponse.content else {
            clientResponse = ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: nil)
            networkExchangesSubject.send(networkExchange)
            return request.eventLoop.makeSucceededFuture(clientResponse)
          }

          guard content.isValidFileFormat() else {
            let failReason = "Invalid file format. Was expecting a .\(content.expectedFileExtension!) file"
            clientResponse = ClientResponse(status: .badRequest, headers: [:], body: ByteBuffer(string: failReason))
            networkExchangesSubject.send(networkExchange)
            return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: failReason))
          }

          return request.fileio
            .collectFile(at: content.fileLocation.absoluteString)
            .flatMap { buffer -> EventLoopFuture<ClientResponse> in
              clientResponse = ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: buffer)
              networkExchangesSubject.send(networkExchange)
              return request.eventLoop.makeSucceededFuture(clientResponse)
            }
            .flatMapError { error in
              // So far, only logical error is the file not being found.
              let failReason = "File not found at \(content.fileLocation.absoluteString)"
              clientResponse = ClientResponse(status: .badRequest, headers: [:], body: ByteBuffer(string: failReason))
              networkExchangesSubject.send(networkExchange)
              return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: failReason))
            }
        }
    }
  }
}

import Vapor

/// The `Server` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class Server {

  // MARK: - Properties

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  /// The `Request`s created by the user.
  internal var requests: Set<Request> = []

  // MARK: - Init

  /// Returns a new instance of `Server`.
  public init() {}

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
      let requestedResponse = $0.requestedResponse

      application?
        .on($0.method.vaporMethod, $0.vaporParameter) { req -> EventLoopFuture<ClientResponse> in
          guard let content = requestedResponse.content else  {
            return req.eventLoop
              .makeSucceededFuture(ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: nil))
          }

          guard content.isValidFileFormat() else {
            return req.eventLoop
              .makeFailedFuture(Abort(.badRequest, reason: "Invalid file format. Was expecting a .\(content.expectedFileExtension) file."))
          }

          return req.fileio
            .collectFile(at: content.fileLocation.absoluteString)
            .flatMap { buffer -> EventLoopFuture<ClientResponse> in
              return req.eventLoop
                .makeSucceededFuture(ClientResponse(status: requestedResponse.status, headers: requestedResponse.headers, body: buffer))
            }
            .flatMapError { error in
              // So far, only logical error is the file not being found.
              return req.eventLoop
                .makeFailedFuture(Abort(.badRequest, reason: "File not found at \(content.fileLocation.absoluteString)"))
            }
        }
    }
  }
}

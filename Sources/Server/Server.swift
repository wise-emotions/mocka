import Vapor

/// The `Server` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class Server {

  // MARK: - Properties

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  /// The `Request`s created by the user.
  internal var requests: [Request] = []

  // MARK: - Init

  /// Returns a new instance of `Server`.
  public init() {}

  // MARK: - Methods

  /// Starts  a new `Application` instance using the passed configuration.
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
      try application?.start()
    } catch {
      // The most common error would be when we try to run the server on a PORT that is already occupied.
      throw ServerError.vapor(error: error)
    }
  }

  /// Shuts down the currently running instance of `Application`, if any.
  public func stop() {
    application?.shutdown()
    application = nil
  }

  /// Shuts down the currently running instance of `Application` if any,
  /// then starts  a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func restart(with configuration: ServerConfigurationProvider) throws {
    stop()
    try start(with: configuration)
  }

  /// Registers a route for every request.
  /// - Parameter requests: The list of requests to manage.
  private func registerRoutes(for requests: [Request]) {
    self.requests = requests

    requests.forEach {
      application?.on($0.method.vaporMethod, $0.vaporParameter) { req -> String in
        #warning("Return a response based on the content of the file associated with the request.")
        return ""
      }
    }
  }
}

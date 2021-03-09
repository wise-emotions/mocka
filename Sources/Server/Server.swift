import Vapor

/// The `Server` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class Server {

  // MARK: - Properties

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  // MARK: - Init

  /// Returns a new instance of `Server`.
  public init() {}

  // MARK: - Methods

  /// Starts  a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func start(with configuration: ServerConfigurationProvider = DefaultServerConfiguration()) throws {
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
      try application?.start()
    } catch {
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
  public func restart(with configuration: ServerConfigurationProvider = DefaultServerConfiguration()) throws {
    stop()
    try start(with: configuration)
  }
}

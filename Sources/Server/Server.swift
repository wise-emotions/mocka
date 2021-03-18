import Combine
import Vapor

/// The `Server` is the brains of `Mocka`.
/// It starts, stops and restarts `Vapor`.
public class Server {

  // MARK: - Properties
  
  /// The `Publisher` of `LogEvent`s.
  public var consoleLogsPublisher: AnyPublisher<LogEvent, Never> {
    consoleLogsSubject.eraseToAnyPublisher()
  }
  
  /// The `PassthroughSubject` of `LogEvent`s.
  /// This subject is used to send and subscribe to `LogEvent`s.
  /// - Note: This property is marked `internal` to allow only the `Server` to send events.
  internal let consoleLogsSubject = PassthroughSubject<LogEvent, Never>()

  /// The `Vapor` `Application` instance.
  internal private(set) var application: Application?

  /// The `Request`s created by the user.
  internal var requests: [Request] = []
  
  /// The `Set` containing the list of subscriptions.
  private var subscriptions = Set<AnyCancellable>()
  
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

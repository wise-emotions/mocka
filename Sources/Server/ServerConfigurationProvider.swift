import Foundation

/// An object containing the required configuration to run the server.
public protocol ServerConfigurationProvider {
  /// The host part of the `URL`.
  /// Defaults to `127.0.0.1`
  var hostname: String { get }

  /// The port listening to incoming requests.
  /// Defaults to 8080
  var port: Int { get }

  /// The list of `Request` that vapor should be able to manage.
  var requests: [Request] { get }
}

// MARK: - Defaults

public extension ServerConfigurationProvider {
  var hostname: String {
    "127.0.0.1"
  }

  var port: Int {
    8080
  }
}

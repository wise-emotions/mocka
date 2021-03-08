import Foundation

/// An object containing the required configuration to run the server.
/// For most cases, the provided `DefaultServerConfiguration` with the default values is enough.
public protocol ServerConfigurationProvider {
  /// The host part of the `URL`.
  /// Defaults to `127.0.0.1`
  var hostname: String { get }

  /// The port listening to incoming requests.
  /// Defaults to 8080
  var port: Int { get }
}

// MARK: - Defaults

/// A default implementation of `ServerConfigurationProvider`.
public struct DefaultServerConfiguration: ServerConfigurationProvider {
  public init() {}
}

public extension ServerConfigurationProvider {
  var hostname: String {
    "127.0.0.1"
  }

  var port: Int {
    8080
  }
}

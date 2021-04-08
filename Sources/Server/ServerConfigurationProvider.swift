import Foundation

/// An object containing the required configuration to run the server.
public protocol ServerConfigurationProvider: ServerConnectionConfigurationProvider {
  /// The list of `Request` that vapor should be able to manage.
  var requests: Set<Request> { get }
}

public protocol ServerConnectionConfigurationProvider {
  /// The host part of the `URL`.
  var hostname: String { get }

  /// The port listening to incoming requests.
  var port: Int { get }
}

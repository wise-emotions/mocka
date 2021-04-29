//
//  Mocka
//

import MockaServer

/// An object containing the parameters needed to configure the server's connection.
struct ServerConnectionConfiguration: ServerConnectionConfigurationProvider, Codable {
  /// The host part of the `URL`.
  let hostname: String

  /// The port listening to incoming requests.
  let port: Int

  /// Creates a new `ServerConnectionConfiguration` object.
  /// - Parameters:
  ///   - hostname: The host part of the `URL`. Defaults to `127.0.0.1`.
  ///   - port: The port listening to incoming requests. Defaults to 8080.
  init(
    hostname: String = "127.0.0.1",
    port: Int = 8080
  ) {
    self.hostname = hostname
    self.port = port
  }
}

/// An object containing the full configuration of the server.
struct ServerConfiguration: ServerConfigurationProvider {
  /// The host part of the `URL`.
  let hostname: String

  /// The port listening to incoming requests.
  let port: Int

  /// The list of requests to manage by the server.
  let requests: Set<MockaServer.Request>

  /// Creates a new `ServerConfiguration` object.
  /// - Parameters:
  ///   - hostname: The host part of the `URL`. Defaults to `127.0.0.1`.
  ///   - port: The port listening to incoming requests. Defaults to 8080.
  ///   - requests: The requests to allow the server to accept and manage.
  init(
    hostname: String = "127.0.0.1",
    port: Int = 8080,
    requests: Set<MockaServer.Request>
  ) {
    self.hostname = hostname
    self.port = port
    self.requests = requests
  }
}

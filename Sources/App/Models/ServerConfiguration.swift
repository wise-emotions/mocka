import Foundation
import MockaServer

/// An object containing the parameters needed to configure the server's connection.
struct ServerConnectionConfiguration: ServerConnectionConfigurationProvider, Encodable {
  /// The host part of the `URL`.
  let hostname = "127.0.0.1"

  /// The port listening to incoming requests.
  let port = 8080
}

/// An object containing the full configuration of the server.
struct ServerConfiguration: ServerConfigurationProvider {
  /// The host part of the `URL`.
  let hostname = "127.0.0.1"

  /// The port listening to incoming requests.
  let port = 8080

  var requests: Set<Request>

  init(requests: Set<Request>) {
    self.requests = requests
  }
}

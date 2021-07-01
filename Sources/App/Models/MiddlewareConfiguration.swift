//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing the parameters needed to configure the server's connection.
struct MiddlewareConfiguration: MiddlewareConfigurationProvider, Codable {
  /// The base `URL` on which the middleware will start requests.
  var baseURL: URL
  
  /// The host part of the `URL`.
  let hostname: String

  /// The port listening to incoming requests.
  let port: Int

  /// Creates a new `ServerConnectionConfiguration` object.
  /// - Parameters:
  ///   - baseURL: The base `URL` on which the middleware will start requests.
  ///   - hostname: The host part of the `URL`.
  ///   - port: The port listening to incoming requests.
  init(
    baseURL: URL,
    hostname: String,
    port: Int
  ) {
    self.baseURL = baseURL
    self.hostname = hostname
    self.port = port
  }
}


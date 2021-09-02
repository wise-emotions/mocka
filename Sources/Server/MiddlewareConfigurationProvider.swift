//
//  Mocka
//

import Foundation

/// An object containing the required configuration to run the middleware.
public protocol MiddlewareConfigurationProvider: ServerConnectionConfigurationProvider {
  /// The base `URL` to be used instead of the local host to perform real network calls.
  var baseURL: URL { get }
}

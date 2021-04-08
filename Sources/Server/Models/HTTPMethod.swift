import Foundation
import Vapor

/// The list of supported `HTTP` methods.
///
/// A custom list exist instead of using `Vapor`'s own list because the latter has several methods that are not needed.
public enum HTTPMethod: String, CaseIterable {
  /// `CONNECT` method.
  case connect = "CONNECT"

  /// `DELETE` method.
  case delete = "DELETE"

  /// `GET` method.
  case get = "GET"

  /// `HEAD` method.
  case head = "HEAD"

  /// `OPTIONS` method.
  case options = "OPTIONS"

  /// `PATCH` method.
  case patch = "PATCH"

  /// `POST` method.
  case post = "POST"

  /// `PUT` method.
  case put = "PUT"

  /// `TRACE` method.
  case trace = "TRACE"

  /// The `Vapor` `HTTPMethod` equivalent of `Mocka`'s `HTTPMethod`.
  internal var vaporMethod: Vapor.HTTPMethod {
    switch self {
    case .connect:
      return .CONNECT

    case .delete:
      return .DELETE

    case .get:
      return .GET

    case .head:
      return .HEAD

    case .options:
      return .OPTIONS

    case .patch:
      return .PATCH

    case .post:
      return .POST

    case .put:
      return .PUT

    case .trace:
      return .TRACE
    }
  }
}

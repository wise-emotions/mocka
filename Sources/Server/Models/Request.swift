import Foundation
import Vapor

/// An object that represents an `HTTP` request.
/// The request is composed of:
/// - an `HTTPMethod`
/// - a path that the request responds to
/// - a response location that points to where the `JSON` file associated with the request is present, if any.
public struct Request {
  /// The `HTTPMethod` of the request.
  public let method: HTTPMethod

  /// The `Path` associated with `Request`.
  /// Include `*` in any position and the value of that field will be discarded. This is useful when the path includes an `ID`.
  /// Include `**` and any string at this position or later positions will be matched in the request.
  ///
  /// - Note:
  /// - `/api/v1/users` will be matched by `/api/v1/users`.
  ///
  /// - `/api/*/users` will be matched by `/api/v1/users`, `/api/v2/users` and anything similar.
  ///
  /// - `/api/**` will be matched by `/api/v1/users`, `/api/users/notes` and anything that starts with `/api`.
  public let path: Path

  /// The path relative to the root JSON folder where the response associated with the request is present.
  /// If a request has no response, this Path **should be** nil.
  public let responseLocation: Path?

  /// The `path` transformed in an array of `PathComponent`.
  internal var vaporParameter: [PathComponent] {
    path.split(separator: "/").map {
      PathComponent(stringLiteral: String($0))
    }
  }
  /// Returns a `Parameter` object.
  /// - Parameters:
  ///   - method: The `HTTPMethod` of the request.
  ///   - path: The `Path` associated with `Request`.
  ///   - responseLocation: The path relative to the root JSON folder where the response associated with the request is present.
  public init(
    method: HTTPMethod,
    path: Path,
    responseLocation: Path?
  ) {
    self.method = method
    self.path = path
    self.responseLocation = responseLocation
  }
}

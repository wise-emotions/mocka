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

  /// The requested response when this request is executed.
  public let requestedResponse: RequestedResponse

  /// The `path` transformed in an array of `PathComponent`.
  internal var vaporParameter: [PathComponent] {
    path.map {
      PathComponent(stringLiteral: String($0))
    }
  }
  
  /// Returns a `Request` object.
  /// - Parameters:
  ///   - method: The `HTTPMethod` of the request.
  ///   - path: The `Path` associated with `Request`.
  ///   - requestedResponse: The desired response when this request is executed.
  public init(
    method: HTTPMethod,
    path: Path,
    requestedResponse: RequestedResponse
  ) {
    self.method = method
    self.path = path
    self.requestedResponse = requestedResponse
  }
}

extension Request: Hashable {
  public static func == (lhs: Request, rhs: Request) -> Bool {
    lhs.method == rhs.method && lhs.path == rhs.path
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine("\(method) - \(path)")
  }
}

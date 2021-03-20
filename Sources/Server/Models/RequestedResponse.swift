import Foundation

/// An object associated with the `Request` reflecting the desired `Response` by the user.
public struct RequestedResponse {
  /// The HTTP response status.
  public let status: HTTPResponseStatus

  /// The header fields for this HTTP response.
  /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically
  /// when the `body` property is mutated.
  public let headers: HTTPHeaders

  /// The expected response content.
  /// Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, content will automatically be set ti `nil`.
  public let content: ResponseContent?

  /// Returns an instance of `RequestedResponse`
  /// - Parameters:
  ///   - status: The HTTP response status.
  ///   - headers: The header fields for this HTTP response.
  ///   The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically when the `body` property is mutated.
  ///   - content: The expected response content.
  ///   Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, content will automatically be set ti `nil`.
  public init(
    status: HTTPResponseStatus,
    headers: HTTPHeaders,
    content: ResponseContent?
  ) {
    self.status = status
    self.headers = headers
    self.content = status.mayHaveResponseBody ? content : nil
  }
}

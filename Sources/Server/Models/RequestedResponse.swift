import Foundation

/// An object associated with the `Request` reflecting the desired `Response` by the user.
public struct RequestedResponse {
  /// The HTTP response status.
  public let status: HTTPResponseStatus

  /// The header fields for this HTTP response.
  /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically
  /// when the `body` property is mutated.
  public let headers: HTTPHeaders

  /// The expected response body.
  /// Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, content will automatically be set ti `nil`.
  /// The response content will automatically set the value for `Content-Type` in the headers, and will override any passed value.
  public let body: ResponseBody?

  /// The key defining the content type in the `HTTP` response header.
  private let contentTypeHTTPHeaderKey = "Content-Type"

  /// Returns an instance of `RequestedResponse`
  /// - Parameters:
  ///   - status: The HTTP response status. Defaults to `.ok`.
  ///   - headers: The header fields for this HTTP response.
  ///   The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically when the `body` property is mutated.
  ///   Defaults to `[:]`.
  ///   - body: The expected response body.
  ///   Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, body will automatically be set to `nil`. Default value is `nil`.
  ///   The response content will automatically set the value for `Content-Type` in the headers, and will override any passed value.
  public init(
    status: HTTPResponseStatus = .ok,
    headers: HTTPHeaders = [:],
    body: ResponseBody? = nil
  ) {
    self.status = status
    self.body = status.mayHaveResponseBody ? body : nil
    if let body = self.body, let contentTypeHeader = body.contentType.contentTypeHeader {
      self.headers = headers.replacingOrAdding(name: contentTypeHTTPHeaderKey, value: contentTypeHeader)
    } else {
      self.headers = headers.removing(name: contentTypeHTTPHeaderKey)
    }
  }
}

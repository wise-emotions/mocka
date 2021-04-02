import Foundation

public extension Models {
  /// An object associated with the `Request` reflecting the desired `Response` by the user.
  struct RequestedResponse {
    /// The HTTP response status.
    public let status: HTTPResponseStatus

    /// The header fields for this HTTP response.
    /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically
    /// when the `body` property is mutated.
    public let headers: HTTPHeaders

    /// The expected response content.
    /// Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, content will automatically be set ti `nil`.
    /// The response content will automatically set the value for `Content-Type` in the headers, and will override any passed value.
    public let content: Models.ResponseContent?

    /// The key defining the content type in the `HTTP` response header.
    private let contentTypeHTTPHeaderKey = "Content-Type"

    /// Returns an instance of `RequestedResponse`
    /// - Parameters:
    ///   - status: The HTTP response status.
    ///   - headers: The header fields for this HTTP response.
    ///   The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically when the `body` property is mutated.
    ///   - content: The expected response content.
    ///   Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, content will automatically be set ti `nil`.
    ///   The response content will automatically set the value for `Content-Type` in the headers, and will override any passed value.
    public init(
      status: HTTPResponseStatus,
      headers: HTTPHeaders,
      content: ResponseContent?
    ) {
      self.status = status
      self.content = status.mayHaveResponseBody ? content : nil
      if let content = self.content, let contentTypeHeader = content.contentTypeHeader {
        self.headers = headers.replacingOrAdding(name: contentTypeHTTPHeaderKey, value: contentTypeHeader)
      } else {
        self.headers = headers.removing(name: contentTypeHTTPHeaderKey)
      }
    }
  }
}

//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information regarding the response for a server request.
struct Response: Codable {
  /// The `HTTP` response status code.
  let statusCode: Int

  /// The `Content-Type` of the request.
  let contentType: ResponseBody.ContentType

  /// The HTTPHeaders to be returned alongside the response.
  let headers: HTTPHeaders

  /// The name of the file where the response is present, if any.
  let fileName: String?

  /// Creates a `Response` object.
  /// - Parameters:
  ///   - statusCode: The `HTTP` response status code.
  ///   - contentType: The `Content-Type` of the response.
  ///   - headers: The additional custom headers to add to a request.
  init(
    statusCode: Int,
    contentType: ResponseBody.ContentType,
    headers: HTTPHeaders
  ) {
    self.statusCode = statusCode
    self.contentType = contentType
    self.headers = headers

    guard
      HTTPResponseStatus(statusCode: statusCode).mayHaveResponseBody,
      let fileExtension = contentType.expectedFileExtension
    else {
      self.fileName = nil
      return
    }

    self.fileName = "response.\(fileExtension)"
  }
}

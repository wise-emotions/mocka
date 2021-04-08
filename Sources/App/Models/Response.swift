//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information regarding the response for a server request.
struct Response: Codable {
  /// The `Content-Type` of the request.
  let contentType: ResponseBody.ContentType

  /// The HTTPHeaders to be returned alongside the response.
  let headers: HTTPHeaders

  /// The body of a response. This is optional since some responses may not have a body.
  let body: Data?

  /// Creates a `Response` object.
  /// - Parameters:
  ///   - contentType: The `Content-Type` of the response.
  ///   - headers: The additional custom headers to add to a request.
  ///   - body: The body of the response, if any.
  init(contentType: ResponseBody.ContentType, headers: HTTPHeaders?, body: Data?) {
    self.contentType = contentType
    self.headers = headers
    self.body = body
  }
}

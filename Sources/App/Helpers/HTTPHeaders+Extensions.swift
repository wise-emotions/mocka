//
//  Mocka
//

import Foundation
import MockaServer

extension HTTPHeaders {
  /// The key defining the content type in the `HTTP` response/request header.
  static let contentTypeHTTPHeaderKey = "Content-Type"

  /// The content type of the request/response body.
  var contentType: ResponseBody.ContentType? {
    guard let contentTypeHeader = self.first(where: { $0.name == Self.contentTypeHTTPHeaderKey }) else {
      return nil
    }

    return ResponseBody.ContentType(rawValue: contentTypeHeader.value)
  }
}

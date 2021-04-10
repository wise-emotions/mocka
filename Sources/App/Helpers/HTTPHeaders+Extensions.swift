//
//  Mocka
//

import Foundation
import MockaServer

extension HTTPHeaders {
  /// The `Content-Type` of the response/request body.
  enum ContentType: String {

    // MARK: Application

    /// `Content-Type: application/json`.
    case applicationJSON = "application/json"

    // MARK: Text

    /// `Content-Type: text/csv`.
    case textCSS = "text/csv"

    /// `Content-Type: text/css`.
    case textCSV = "text/css"

    /// `Content-Type: text/html`.
    case textHTML = "text/html"

    /// `Content-Type: text/plain`.
    case textPlain = "text/plain"

    /// `Content-Type: text/xml`.
    case textXML = "text/xml"
  }

  /// The key defining the content type in the `HTTP` response/request header.
  static let contentTypeHTTPHeaderKey = "Content-Type"

  /// The content type of the request/response body.
  var contentType: ContentType? {
    guard let contentTypeHeader = self.first(where: { $0.name == Self.contentTypeHTTPHeaderKey }) else {
      return nil
    }

    return ContentType(rawValue: contentTypeHeader.value)
  }
}

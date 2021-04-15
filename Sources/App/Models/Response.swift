//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information regarding the response for a server request.
struct Response: Hashable {
  /// The `HTTP` response status code.
  let statusCode: Int

  /// The `Content-Type` of the request.
  let contentType: ResponseBody.ContentType

  /// The HTTPHeaders to be returned alongside the response.
  let headers: [HTTPHeader]

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
    headers: [HTTPHeader]
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

// MARK: - Custom Coding

extension Response: Codable {
  enum CodingKeys: String, CodingKey {
    case statusCode
    case contentType
    case headers
    case fileName
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(statusCode, forKey: .statusCode)
    try container.encode(contentType, forKey: .contentType)
    try container.encode(fileName, forKey: .fileName)

    var headersDictionary: [String: String] = [:]
    headers.forEach { headersDictionary[$0.key] = $0.value }
    try container.encode(headersDictionary, forKey: .headers)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    statusCode = try container.decode(Int.self, forKey: .statusCode)
    contentType = try container.decode(ResponseBody.ContentType.self, forKey: .contentType)
    fileName = try container.decodeIfPresent(String.self, forKey: .fileName)

    let decodedHeaders = try container.decode([String: String].self, forKey: .headers)
    headers = decodedHeaders.reduce(into: [HTTPHeader]())  {
      $0.append(HTTPHeader(key: $1.key, value: $1.value))
    }
  }
}

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

// MARK: - Codable

// To simplify how the data is edited inside the `request.json` file,
// we customize how we encode and extract the data.
//
// Without the custom encoder we would have:
// ```
// headers: [
//   {
//     "key": "someKey",
//     "value": "someValue"
//   }
// ]
// ```
//
// With the custom encoder we will have:
// ```
// headers: [
//   { "key": "value" },
//   { "ke2": "valu2" }
// ]
// ```
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

    let headersDictionary =
      headers
      .filter {
        $0.key.isNotEmpty && $0.value.isNotEmpty
      }

    try container.encode(headersDictionary, forKey: .headers)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    statusCode = try container.decode(Int.self, forKey: .statusCode)
    contentType = try container.decode(ResponseBody.ContentType.self, forKey: .contentType)
    fileName = try container.decodeIfPresent(String.self, forKey: .fileName)

    headers = try container.decode([HTTPHeader].self, forKey: .headers)
  }
}

//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information related to a server request.
/// This object is saved to and retrieved from the file system.
struct Request: Equatable, Hashable {
  /// The name of the request.
  let name: String
  
  /// The path of the `API`. This should not consider any query parameters.
  let path: Path

  /// The method associated with the request.
  let method: HTTPMethod

  /// The expected response when this request is invoked.
  let expectedResponse: Response

  /// Whether or not the request has a response body.
  var hasResponseBody: Bool {
    HTTPResponseStatus(statusCode: expectedResponse.statusCode).mayHaveResponseBody
      && expectedResponse.fileName != nil
      && expectedResponse.contentType != .none
  }

  /// Creates a `Request` object.
  /// - Parameters:
  ///   - name: The name of the request.
  ///   - path: The path of the `API`. This should not consider any query parameters.
  ///   - method: The method associated with the request.
  ///   - expectedResponse: The expected response when this request is invoked.
  init(name: String, path: Path, method: HTTPMethod, expectedResponse: Response) {
    self.name = name
    self.path = path
    self.method = method
    self.expectedResponse = expectedResponse
  }

  /// Converts a `MockaApp.Request` into a `MockaServer.Request`.
  /// - Parameters:
  ///   - url: The `URL` where the response file lives. This is the same the request's.
  /// - Returns: An instance of `MockaServer.Request`.
  func mockaRequest(withResponseAt url: URL?) -> MockaServer.Request {
    return MockaServer.Request(
      method: method,
      path: path,
      requestedResponse: RequestedResponse(
        status: HTTPResponseStatus(statusCode: expectedResponse.statusCode),
        headers: HTTPHeaders(expectedResponse.headers.map { $0.tuple }),
        body: hasResponseBody
          ? ResponseBody(
            contentType: expectedResponse.contentType,
            // It is ok to force-unwrap because `hasResponseBody` already verifies that fileName exists.
            pathToFile: url!.appendingPathComponent(expectedResponse.fileName!).path
          ) : nil
      )
    )
  }
}

// MARK: - Codable

// To simplify how the data is edited inside the `request.json` file,
// we customize how we encode and extract the data.
//
// Without the custom encoder we would have `path` as an array of strings, whereas a `String` is more reasonable.
extension Request: Codable {
  enum CodingKeys: String, CodingKey {
    case name
    case path
    case method
    case expectedResponse
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let stringPath = try container.decode(String.self, forKey: .path)
    name = try container.decode(String.self, forKey: .name)
    path = stringPath.components(separatedBy: "/")
    method = try container.decode(HTTPMethod.self, forKey: .method)
    expectedResponse = try container.decode(Response.self, forKey: .expectedResponse)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(name, forKey: .name)
    let stringPath = path.joined(separator: "/")
    try container.encode(stringPath, forKey: .path)
    try container.encode(method, forKey: .method)
    try container.encode(expectedResponse, forKey: .expectedResponse)
  }
}

//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information related to a server request.
/// This object is saved to and retrieved from the file system.
struct Request: Equatable, Hashable {
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
  ///   - path: The path of the `API`. This should not consider any query parameters.
  ///   - method: The method associated with the request.
  ///   - response: The expected response when this request is invoked.
  init(path: Path, method: HTTPMethod, expectedResponse: Response) {
    self.path = path
    self.method = method
    self.expectedResponse = expectedResponse
  }

  /// Creates a `Request` object starting from a `NetworkExchange` object.
  /// - Parameter networkExchange: The `NetworkExchange` object received from the server.
  init(from networkExchange: NetworkExchange) {
    path = networkExchange.request.uri.path.components(separatedBy: "/")
    method = HTTPMethod(rawValue: networkExchange.request.httpMethod.rawValue)!
    expectedResponse = Response(
      statusCode: Int(networkExchange.response.status.code),
      contentType: networkExchange.response.headers.contentType ?? .applicationJSON,
      headers: networkExchange.response.headers.map { HTTPHeader(key: $0.name, value: $0.value) }
    )
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
    case path
    case method
    case expectedResponse
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let stringPath = try container.decode(String.self, forKey: .path)
    path = stringPath.components(separatedBy: "/")
    method = try container.decode(HTTPMethod.self, forKey: .method)
    expectedResponse = try container.decode(Response.self, forKey: .expectedResponse)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    let stringPath = path.joined(separator: "/")
    try container.encode(stringPath, forKey: .path)
    try container.encode(method, forKey: .method)
    try container.encode(expectedResponse, forKey: .expectedResponse)
  }
}

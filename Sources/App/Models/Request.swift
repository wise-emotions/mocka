//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information related to a server request.
/// This object is saved to and retrieved from the file system.
struct Request: Codable, Hashable {
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

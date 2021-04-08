//
//  Mocka
//

import Foundation
import MockaServer

/// An object containing information related to a server request.
/// This object is saved to and retrieved from the file system.
struct Request: Codable {
  /// The path of the `API`. This should not consider any query parameters.
  let path: Path

  /// The method associated with the request.
  let method: HTTPMethod

  /// The expected response when this request is invoked.
  let expectedResponse: Response

  /// Creates a `Request` object.
  /// - Parameters:
  ///   - path: The path of the `API`. This should not consider any query parameters.
  ///   - method: The method associated with the request.
  ///   - response: The expected response when this request is invoked.
  init(path: Path, method: HTTPMethod, responseCode: Int, expectedResponse: Response) {
    self.path = path
    self.method = method
    self.expectedResponse = expectedResponse
  }

  /// Converts a `MockaApp.Request` into a `MockaServer.Request`.
  /// - Parameters:
  ///   - response: The `MockaApp.Response` object containing the information of the response.
  ///   - url: The `URL` where the `response.json` lives. This is the same the request's.
  /// - Returns: An instance of `MockaServer.Request`.
  func mockaRequest(with response: Response, at url: URL) -> MockaServer.Request {
    MockaServer.Request(
      method: method,
      path: path,
      requestedResponse: RequestedResponse(
        status: HTTPResponseStatus(statusCode: response.statusCode),
        headers: response.headers,
        body: ResponseBody(contentType: response.contentType, fileLocation: url)
      )
    )
  }
}

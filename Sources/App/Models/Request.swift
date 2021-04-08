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

  /// The `HTTP` response status code.
  let responseCode: Int

  /// The name of the file from which to read the response.
  /// Version 1.0 supports only one response at a time with the file named `response.json`.
  /// This value cannot be changed in the initialiser or at any point.
  let responseFileName: String

  /// Creates a `Request` object.
  /// - Parameters:
  ///   - path: The path of the `API`. This should not consider any query parameters.
  ///   - method: The method associated with the request.
  ///   - responseCode: The `HTTP` response status code.
  init(path: Path, method: HTTPMethod, responseCode: Int) {
    self.path = path
    self.method = method
    self.responseCode = responseCode
    self.responseFileName = "response.json"
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
        status: HTTPResponseStatus(statusCode: responseCode),
        headers: response.headers,
        body: ResponseBody(contentType: response.contentType, fileLocation: url)
      )
    )
  }
}

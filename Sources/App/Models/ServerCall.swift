import Foundation
import Server

struct ServerCall: Identifiable {
  /// The unique ID of the request.
  let id = UUID()
  
  /// The `HTTPMethod` of the request.
  let httpMethod: HTTPMethod
  
  /// The `HTTPStatus` of the response`
  let httpStatus: Int
  
  /// The meaning of the respective status code.
  let httpStatusMeaning: String

  /// The timestamp of the response.
  let timestamp: String

  /// The path of the request.
  let path: String
}

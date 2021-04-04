//
//  Mocka
//

import Foundation

public extension NetworkExchange {
  /// The static mock property. To be used only for mock purposes.
  static let mock = NetworkExchange(
    request: DetailedRequest(
      httpMethod: .get,
      uri: URI(path: "api/v1/users"),
      headers: [:],
      body: nil,
      timestamp: Date().timeIntervalSince1970
    ),
    response: DetailedResponse(
      httpMethod: .get,
      uri: URI(path: "api/v1/users"),
      headers: [:],
      status: HTTPResponseStatus(statusCode: 200),
      body: "{\"users\": []}".data(using: .utf8),
      timestamp: Date().timeIntervalSince1970
    )
  )
}

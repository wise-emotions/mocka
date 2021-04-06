//
//  Mocka
//

import Foundation

public extension NetworkExchange {
  /// The static mock property. To be used only for mock purposes.
  static let mock = NetworkExchange(
    request: DetailedRequest(
      httpMethod: .post,
      uri: URI(path: "api/v1/user"),
      headers: ["token": "ThISisATokEN"],
      body: "{\"name\": \"john\"}".data(using: .utf8),
      timestamp: Date().timeIntervalSince1970
    ),
    response: DetailedResponse(
      uri: URI(path: "api/*/user"),
      headers: ["Content-Type": "application/json"],
      status: HTTPResponseStatus(statusCode: 200),
      body: "{\"name\": \"john\", \"age\": 18}".data(using: .utf8),
      timestamp: Date().timeIntervalSince1970
    )
  )
}

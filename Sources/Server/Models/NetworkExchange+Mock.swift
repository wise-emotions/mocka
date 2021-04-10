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
      headers: [
        "token": "ThISisATokEN",
        "Content-Type": "application/json",
      ],
      body: "{\"name\": \"john\"}, \"surname\": \"Apple\"}".data(using: .utf8),
      timestamp: Date().timeIntervalSince1970
    ),
    response: DetailedResponse(
      uri: URI(path: "api/*/user"),
      headers: ["Content-Type": "application/json"],
      status: HTTPResponseStatus(statusCode: 201),
      body: "{\"name\": \"John\", \"surname\": \"Apple\"}".data(using: .utf8),
      timestamp: Date().timeIntervalSince1970
    )
  )
}

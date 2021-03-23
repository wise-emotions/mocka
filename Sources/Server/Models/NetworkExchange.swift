import Foundation

/// An object containing information about the request/response pair.
/// [RFC2616](https://tools.ietf.org/html/rfc2616) refers to this pair as an exchange.
public struct NetworkExchange {
  /// The object containing the details about the received request.
  public let request: DetailedRequest

  /// The object containing the details about the sent response.
  public let response: DetailedResponse
}

/// An object containing the details about the received request.
public struct DetailedRequest {
  /// The `HTTP` method associated with the request.
  let httpMethod: HTTPMethod

  /// The `URI` that invoked the start of the exchange.
  let uri: URI

  /// The headers associated with the request.
  let headers: HTTPHeaders

  /// The time stamp of when the request was invoked.
  let timeStamp: TimeInterval

  /// The list of query items associated with the request.
  var queryItems: [URLQueryItem] {
    uri.query?
      .split(separator: "&")
      .compactMap {
        let keyValue = $0.split(separator: "=")
          .map {
            String($0)
          }

        guard keyValue.count == 2 else {
          return nil
        }

        return URLQueryItem(name: keyValue[0], value: keyValue[1])
      } ?? []
  }
}

/// An object containing the details about the sent response.
public struct DetailedResponse {
  /// The `HTTP` method that prompted the response.
  let httpMethod: HTTPMethod

  /// The `URI` considered when answering to the started exchange.
  ///
  /// This is intended to give the user a realistic idea of what the server did and did not consider when answering the exchange.
  let uri: URI

  /// The headers associated with the response.
  let headers: HTTPHeaders

  /// The `HTTP` response status code.
  ///
  /// - Access `.code` for the numerical output.
  /// - Access `.reasonPhrase` for the phrasal output.
  let responseStatus: HTTPResponseStatus

  /// The time stamp of when the response was ready.
  let timeStamp: TimeInterval
}

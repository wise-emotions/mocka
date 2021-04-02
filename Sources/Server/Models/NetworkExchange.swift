import Foundation

public extension Models {
  /// An object containing information about the request/response pair.
  /// [RFC2616](https://tools.ietf.org/html/rfc2616) refers to this pair as an exchange.
  struct NetworkExchange {
    /// The object containing the details about the received request.
    public let request: DetailedRequest

    /// The object containing the details about the sent response.
    public let response: DetailedResponse
  }

  /// An object containing the details about the received request.
  struct DetailedRequest {
    /// The `HTTP` method associated with the request.
    public let httpMethod: HTTPMethod

    /// The `URI` that invoked the start of the exchange.
    public let uri: URI

    /// The headers associated with the request.
    public let headers: HTTPHeaders

    /// The timestamp of when the request was invoked.
    public let timestamp: TimeInterval

    /// The list of query items associated with the request.
    public var queryItems: [URLQueryItem] {
      URLComponents(string: uri.string)?.queryItems ?? []
    }
  }

  /// An object containing the details about the sent response.
  struct DetailedResponse {
    /// The `HTTP` method that prompted the response.
    public let httpMethod: HTTPMethod

    /// The `URI` considered when answering to the started exchange.
    ///
    /// This is intended to give the user a realistic idea of what the server did and did not consider when answering the exchange.
    public let uri: URI

    /// The headers associated with the response.
    public let headers: HTTPHeaders

    /// The `HTTP` response status code.
    ///
    /// - Access `.code` for the numerical output.
    /// - Access `.reasonPhrase` for the phrasal output.
    public let responseStatus: HTTPResponseStatus

    /// The timestamp of when the response was ready.
    public let timestamp: TimeInterval
  }
}

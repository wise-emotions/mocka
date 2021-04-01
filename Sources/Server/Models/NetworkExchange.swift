import Foundation

/// An object containing information about the request/response pair.
/// [RFC2616](https://tools.ietf.org/html/rfc2616) refers to this pair as an exchange.
public struct NetworkExchange {
  /// The object containing the details about the received request.
  public let request: DetailedRequest

  /// The object containing the details about the sent response.
  public let response: DetailedResponse

  /// Creates a `NetworkExchange` object.
  /// - Parameters:
  ///   - request: The object containing the details about the received request.
  ///   - response: The object containing the details about the sent response.
  public init(request: DetailedRequest, response: DetailedResponse) {
    self.request = request
    self.response = response
  }
}

/// An object containing the details about the received request.
public struct DetailedRequest {
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

  /// Creates a `DetailedRequest` object.
  /// - Parameters:
  ///   - httpMethod: The `HTTP` method associated with the request.
  ///   - uri: The `URI` that invoked the start of the exchange.
  ///   - headers: The headers associated with the request.
  ///   - timestamp: The timestamp of when the request was invoked.
  public init(httpMethod: HTTPMethod, uri: URI, headers: HTTPHeaders, timestamp: TimeInterval) {
    self.httpMethod = httpMethod
    self.uri = uri
    self.headers = headers
    self.timestamp = timestamp
  }
}

/// An object containing the details about the sent response.
public struct DetailedResponse {
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
  public let status: HTTPResponseStatus

  /// The timestamp of when the response was ready.
  public let timestamp: TimeInterval

  /// Creates a `DetailedResponse` object.
  /// - Parameters:
  ///   - httpMethod: The `HTTP` method that prompted the response.
  ///   - uri: The `URI` considered when answering to the started exchange.
  ///   - headers: The headers associated with the response.
  ///   - status: The `HTTP` response status code.
  ///   - timestamp: The timestamp of when the response was ready.
  public init(httpMethod: HTTPMethod, uri: URI, headers: HTTPHeaders, status: HTTPResponseStatus, timestamp: TimeInterval) {
    self.httpMethod = httpMethod
    self.uri = uri
    self.headers = headers
    self.status = status
    self.timestamp = timestamp
  }
}

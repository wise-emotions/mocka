//
//  Mocka
//

import Combine
import Vapor

/// The `Middleware` that parses all the `Vapor.Response`s of the server to `NetworkExchange`s.
internal final class NetworkExchangeMiddleware: Middleware {
  /// The host associated with the running instance's configuration.
  let host: String?

  /// The `BufferedSubject` of `NetworkExchange`s.
  /// This subject is used to send and subscribe to `NetworkExchange`s.
  /// Anytime a request/response exchange happens, a detailed version of the actors is generated and injected in this object.
  /// - Note: This property is marked `internal` to allow only the `Server` to send events.
  let networkExchangesSubject: BufferedSubject<NetworkExchange, Never>

  /// The port associated with the running instance's configuration.
  let port: Int?

  /// The scheme associated with the running instance's configuration.
  let scheme: URI.Scheme

  init(host: String?, port: Int?, scheme: URI.Scheme, subject: BufferedSubject<NetworkExchange, Never>) {
    self.host = host
    self.port = port
    self.scheme = scheme
    self.networkExchangesSubject = subject
  }

  func respond(to request: Vapor.Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    next.respond(to: request)
      .always { [weak self] result in
        guard let self = self else {
          return
        }

        switch result {
        case let .success(response):
          let networkExchange = self.networkExchange(from: request, and: response)
          self.networkExchangesSubject.send(networkExchange)

        case let .failure(error):
          guard let networkExchange = self.errorNetworkExchange(from: request, error: error) else {
            return
          }

          self.networkExchangesSubject.send(networkExchange)
        }
      }
  }

  /// Clears the buffered log events from the `networkExchangesSubject`.
  func clearBufferedNetworkExchanges() {
    networkExchangesSubject.clearBuffer()
  }
}

// MARK: - Private Helpers

private extension NetworkExchangeMiddleware {
  /// Transforms readable bytes in the buffer to data.
  /// - Parameter buffer: The `ByteBuffer` to read.
  /// - Returns: `Data` read from the `ByteBuffer`. `nil` if `ByteBuffer` is `nil`.
  private func body(from buffer: ByteBuffer?) -> Data? {
    guard var bufferCopy = buffer else {
      return nil
    }

    return bufferCopy.readData(length: bufferCopy.readableBytes)
  }

  /// Parses a `DetailedRequest` from the given `Request` instance.
  /// - Parameter request: The request to be parsed.
  /// - Returns: A new `DetailedRequest` instance.
  func detailedRequest(from request: Vapor.Request) -> DetailedRequest {
    // This property is force-unwrapped because it can never fail,
    // since the raw value passed is an identical copy of SwiftNIO's `HTTPMethod`.
    let httpMethod = HTTPMethod(rawValue: request.method.rawValue)!

    return DetailedRequest(
      httpMethod: httpMethod,
      uri: uri(from: request),
      headers: request.headers,
      body: body(from: request.body.data),
      timestamp: Date().timeIntervalSince1970
    )
  }

  /// Parses a `NetworkExchange` from a failed `request`, trying to parse the given `error` into a network error.
  /// - Parameters:
  ///   - request: The request sent to the server.
  ///   - error: The error that will be parsed into a network error.
  /// - Returns: A new `NetworkExchange` if the parsing succeds.
  func errorNetworkExchange(from request: Vapor.Request, error: Error) -> NetworkExchange? {
    let status = (error as? AbortError)?.status ?? .custom(code: 0, reasonPhrase: error.localizedDescription)

    return NetworkExchange(
      request: detailedRequest(from: request),
      response: DetailedResponse(
        uri: request.url,
        headers: request.headers,
        status: status,
        body: nil,
        timestamp: Date().timeIntervalSince1970
      )
    )
  }

  /// Parses a `NetworkExchange` from the given request and response.
  /// - Parameters:
  ///   - request: The request sent to the server.
  ///   - response: The response sent to the client.
  /// - Returns: A `NetworkExchange` instance built from the input request and response.
  func networkExchange(from request: Vapor.Request, and response: Vapor.Response) -> NetworkExchange {
    NetworkExchange(
      request: detailedRequest(from: request),
      response: DetailedResponse(
        uri: uri(from: request),
        headers: response.headers,
        status: response.status,
        body: response.body.data,
        timestamp: Date().timeIntervalSince1970
      )
    )
  }

  /// Returns an `URI` instance enriched with the `request` information.
  /// - Parameter request: The request from which extract information.
  /// - Returns: A new `URI` instance.
  func uri(from request: Vapor.Request) -> URI {
    URI(scheme: scheme, host: host, port: port, path: request.url.path, query: request.url.query)
  }
}

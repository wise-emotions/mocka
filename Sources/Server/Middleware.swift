//
//  Mocka
//

import Combine
import Vapor

#warning("Document")
internal final class MockaMiddleware: Middleware {
  /// The `BufferedSubject` of `NetworkExchange`s.
  /// This subject is used to send and subscribe to `NetworkExchange`s.
  /// Anytime a request/response exchange happens, a detailed version of the actors is generated and injected in this object.
  /// - Note: This property is marked `internal` to allow only the `Server` to send events.
  let networkExchangesSubject = BufferedSubject<NetworkExchange, Never>()

  func respond(to request: Vapor.Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    next.respond(to: request)
      .always { [weak self] result in
        guard let self = self else {
          return
        }

        let networkExchange: NetworkExchange

        switch result {
        case let .success(response):
          networkExchange = self.networkExchange(from: request, and: response)

        case let .failure(error):
          networkExchange = self.networkExchange(from: request, error: error)
        }
        
        self.networkExchangesSubject.send(networkExchange)
      }
  }
  
  /// Clears the buffered log events from the `networkExchangesSubject`.
  func clearBufferedNetworkExchanges() {
    networkExchangesSubject.clearBuffer()
  }
}

// MARK: - Private Helpers

private extension MockaMiddleware {
  /// Transforms readable bytes in the buffer to data.
  /// - Parameter buffer: The `ByteBuffer` to read.
  /// - Returns: `Data` read from the `ByteBuffer`. `nil` if `ByteBuffer` is `nil`.
  private func body(from buffer: ByteBuffer?) -> Data? {
    guard var bufferCopy = buffer else {
      return nil
    }

    return bufferCopy.readData(length: bufferCopy.readableBytes)
  }
  
  #warning("Document")
  func detailedRequest(from request: Vapor.Request) -> DetailedRequest {
    // This property is force-unwrapped because it can never fail,
    // since the raw value passed is an identical copy of SwiftNIO's `HTTPMethod`.
    let httpMethod = HTTPMethod(rawValue: request.method.rawValue)!

    #warning("The host returned from request doesn't include the value '127.0.0.1' from the configuration short")

    return DetailedRequest(
      httpMethod: httpMethod,
      uri: URI(scheme: URI.Scheme.http, host: request.url.host, port: request.url.port, path: request.url.path),
      headers: request.headers,
      body: body(from: request.body.data),
      timestamp: Date().timeIntervalSince1970
    )
  }
  
  #warning("Document")
  func networkExchange(from request: Vapor.Request, error: Error) -> NetworkExchange {
    let networkError = error as! AbortError
    
    return NetworkExchange(
      request: detailedRequest(from: request),
      response: DetailedResponse(
        uri: request.url,
        headers: request.headers,
        status: networkError.status,
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
    let host = request.url.host
    let port = request.url.port
    let path = request.url.path
    
    return NetworkExchange(
      request: detailedRequest(from: request),
      response: DetailedResponse(
        uri: URI(scheme: URI.Scheme.http, host: host, port: port, path: path),
        headers: response.headers,
        status: response.status,
        body: response.body.data,
        timestamp: Date().timeIntervalSince1970
      )
    )
  }
}

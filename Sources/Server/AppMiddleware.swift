//
//  Mocka
//
import Combine
import Vapor

final class AppMiddleware: Middleware {
  let baseURL: URL
  
  let recordModeNetworkExchangesSubject: PassthroughSubject<NetworkExchange, Never>
  
  let configuration: ServerConnectionConfigurationProvider
  
  init(baseURL: URL, recordModeNetworkExchangesSubject: PassthroughSubject<NetworkExchange, Never>, configuration: ServerConnectionConfigurationProvider) {
    self.baseURL = baseURL
    self.recordModeNetworkExchangesSubject = recordModeNetworkExchangesSubject
    self.configuration = configuration
  }
  
  func respond(to request: Vapor.Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    let requestURL = Vapor.URI(string: "https://ws-test.telepass.com\(request.url.path)")
    let headers = request.headers.removing(name: "Host")
    let clientRequest = ClientRequest(method: request.method, url: requestURL, headers: headers, body: request.body.data)
    
    return request.client.send(clientRequest)
      .flatMap { [weak self] clientResponse -> EventLoopFuture<Response> in
        guard let self = self else {
          return clientResponse.encodeResponse(for: request)
        }
        
        let networkExchange = NetworkExchange(
          request: DetailedRequest(
            httpMethod: HTTPMethod(rawValue: request.method.rawValue)!,
            uri: URI(scheme: URI.Scheme.http, host: self.configuration.hostname, port: self.configuration.port, path: request.url.path, query: request.url.query),
            headers: request.headers,
            body: self.body(from: request.body.data),
            timestamp: Date().timeIntervalSince1970
          ),
          response: DetailedResponse(
            uri: URI(scheme: URI.Scheme.http, host: self.configuration.hostname, port: self.configuration.port, path: request.url.path),
            headers: clientResponse.headers,
            status: clientResponse.status,
            body: self.body(from: clientResponse.body),
            timestamp: Date().timeIntervalSince1970
          )
        )

        self.recordModeNetworkExchangesSubject.send(networkExchange)
        return clientResponse.encodeResponse(for: request)
      }
      .flatMapError { error in
        return request.eventLoop.makeFailedFuture(error)
      }
  }
  
  /// Transforms readable bytes in the buffer to data.
  /// - Parameter buffer: The `ByteBuffer` to read.
  /// - Returns: `Data` read from the `ByteBuffer`. `nil` if `ByteBuffer` is `nil`.
  private func body(from buffer: ByteBuffer?) -> Data? {
    guard var bufferCopy = buffer else {
      return nil
    }

    return bufferCopy.readData(length: bufferCopy.readableBytes)
  }
}

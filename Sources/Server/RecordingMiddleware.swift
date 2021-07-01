//
//  Mocka
//
import Combine
import Vapor

/// The `Middleware` used in the record mode.
/// This class will act as a MITM to intercept network calls to localhost,
/// creating real requests whose response will be sent back to the caller.
final class RecordingMiddleware: Middleware {
  /// The configuration of the middleware.
  let configuration: MiddlewareConfigurationProvider

  /// The `PassthroughSubject` used to send the request and response pair back to the app.
  let recordModeNetworkExchangesSubject: PassthroughSubject<NetworkExchange, Never>
    
  /// Initializes the `RecordingMiddleware.
  /// - Parameters:
  ///   - configuration: The configuration of the middleware.
  ///   - recordModeNetworkExchangesSubject: The `PassthroughSubject` used to send the request and response pair back to the app.
  init(configuration: MiddlewareConfigurationProvider, recordModeNetworkExchangesSubject: PassthroughSubject<NetworkExchange, Never>) {
    self.configuration = configuration
    self.recordModeNetworkExchangesSubject = recordModeNetworkExchangesSubject
  }
  
  func respond(to request: Vapor.Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    let requestURL = Vapor.URI(string: configuration.baseURL.absoluteString + request.url.path)
    let headers = request.headers.removing(name: "Host")
    let clientRequest = ClientRequest(method: request.method, url: requestURL, headers: headers, body: request.body.data)
    
    return request.client.send(clientRequest)
      .flatMap { [weak self] clientResponse -> EventLoopFuture<Response> in
        guard let self = self else {
          return clientResponse.encodeResponse(for: request)
        }

        self.recordModeNetworkExchangesSubject.send(self.networkExchange(from: request, and: clientResponse))
        return clientResponse.encodeResponse(for: request)
      }
      .flatMapError { error in
        return request.eventLoop.makeFailedFuture(error)
      }
  }
}

// MARK: - Helpers

private extension RecordingMiddleware {
  /// Transforms readable bytes in the buffer to data.
  /// - Parameter buffer: The `ByteBuffer` to read.
  /// - Returns: `Data` read from the `ByteBuffer`. `nil` if `ByteBuffer` is `nil`.
  func body(from buffer: ByteBuffer?) -> Data? {
    guard var bufferCopy = buffer else {
      return nil
    }

    return bufferCopy.readData(length: bufferCopy.readableBytes)
  }

  
  /// Creates the `NetworkExchange` based on the `Request` and `ClientResponse` pair.
  /// - Parameters:
  ///   - request: The `Vapor.Request` for the network call.
  ///   - clientResponse: The `ClientResponse` returned by the request, if any.
  /// - Returns: The `NetworkExchange` to be sent back to the app.
  private func networkExchange(from request: Vapor.Request, and clientResponse: ClientResponse) -> NetworkExchange {
    NetworkExchange(
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
  }
}

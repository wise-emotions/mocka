//
//  Mocka
//
import Combine
import Vapor

final class AppMiddleware: Middleware {
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func respond(to request: Vapor.Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    let requestURL = Vapor.URI(string: "https://ws-test.telepass.com\(request.url.path)")
    let headers = request.headers.removing(name: "Host")
    let clientRequest = ClientRequest(method: request.method, url: requestURL, headers: headers, body: request.body.data)
    
    return request.client.send(clientRequest)
      .flatMap { clientResponse -> EventLoopFuture<Response> in
        return clientResponse.encodeResponse(for: request)
      }
      .flatMapError { error in
        return request.eventLoop.makeFailedFuture(error)
      }
  }
}

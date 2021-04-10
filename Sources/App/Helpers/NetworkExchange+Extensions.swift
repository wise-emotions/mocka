//
//  Mocka
//

import MockaServer

extension NetworkExchange: Identifiable {
  /// The unique ID of the network exchange.
  public var id: String {
    "\(request.timestamp)-\(response.timestamp))"
  }
}

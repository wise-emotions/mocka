//
//  Mocka
//

import Foundation
import Server

extension NetworkExchange: Identifiable {
  /// The unique ID of the network exchange.
  public var id: UUID { UUID() }
}

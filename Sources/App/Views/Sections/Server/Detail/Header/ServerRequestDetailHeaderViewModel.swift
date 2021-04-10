//
//  Mocka
//

import MockaServer
import SwiftUI

/// The view model of the `ServerRequestDetailHeaderView`.
struct ServerRequestDetailHeaderViewModel {

  // MARK: Stored Properties

  /// The object containing information about the request/response pair.
  let networkExchange: NetworkExchange

  // MARK: Computed Properties

  /// The `HTTPMethod` of the request.
  var httpMethod: HTTPMethod {
    networkExchange.request.httpMethod
  }

  /// The `HTTPStatus` of the response`
  var httpStatus: UInt {
    networkExchange.response.status.code
  }

  /// The meaning of the respective status code.
  var httpStatusMeaning: String {
    networkExchange.response.status.reasonPhrase
  }

  /// The timestamp of the response.
  var timestamp: String {
    networkExchange.response.timestamp.timestampPrint
  }

  /// The path of the request.
  var path: String {
    networkExchange.request.uri.path
  }
}

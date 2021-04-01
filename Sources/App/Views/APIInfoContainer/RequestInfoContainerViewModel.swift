//
//  Mocka
//

import Server
import SwiftUI

final class RequestInfoContainerViewModel: ObservableObject {

  /// The selection of the SegmentedControl.
  enum Kind: String, CaseIterable {
    /// Request selected.
    case request = "Request"

    /// Response selected.
    case response = "Response"

    var isRequest: Bool {
      self == .request
    }

    var isResponse: Bool {
      self == .response
    }
  }

  // MARK: Stored Properties

  let networkExchange: NetworkExchange

  @Published var kind: Kind = .request

  // MARK: Computed Properties

  var path: String {

    switch kind {
    case .request:
      return request.uri.path
    case .response:
      return response.uri.path
    }
  }

  var queryParameters: [KeyValueItem] {
    request.queryItems.map { KeyValueItem(key: $0.name, value: $0.value ?? "") }
  }

  var headers: [KeyValueItem] {
    switch kind {
    case .request:
      return request.headers.map { KeyValueItem(key: $0.name, value: $0.value) }
    case .response:
      return response.headers.map { KeyValueItem(key: $0.name, value: $0.value) }
    }
  }

  var body: String {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate"
  }

  private var request: DetailedRequest {
    networkExchange.request
  }

  private var response: DetailedResponse {
    networkExchange.response
  }

  // MARK: Initializer

  init(networkExchange: NetworkExchange, kind: Kind) {
    self.networkExchange = networkExchange
    self.kind = kind
  }
}

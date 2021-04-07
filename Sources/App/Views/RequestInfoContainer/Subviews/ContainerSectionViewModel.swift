//
//  Mocka
//

import Foundation
import MockaServer

extension RequestInfoViewModel {
  /// The view model of the `ContainerSectionView`.
  struct ContainerSectionViewModel {

    // MARK: Stored Properties

    /// The object containing information about the request/response pair.
    let networkExchange: NetworkExchange

    /// The kind of info to show inside the container.
    let kind: Kind

    // MARK: Computed Properties

    /// The object containing the details about the request.
    private var request: DetailedRequest {
      networkExchange.request
    }

    /// The object containing the details about the response.
    private var response: DetailedResponse {
      networkExchange.response
    }

    /// The Path of the response or request.
    var path: String {
      switch kind {
      case .request:
        return request.uri.path

      case .response:
        return response.uri.path
      }
    }

    /// The list of `KeyValueItem`for the query parameters.
    var queryParameters: [KeyValueItem] {
      request.queryItems.map { KeyValueItem(key: $0.name, value: $0.value ?? "") }
    }

    /// The list of `KeyValueItem`for the headers.
    var headers: [KeyValueItem] {
      switch kind {
      case .request:
        return request.headers.map { KeyValueItem(key: $0.name, value: $0.value) }

      case .response:
        return response.headers.map { KeyValueItem(key: $0.name, value: $0.value) }
      }
    }

    /// The body of the request or response.
    var body: String {
      switch kind {
      case .request:
        return convertDataToBodyString(request.body)
        
      case .response:
        return convertDataToBodyString(response.body)
      }
    }

    /// Whether the Query section is visible or not.
    var isQuerySectionVisible: Bool {
      kind == .request && queryParameters.isEmpty.isFalse
    }

    /// Whether the Headers section is visible or not.
    var isHeadersSectionVisible: Bool {
      headers.isEmpty.isFalse
    }
    
    // MARK: - Functions
    
    /// Convert the optional `Data` to body `String`.
    private func convertDataToBodyString(_ data: Data?) -> String {
      guard let data = data, let body = String(data: data, encoding: .utf8) else {
        return "Invalid body"
      }
      
      return body
    }
  }
}

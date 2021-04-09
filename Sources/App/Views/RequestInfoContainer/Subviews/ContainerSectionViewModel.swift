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
      formattedBody(for: kind) ?? "Invalid body"
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
    
    /// The formatted body based on `Content-Type`.
    func formattedBody(for kind: Kind) -> String? {
      switch kind {
      case .request:
        guard let contentType = request.headers.contentType, let dataBody = request.body else {
          return nil
        }
        
        switch contentType {
        case .applicationJSON:
          return dataBody.asPrettyPrintedJSON
          
        case .textCSS, .textCSV, .textHTML, .textPlain, .textXML:
          return String(data: dataBody, encoding: .utf8)
        }
        
      case .response:
        guard let contentType = response.headers.contentType, let dataBody = response.body else {
          return nil
        }
        
        switch contentType {
        case .applicationJSON:
          return response.body?.asPrettyPrintedJSON
        
        case .textCSS, .textCSV, .textHTML, .textPlain, .textXML:
          return String(data: dataBody, encoding: .utf8)
        }
      }
    }
  }
}

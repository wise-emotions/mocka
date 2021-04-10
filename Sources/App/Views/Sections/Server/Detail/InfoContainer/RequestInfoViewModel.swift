//
//  Mocka
//

import MockaServer

/// The ViewModel of the `RequestInfoContainerView`.
struct RequestInfoViewModel {
  
  // MARK: - Structured Data
  
  /// The kind of info selected from the SegmentedControl.
  enum Kind: String, CaseIterable {
    /// Request selected.
    case request = "Request"

    /// Response selected.
    case response = "Response"
  }

  // MARK: Stored Properties

  /// The object containing information about the request/response pair.
  let networkExchange: NetworkExchange

  // MARK: Computed Properties

  /// The model for the `ContainerSectionView` of the Request Tab.
  var modelForRequestTab: ContainerSectionViewModel {
    ContainerSectionViewModel(networkExchange: networkExchange, kind: .request)
  }

  /// The model for the `ContainerSectionView` of the Response Tab.
  var modelForResponseTab: ContainerSectionViewModel {
    ContainerSectionViewModel(networkExchange: networkExchange, kind: .response)
  }

  /// The title of the Request Tab.
  var titleForRequestTab: String {
    Kind.request.rawValue
  }

  /// The title of the Response Tab.
  var titleForResponseTab: String {
    Kind.response.rawValue
  }
}


//
//  Mocka
//

import Combine
import Foundation
import MockaServer

/// The ViewModel of the `ServerToolbar`.
final class ServerListViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The text that filters the requests.
  @Published var filterText: String = ""

  /// The array of `NetworkExchange`s.
  @Published var networkExchanges: [NetworkExchange] = []

  /// The `Set` containing the list of subscriptions.
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Computed Properties

  /// The array of `NetworkExchange`s filtered by the `filterText`.
  var filteredNetworkExchanges: [NetworkExchange] {
    if filterText.isEmpty {
      return networkExchanges
    } else {
      return networkExchanges.filter {
        $0.request.uri.string.lowercased().contains(filterText.lowercased())
          || $0.request.httpMethod.rawValue.lowercased().contains(filterText.lowercased())
          || String($0.response.status.code).contains(filterText.lowercased())
      }
    }
  }

  // MARK: - Init

  /// Creates a new instance with a `Publisher` of `NetworkExchange`s.
  /// - Parameter networkExchangesPublisher: The publisher of `NetworkExchange`s.
  init(networkExchangesPublisher: AnyPublisher<NetworkExchange, Never>) {
    networkExchangesPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        self?.networkExchanges.append($0)
      }
      .store(in: &subscriptions)
  }

  // MARK: - Functions

  /// Clears the array of network exchanges.
  func clearNetworkExchanges() {
    networkExchanges.removeAll()
  }
}

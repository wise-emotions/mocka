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

  /// The array of `NetworkExchange`s to be shown in the view.
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
  init(networkExchangesPublisher: AnyPublisher<NetworkExchange, Never>?) {
    networkExchangesPublisher?
      .receive(on: RunLoop.main)
      .sink { [weak self] networkExchange in
        let statusCode = networkExchange.response.status.code
        let isFailedResponse = statusCode >= 300 && statusCode <= 600
        
        if isFailedResponse {
          self?.showNotificationIfAuthorized(for: networkExchange.response)
        }
        
        self?.networkExchanges.append(networkExchange)
      }
      .store(in: &subscriptions)
  }

  // MARK: - Functions

  /// Clears the array of network exchanges.
  func clearNetworkExchanges() {
    networkExchanges.removeAll()
  }
}

// MARK: - Private Helpers

private extension ServerListViewModel {
  /// Shows a local notification for the given `response`.
  /// This will check and evenutally ask for notifications authorization if the user never answered to it.
  /// - Parameter failedResponse: The response just received by the server.
  func showNotificationIfAuthorized(for failedResponse: DetailedResponse) {
    Logic.Settings.Notifications.add(notification: .failedResponse(failedResponse))
  }
}

import Combine
import Foundation
import Server
import SwiftUI

/// A protocol representing a view model.
protocol ViewModel {}

/// A protocol representing an observable view model.
protocol ObservableViewModel: ViewModel, ObservableObject {}

/// The `ViewModel` of the `LogListView`.
final class LogEventListViewModel: ObservableViewModel {
  
  // MARK: - Properties
  
  /// The `Set` containing the list of subscriptions.
  var subscriptions = Set<AnyCancellable>()
  
  /// The array of `LogEvent`s.
  @Published var logEvents: [LogEvent] = []
  
  // MARK: - Init
  
  /// Creates a new instance with a `Publisher` of `LogEvent`s.
  /// - Parameter consoleLogsPublisher: The publisher of `LogEvent`s.
  init(consoleLogsPublisher: AnyPublisher<LogEvent, Never>) {
    consoleLogsPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        self?.logEvents.append($0)
      }
      .store(in: &subscriptions)
  }
}


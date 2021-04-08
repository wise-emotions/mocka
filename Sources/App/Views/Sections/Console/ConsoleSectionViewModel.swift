import Combine
import Foundation
import MockaServer
import SwiftUI

/// The `ViewModel` of the `ConsoleSection`.
final class ConsoleSectionViewModel: ObservableObject {
  
  // MARK: - Properties
  
  /// The text used to filter out the `LogEvent`s.
  @Published var filterText: String = ""
  
  /// The `Set` containing the list of subscriptions.
  var subscriptions = Set<AnyCancellable>()
  
  /// The array of `LogEvent`s.
  @Published private var logEvents: [LogEvent] = []
  
  /// The array of `LogEvent`s filtered by the `filterText`.
  var filteredLogEvents: [LogEvent] {
    if filterText.isEmpty {
      return logEvents
    } else {
      return logEvents.filter {
        $0.level.name.lowercased().contains(filterText.lowercased()) ||
          $0.message.lowercased().contains(filterText.lowercased())
      }
    }
  }
  
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
  
  // MARK: - Functions
  
  /// Clears the array of log events.
  func clearLogEvents() {
    logEvents.removeAll()
  }
}


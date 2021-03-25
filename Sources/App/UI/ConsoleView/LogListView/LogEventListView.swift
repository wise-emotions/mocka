import AppKit
import Combine
import Server
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct LogEventListView: View {
  /// The `ViewModel` of the view.
  @ObservedObject var viewModel: LogEventListViewModel

  var body: some View {
    List {
      ForEach(Array(viewModel.logEvents.enumerated()), id: \.offset) { index, event in
        LogEventCell(
          viewModel: LogEventCellModel(
            logEvent: event,
            isOddCell: !index.isMultiple(of: 2)
          )
        )
      }
      .listRowInsets(EdgeInsets())
    }
  }
}

struct ConsoleView_Previews: PreviewProvider {
  static let subject = PassthroughSubject<LogEvent, Never>()
  
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"),
    count: 10
  )

  static var previews: some View {
    let viewModel = LogEventListViewModel(
      consoleLogsPublisher: events.publisher.eraseToAnyPublisher()
    )
    return LogEventListView(viewModel: viewModel)
  }
}

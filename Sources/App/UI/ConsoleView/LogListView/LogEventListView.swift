import AppKit
import Combine
import Server
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct LogEventListView: View {
  /// The `ViewModel` of the view.
  @ObservedObject var viewModel: LogEventListViewModel

  var body: some View {
    VStack {
      TextField("Filter", text: $viewModel.filterText)
      ScrollView {
        ScrollViewReader { scrollView in
          LazyVStack {
            ForEach(Array(viewModel.filteredLogEvents.enumerated()), id: \.offset) { index, event in
              LogEventCell(
                viewModel: LogEventCellModel(
                  logEvent: event,
                  isOddCell: !index.isMultiple(of: 2)
                )
              )
            }
            .listRowInsets(EdgeInsets())
          }
          .onChange(of: viewModel.filteredLogEvents.count) { _ in
            withAnimation {
              scrollView.scrollTo(viewModel.filteredLogEvents.count - 1)
            }
          }
        }
      }
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

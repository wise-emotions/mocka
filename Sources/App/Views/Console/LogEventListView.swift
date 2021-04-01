import AppKit
import Combine
import Server
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct LogEventListView: View {
  /// The list of log events to show.
  @Binding var logEvents: [LogEvent]
  
  var body: some View {
    ScrollView {
      ScrollViewReader { scrollView in
        LazyVStack {
          ForEach(Array(logEvents.enumerated()), id: \.offset) { index, event in
            LogEventCell(
              viewModel: LogEventCellModel(
                logEvent: event,
                isOddCell: !index.isMultiple(of: 2)
              )
            )
          }
          .listRowInsets(EdgeInsets())
        }
        .onChange(of: logEvents.count) { _ in
          withAnimation {
            scrollView.scrollTo(logEvents.count - 1)
          }
        }
      }
    }
    .background(Color.doppio)
  }
}

struct LogEventListView_Previews: PreviewProvider {
  static let subject = PassthroughSubject<LogEvent, Never>()
  
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"),
    count: 10
  )

  static var previews: some View {
    LogEventListView(logEvents: .constant(events))
  }
}

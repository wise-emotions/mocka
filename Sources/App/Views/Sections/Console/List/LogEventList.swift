//
//  Mocka
//

import MockaServer
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct LogEventList: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: LogEventListViewModel

  var body: some View {
    VStack {
      Divider()

      ScrollView {
        ScrollViewReader { scrollView in
          LazyVStack {
            ForEach(Array(viewModel.filteredLogEvents.enumerated()), id: \.offset) { index, event in
              LogEventListItem(
                viewModel: LogEventListItemViewModel(
                  logEvent: event,
                  isOddCell: index.isMultiple(of: 2)
                )
              )
            }
          }
          .onChange(of: viewModel.filteredLogEvents.count) { _ in
            withAnimation {
              scrollView.scrollTo(viewModel.filteredLogEvents.count - 1)
            }
          }
        }
        .drawingGroup()
      }
      .background(Color.doppio)
    }
    .toolbar {
      ToolbarItem {
        SidebarButton()
      }

      ToolbarItem(placement: .principal) {
        HStack {
          RoundedTextField(title: "Filter", text: $viewModel.filterText)
            .frame(width: Size.minimumFilterTextFieldWidth)

          StartAndStopServerButton()

          RestartServerButton()

          SymbolButton(
            symbolName: .trash,
            action: {
              appEnvironment.server.clearBufferedConsoleLogEvents()
              viewModel.clearLogEvents()
            }
          )
        }
      }
    }
  }
}

struct LogEventListPreviews: PreviewProvider {
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"
    ),
    count: 10
  )

  static var previews: some View {
    LogEventList(viewModel: LogEventListViewModel(consoleLogsPublisher: events.publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())
  }
}

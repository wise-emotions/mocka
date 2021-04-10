//
//  Mocka
//

import MockaServer
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct ConsoleList: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: ConsoleListViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      Divider()

      if viewModel.logEvents.isEmpty {
        EmptyState(symbol: .scroll, text: "Tap the 􀊕 button on the toolbar to start the server")
      } else {
        ScrollView {
          ScrollViewReader { scrollView in
            LazyVStack {
              ForEach(Array(viewModel.filteredLogEvents.enumerated()), id: \.offset) { index, event in
                ConsoleListItem(
                  viewModel: ConsoleListItemViewModel(
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
      }
    }
    .background(Color.doppio)
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

// MARK: - Previews

struct ConsoleListPreviews: PreviewProvider {
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"
    ),
    count: 10
  )

  static var previews: some View {
    ConsoleList(viewModel: ConsoleListViewModel(consoleLogsPublisher: events.publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())

    ConsoleList(viewModel: ConsoleListViewModel(consoleLogsPublisher: [].publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())
  }
}

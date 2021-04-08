import AppKit
import Combine
import MockaServer
import SwiftUI

/// The view that displays a list of `LogEvent`s.
struct LogEventList: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment
  
  /// The view model of the console section.
  @StateObject var viewModel: ConsoleSectionViewModel
  
  var body: some View {
    VStack {
      Divider()
      ScrollView {
        ScrollViewReader { scrollView in
          LazyVStack {
            ForEach(Array(viewModel.filteredLogEvents.enumerated()), id: \.offset) { index, event in
              LogEventListItem(
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
        .background(Color.doppio)
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          HStack {
            RoundedTextField(title: "Filter", text: $viewModel.filterText)
              .frame(width: Size.minimumFilterTextFieldWidth)
            
            SymbolButton(
              symbolName: appEnvironment.isServerRunning ? .stopCircle : .playCircle,
              action: {
                switch appEnvironment.isServerRunning {
                case true:
                  try? appEnvironment.server.stop()
                  
                case false:
                  try? appEnvironment.server.start(with: ServerConfiguration(requests: []))
                }
                
                appEnvironment.isServerRunning.toggle()
              }
            )
            
            SymbolButton(
              symbolName: .memories,
              action: {
                try? appEnvironment.server.restart(with: ServerConfiguration(requests: []))
              }
            )
            .disabled(!appEnvironment.isServerRunning)
            
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
      .background(Color.doppio)
    }
  }
}

struct LogEventListView_Previews: PreviewProvider {
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"
    ),
    count: 10
  )
  
  static var previews: some View {
    LogEventList(viewModel: ConsoleSectionViewModel(consoleLogsPublisher: events.publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())
  }
}

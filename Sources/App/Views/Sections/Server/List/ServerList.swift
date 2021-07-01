//
//  Mocka
//

import MockaServer
import SwiftUI

/// The server list view.
/// This view handle the list of all the API called to the server.
struct ServerList: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: ServerListViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      Divider()

      if viewModel.networkExchanges.isEmpty {
        EmptyState(symbol: .scroll, text: "Tap the 􀊕 button on the toolbar to start the server")
      } else {
        ScrollViewReader { scrollView in
          List(Array(viewModel.filteredNetworkExchanges.enumerated()), id: \.offset) { index, networkExchange in
            NavigationLink(
              destination: ServerDetail(
                viewModel: ServerDetailViewModel(
                  networkExchange: networkExchange
                )
              )
            ) {
              ServerListItem(viewModel: ServerListItemViewModel(networkExchange: networkExchange))
            }
          }
          .padding(.top, -8)
          .onChange(of: viewModel.filteredNetworkExchanges.count) { _ in
            withAnimation {
              scrollView.scrollTo(viewModel.filteredNetworkExchanges.count - 1)
            }
          }
        }
      }
    }
    .background(Color.doppio)
    .frame(minWidth: Size.minimumListWidth)
    .toolbar {
      ToolbarItem {
        HStack {
          SidebarButton()

          RoundedTextField(title: "Filter", size: .medium, text: $viewModel.filterText)
            .frame(width: Size.minimumFilterTextFieldWidth)

          StartAndStopServerButton()

          RestartServerButton()

          SymbolButton(
            symbolName: .trash,
            action: {
              appEnvironment.server.clearBufferedNetworkExchanges()
              viewModel.clearNetworkExchanges()
            }
          )
          
          StartAndStopRecordModeButton()
        }
      }
    }
  }
}

// MARK: - Previews

struct ServerListPreviews: PreviewProvider {
  static let networkExchanges = [NetworkExchange](
    repeating: NetworkExchange.mock,
    count: 10
  )

  static var previews: some View {
    ServerList(viewModel: ServerListViewModel(networkExchangesPublisher: networkExchanges.publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())

    ServerList(viewModel: ServerListViewModel(networkExchangesPublisher: [].publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())
  }
}

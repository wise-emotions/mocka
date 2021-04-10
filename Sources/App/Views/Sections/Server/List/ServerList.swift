//
//  Mocka
//

import MockaServer
import SwiftUI

/// The server list view.
/// This view handle the list of all the API called to the server.
struct ServerList: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: ServerListViewModel

  var body: some View {
    VStack {
      Divider()

      ScrollViewReader { scrollView in
        List(Array(viewModel.filteredNetworkExchanges.enumerated()), id: \.offset) { index, networkExchange in
          NavigationLink(destination: Text(networkExchange.response.uri.path)) {
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
      .background(Color.doppio)
      .frame(minWidth: Size.minimumListWidth)
    }
    .toolbar {
      ToolbarItem {
        HStack {
          SymbolButton(
            symbolName: .sidebarSquaresLeft,
            action: {
              NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
            }
          )

          RoundedTextField(title: "Filter", text: $viewModel.filterText)
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
        }
      }
    }
  }
}

struct ServerListPreviews: PreviewProvider {
  static let networkExchanges = [NetworkExchange](
    repeating: NetworkExchange.mock,
    count: 10
  )

  static var previews: some View {
    ServerList(viewModel: ServerListViewModel(networkExchangesPublisher: networkExchanges.publisher.eraseToAnyPublisher()))
      .environmentObject(AppEnvironment())
  }
}

//
//  Mocka
//

import MockaServer
import SwiftUI

struct ServerList: View {
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated view model.
  @StateObject var viewModel = ServerListViewModel()

  /// The list of all the server calls.
  @Binding var networkExchanges: [NetworkExchange]

  var body: some View {
    VStack {
      List(networkExchanges) { networkExchange in
        NavigationLink(destination: Text(networkExchange.response.uri.path)) {
          ServerListItem(
            httpMethod: networkExchange.request.httpMethod,
            httpStatus: networkExchange.response.status.code,
            httpStatusMeaning: networkExchange.response.status.reasonPhrase,
            timestamp: networkExchange.response.timestamp.timestampPrint,
            path: networkExchange.response.uri.path
          )
        }
      }
      .background(Color.doppio)
    }
    .frame(minWidth: Size.minimumListWidth)
    .background(Color.doppio)
    .toolbar {
      ToolbarItem {
        SymbolButton(
          symbolName: .sidebarSquaresLeft,
          action: {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
          }
        )
      }

      ToolbarItem {
        FilterTextField(text: $viewModel.filterText)
          .frame(minWidth: Size.minimumFilterTextFieldWidth, maxWidth: .infinity)
      }

      ToolbarItemGroup {
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
          action: {}
        )
      }
    }
  }
}

struct ServerListPreviews: PreviewProvider {
  static let networkExchanges = [NetworkExchange.mock]

  static var previews: some View {
    ServerList(networkExchanges: .constant(networkExchanges))
      .environmentObject(AppEnvironment())
  }
}

//
//  Mocka
//

import MockaServer
import SwiftUI

/// This is the server section of the app.
/// It shows the list of the `NetworkExchange`s and its details.
struct ServerSection: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  // MARK: - Body

  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)

      ServerList(viewModel: ServerListViewModel(networkExchangesPublisher: appEnvironment.server.networkExchangesPublisher))

      ServerDetail()
    }
    .background(Color.doppio)
  }
}

// MARK: - Previews

struct ServerSectionPreview: PreviewProvider {
  static var previews: some View {
    ServerSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

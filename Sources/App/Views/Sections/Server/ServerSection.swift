//
//  Mocka
//

import Foundation
import Server
import SwiftUI

/// This is the server section of the app.
/// It shows the list of the `NetworkExchange`s and its details.
struct ServerSection: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)

      ServerList(networkExchanges: .constant([]))

      ServerDetail()
    }
  }
}

struct ServerSectionPreview: PreviewProvider {
  static var previews: some View {
    ServerSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

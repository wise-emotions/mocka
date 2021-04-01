//
//  Mocka
//

import Foundation
import SwiftUI
import Server

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

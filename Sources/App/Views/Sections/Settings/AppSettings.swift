//
//  Mocka
//

import SwiftUI

/// This is the main app settings `Settings`.
struct AppSettings: View {

  // MARK: - Body

  var body: some View {
    TabView {
      ServerSettings(viewModel: ServerSettingsViewModel(isShownFromSettings: true))
        .tabItem {
          Label("Server", systemImage: SFSymbol.document.rawValue)
        }
      
      NotificationsSettings()
        .tabItem {
          #warning("Update icon")
          Label("Notifications", systemImage: SFSymbol.document.rawValue)
        }
    }
  }
}

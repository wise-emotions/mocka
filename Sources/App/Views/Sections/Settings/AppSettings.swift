//
//  Mocka
//

import SwiftUI

/// This is the main app settings `Settings`.
struct AppSettings: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  // MARK: - Body

  var body: some View {
    TabView {
      ServerSettings(viewModel: ServerSettingsViewModel(isShownFromSettings: true))
        .tabItem {
          Label("Server", systemImage: SFSymbol.document.rawValue)
        }

      NotificationsSettings(viewModel: NotificationsSettingsViewModel(areInAppNotificationEnabled: appEnvironment.areInAppNotificationEnabled))
        .tabItem {
          Label("Notifications", systemImage: SFSymbol.bell.rawValue)
        }
    }
    .padding(25)
    .frame(minWidth: 0, maxWidth: .infinity, alignment: .top)
  }
}

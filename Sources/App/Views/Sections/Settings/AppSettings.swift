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
    }
  }
}

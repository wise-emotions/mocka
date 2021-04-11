//
//  Mocka
//

import SwiftUI

/// This is the main app settings `Settings`.
struct AppSettings: View {

  // MARK: - Body

  var body: some View {
    TabView {
      ServerSettings(isShownFromSettings: true)
        .tabItem {
          Label("Server", systemImage: SFSymbol.document.rawValue)
        }
    }
  }
}

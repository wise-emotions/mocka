//
//  Mocka
//

import SwiftUI

struct ServerSettings: View {
  var body: some View {
    TabView {
      StartupSettings(isShownFromSettings: true)
        .tabItem {
          Label("Server", systemImage: SFSymbol.document.rawValue)
        }
    }
  }
}

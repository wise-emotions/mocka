//
//  Mocka
//

import SwiftUI

/// The sidebar button that allows the user to close or open the app sidebar.
struct SidebarButton: View {

  // MARK: - Body

  var body: some View {
    SymbolButton(
      symbolName: .sidebarSquaresLeft,
      action: {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
      }
    )
  }
}

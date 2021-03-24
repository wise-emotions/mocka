import SwiftUI

/// A sidebar displaying the main sections of the app.
struct Sidebar: View {
  /// The selected section.
  @Binding var selectedSection: SidebarSection

  /// The shared window manager instance.
  @EnvironmentObject var windowManager: WindowManager

  var body: some View {
    VStack {
      ForEach(SidebarSection.allCases, id: \.rawValue) { section in
        Item(section: section, selectedSection: $selectedSection)
      }
      Spacer()
    }
    .padding(.top, windowManager.titleBarHeight(to: .add))
    .background(Color("TertiaryColor"))
    .frame(minWidth: Constants.sidebarWidth, maxWidth: Constants.sidebarWidth)
  }
}

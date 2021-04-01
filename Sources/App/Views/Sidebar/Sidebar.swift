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
        Item(selectedSection: $selectedSection, section: section)
      }
      Spacer()
    }
    .padding(.top, windowManager.titleBarHeight(to: .add))
    .background(Color.lungo)
    .frame(minWidth: Constants.fixedSidebarWidth, maxWidth: Constants.fixedSidebarWidth)
  }
}

struct SidebarPreviews: PreviewProvider {
  static var previews: some View {
    Group {
      Sidebar(selectedSection: .constant(.server))
        .previewDisplayName("Server")
        .environmentObject(WindowManager.shared)

      Sidebar(selectedSection: .constant(.editor))
        .previewDisplayName("Editor")
        .environmentObject(WindowManager.shared)

      Sidebar(selectedSection: .constant(.console))
        .previewDisplayName("Console")
        .environmentObject(WindowManager.shared)
    }
  }
}

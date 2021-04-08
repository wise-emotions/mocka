//
//  Mocka
//

import SwiftUI

/// A sidebar displaying the main sections of the app.
struct Sidebar: View {
  /// The selected section.
  @Binding var selectedSection: SidebarSection

  var body: some View {
    VStack {
      ForEach(SidebarSection.allCases, id: \.rawValue) { section in
        SidebarItem(selectedSection: $selectedSection, section: section)
      }
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct SidebarPreviews: PreviewProvider {
  static var previews: some View {
    Group {
      Sidebar(selectedSection: .constant(.server))
        .previewDisplayName("Server")

      Sidebar(selectedSection: .constant(.editor))
        .previewDisplayName("Editor")

      Sidebar(selectedSection: .constant(.console))
        .previewDisplayName("Console")
    }
  }
}

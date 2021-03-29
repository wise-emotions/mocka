import Foundation
import SwiftUI

struct AppSection: View {
  /// The selected section.
  @Binding var selectedSection: SidebarSection

  var body: some View {
    HStack {
      switch selectedSection {
      case .server:
        ServerSection()
      case .editor:
        ServerSection()
      case .console:
        ServerSection()
      }
    }
    .frame(minWidth: Constants.minimumAppSectionWidth, alignment: .leading)
  }
}

struct AppSectionPreview: PreviewProvider {
  static var previews: some View {
    AppSection(selectedSection: .constant(.server))
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(WindowManager.shared)
  }
}

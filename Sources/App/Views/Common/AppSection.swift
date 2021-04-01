import Server
import SwiftUI

struct AppSection: View {
  /// The server instance of the app.
  @EnvironmentObject var server: Server

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
        ConsoleSection(
          viewModel:
            ConsoleSectionViewModel(
              consoleLogsPublisher: server.consoleLogsPublisher
            )
        )
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

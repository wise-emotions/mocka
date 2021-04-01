import Server
import SwiftUI

@main
struct Mocka: App {
  /// The `AppDelegate` of the app.
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  /// The `WindowManager` environment object.
  @StateObject var windowManager = WindowManager.shared

  /// The `Server` environment object.
  @StateObject var server = Server()

  /// The associated view model.
  @StateObject var viewModel = MockaViewModel()

  var body: some Scene {
    WindowGroup {
      HStack(spacing: 0) {
        Sidebar(selectedSection: $viewModel.selectedSection)
          .padding(.top, windowManager.titleBarHeight(to: .remove))
          .environmentObject(windowManager)

        AppSection(selectedSection: $viewModel.selectedSection)
          .environmentObject(windowManager)
          .environmentObject(server)
      }
      .frame(
        minWidth: Constants.fixedSidebarWidth + Constants.minimumListWidth + Constants.minimumDetailWidth + 1,
        maxWidth: .infinity,
        minHeight: Constants.minimumAppHeight,
        maxHeight: .infinity,
        alignment: .leading
      )
    }
    .windowStyle(HiddenTitleBarWindowStyle())
    .commands {
      CommandGroup(replacing: .newItem) {}
    }
  }
}

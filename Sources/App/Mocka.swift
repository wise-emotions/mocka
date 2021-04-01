//
//  Mocka
//

import SwiftUI

@main
struct Mocka: App {
  /// The `AppDelegate` of the app.
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  /// The app environment.
  @StateObject private var appEnvironment = AppEnvironment()

  var body: some Scene {
    WindowGroup {
      AppSection()
        .frame(
          minWidth: .minimumSidebarWidth + .minimumListWidth + .minimumDetailWidth + 5,
          maxWidth: .infinity,
          minHeight: .minimumAppHeight,
          maxHeight: .infinity,
          alignment: .leading
        )
        .environmentObject(appEnvironment)
    }
    .windowStyle(HiddenTitleBarWindowStyle())
    .windowToolbarStyle(UnifiedWindowToolbarStyle())
    .commands {
      SidebarCommands()
      CommandGroup(replacing: .newItem) {}
    }
  }
}

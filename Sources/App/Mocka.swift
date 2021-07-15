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
      AppSection(viewModel: AppSectionViewModel(recordModeNetworkExchangesPublisher: appEnvironment.server.recordModeNetworkExchangesPublisher, appEnvironment: appEnvironment))
        .frame(
          // Due to a bug of the `NavigationView` we cannot use the exactly minimum size.
          // We add `5` points to be sure to not close the sidebar while resizing the view.
          minWidth: Size.minimumSidebarWidth + Size.minimumListWidth + Size.minimumDetailWidth + 5,
          maxWidth: .infinity,
          minHeight: Size.minimumAppHeight,
          maxHeight: .infinity,
          alignment: .leading
        )
        .environmentObject(appEnvironment)
        .sheet(
          isPresented: $appEnvironment.shouldShowStartupSettings
        ) {
          ServerSettings(viewModel: ServerSettingsViewModel(isShownFromSettings: false))
        }
        .sheet(
          isPresented: $appEnvironment.isRecordModeSettingsPresented
        ) {
          RecordModeSettings(viewModel: RecordModeSettingsViewModel(appEnvironment: appEnvironment))
            .environmentObject(appEnvironment)
        }

    }
    .windowStyle(HiddenTitleBarWindowStyle())
    .windowToolbarStyle(UnifiedWindowToolbarStyle())
    .commands {
      SidebarCommands()
      CommandGroup(replacing: .newItem) {}
    }

    Settings {
      AppSettings()
        .environmentObject(appEnvironment)
    }
  }
}

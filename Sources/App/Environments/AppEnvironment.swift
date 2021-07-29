//
//  Mocka
//

import MockaServer
import SwiftUI
import UserNotifications

/// App environment object shared by all the `View`s of the application.
final class AppEnvironment: ObservableObject {
  /// Whether or not the in-app notifications are enabled.
  var areInAppNotificationEnabled: Bool = Logic.Settings.areInAppNotificationEnabled {
    willSet {
      objectWillChange.send()
    }
    didSet {
      Logic.Settings.areInAppNotificationEnabled = areInAppNotificationEnabled
    }
  }

  /// Whether the server is currently running.
  @Published var isServerRunning: Bool = false

  /// The selected app section, selected by using the app's Sidebar.
  @Published var selectedSection: SidebarSection = .server

  /// The `Server` instance of the app.
  @Published var server: AppServer = AppServer()

  /// Whether the startup settings should be shown or not.
  @Published var shouldShowStartupSettings = !Logic.Settings.isWorkspaceURLValid

  /// The global server configuration.
  var serverConfiguration: ServerConfiguration? {
    Logic.Settings.serverConfiguration
  }
}

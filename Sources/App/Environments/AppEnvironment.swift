//
//  Mocka
//

import Combine
import MockaServer
import SwiftUI

/// App environment object shared by all the `View`s of the application.
final class AppEnvironment: ObservableObject {
  /// Whether or not the in-app notifications are enabled.
  @Published var areInAppNotificationEnabled: Bool = Logic.Settings.Notifications.areInAppNotificationEnabled {
    didSet {
      Logic.Settings.Notifications.areInAppNotificationEnabled = areInAppNotificationEnabled
    }
  }

  /// The subscription for mapping the failed requests into `InAppNotifications`.
  var failedRequestsNotificationSubscription: AnyCancellable?

  /// Whether the server is currently running.
  @Published var isServerRunning: Bool = false {
    didSet {
      Logic.Settings.Notifications.updateFailedRequestsNotificationSubscription(in: self)
    }
  }

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

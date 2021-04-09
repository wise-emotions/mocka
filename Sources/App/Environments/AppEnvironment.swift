//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI

/// App environment object shared by all the `View`s of the application.
final class AppEnvironment: ObservableObject {
  /// Whether the server is currently running.
  @Published var isServerRunning: Bool = false

  /// The selected app section, selected by using the app's Sidebar.
  @Published var selectedSection: SidebarSection = .server

  /// The `Server` instance of the app.
  @Published var server: AppServer = AppServer()

  /// Whether the startup settings should be shown or not.
  @Published var shouldShowStartupSettings = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) == nil

  /// The value of the workspace path.
  /// When this value is updated, the value in the user defaults is updated as well.
  @AppStorage(UserDefaultKey.workspaceURL) var workspaceURL: URL?
}

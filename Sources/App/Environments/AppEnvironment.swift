//
//  Mocka
//

import Foundation
import MockaServer

/// App environment object shared by all the `View`s of the application.
final class AppEnvironment: ObservableObject {
  /// The `Server` instance of the app.
  @Published var server: AppServer = AppServer()

  /// The selected app section, selected by using the app's Sidebar.
  @Published var selectedSection: SidebarSection = .server

  /// Whether the server is currently running.
  @Published var isServerRunning: Bool = false
}
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

  /// The server project root path.
  @Published var projectRootPath: URL? = Logic.RootPath.value

  /// The selected app section, selected by using the app's Sidebar.
  @Published var selectedSection: SidebarSection = .server

  /// The `Server` instance of the app.
  @Published var server: AppServer = AppServer()
}

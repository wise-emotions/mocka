//
//  Mocka
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // Disable the Tab Bar feature.
    disableTabBar()
  }
}

extension AppDelegate {
  /// Disables the Tab Bar feature of the app.
  private func disableTabBar() {
    // Search for the current `window`.
    guard let window = NSApplication.shared.windows.first else {
      return
    }

    window.tabbingMode = .disallowed
  }
}

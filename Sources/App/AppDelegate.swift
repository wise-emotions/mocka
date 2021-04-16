//
//  Mocka
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // Force dark mode.
    NSApp.appearance = NSAppearance(named: .darkAqua)

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

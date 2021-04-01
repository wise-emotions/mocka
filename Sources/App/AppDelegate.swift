import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // Disable the Tab Bar feature.
    disableTabBar()
    // Set the window delegate.
    registerWindowDelegate()
    // Set the initial value of `isFullScreen` property.
    setIsFullScreen()
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

extension AppDelegate: NSWindowDelegate {
  /// Set `self` as `NSWindowDelegate`.
  private func registerWindowDelegate() {
    // Search for the current `window`.
    guard let window = NSApplication.shared.windows.first else {
      return
    }

    window.delegate = self
  }

  /// Set `isFullScreen` to its initial correct value.
  private func setIsFullScreen() {
    // Search for the current `window`.
    guard let window = NSApplication.shared.windows.first else {
      return
    }

    // If the window frame is the same as the screen one,
    // the app has been opened in full-screen mode.
    WindowManager.shared.isFullScreen = window.frame == NSScreen.main?.frame
  }

  func windowWillEnterFullScreen(_ notification: Notification) {
    WindowManager.shared.isFullScreen = true
  }

  func windowWillExitFullScreen(_ notification: Notification) {
    WindowManager.shared.isFullScreen = false
  }
}

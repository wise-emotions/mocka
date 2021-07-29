//
//  Mocka
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
  /// The app environment.
  @ObservedObject var appEnvironment = AppEnvironment()

  var statusItem: NSStatusItem!

  func applicationDidFinishLaunching(_ notification: Notification) {
    // Disable the Tab Bar feature.
    disableTabBar()

    setupStatusItem()
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

  private func setupStatusItem() {
    // The menu in the `statusItem`.
    let menu = NSMenu()

    // Use a SwiftUI View as menu.
    // We can use the appEnvironment to disable not available actions,
    // but we have experimented some bugs on the tap of the buttons inside the manu view
    // when the app is in background.
    let statusItemMenu = StatusItemMenu() { [weak self] in
      self?.statusItem.menu?.cancelTracking()
    }
    .environmentObject(appEnvironment)

    let menuItemView = NSHostingView(rootView: statusItemMenu)
    // Don't forget to set the frame, otherwise it won't be shown.
    menuItemView.frame = NSRect(x: 0, y: 0, width: 200, height: 80)
    let menuItem = NSMenuItem()
    menuItem.view = menuItemView
    menu.addItem(menuItem)

    // Old style of menu using AppKit.
    // We cannot use the appEnvironment in this case.
    // But there are no bugs on the tap of the items in this way.
    menu.addItem(withTitle: "Start Server", action: #selector(startServer), keyEquivalent: "")
    menu.addItem(withTitle: "Stop Server", action: nil, keyEquivalent: "")
    menu.addItem(withTitle: "Restart Server", action: nil, keyEquivalent: "")

    // StatusItem is stored as a class property.
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    statusItem?.menu = menu
    statusItem.button?.image = #imageLiteral(resourceName: "AppIcon")
    statusItem.button?.imageScaling = .scaleProportionallyUpOrDown
  }

  @objc func startServer() {
    print("Start Server")
  }
}

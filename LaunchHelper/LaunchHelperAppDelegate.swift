//
//  Mocka
//

import AppKit

final class LaunchHelperAppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    let mainBundleIdentifier = "com.wisemotions.MockaApp"

    let runningApplications = NSWorkspace.shared.runningApplications

    guard !runningApplications.contains(where: { $0.bundleIdentifier == mainBundleIdentifier }) else {
      NSApp.terminate(nil)
      return
    }

    var path = Bundle.main.bundlePath as NSString

    for _ in 1...4 {
      path = path.deletingLastPathComponent as NSString
    }
    path.appendingPathComponent("MacOS")
    path.appendingPathComponent("Mocka")

    guard let appURL = URL(string: path as String) else {
      return
    }

    NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration())
  }
}

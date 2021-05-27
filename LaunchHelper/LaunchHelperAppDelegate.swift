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

    let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
    let mainPath = NSString.path(withComponents: Array(pathComponents[0 ... pathComponents.count - 5]))

    guard let appURL = URL(string: mainPath) else {
      return
    }

    NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration())
  }
}

//
//  Mocka
//

import Cocoa

let delegate = LaunchHelperAppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

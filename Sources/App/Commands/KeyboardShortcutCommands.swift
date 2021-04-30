//
//  Mocka
//

import SwiftUI

struct KeyboardShortcutCommands: Commands {
  @ObservedObject var appEnvironment: AppEnvironment

  var body: some Commands {
    CommandGroup(replacing: .newItem) {
      Button("New API") {
        appEnvironment.selectedSection = .editor

      }
      .keyboardShortcut("n")
      
      Button("Run") {
        appEnvironment.selectedSection = .server
        
        guard let serverConfiguration = appEnvironment.serverConfiguration else {
          appEnvironment.shouldShowStartupSettings = true
          return
        }

        try? appEnvironment.server.start(with: serverConfiguration)
        
        appEnvironment.isServerRunning = true
      }
      .keyboardShortcut("r")
      
      Button("Stop") {
        appEnvironment.selectedSection = .server
        
        try? appEnvironment.server.stop()
        
        appEnvironment.isServerRunning = false
      }
      .keyboardShortcut(".")
    }
    
    CommandGroup(after: .windowArrangement) {
      Button("Server") {
        appEnvironment.selectedSection = .server
      }
      .keyboardShortcut("1")
      
      Button("Editor") {
        appEnvironment.selectedSection = .editor
      }
      .keyboardShortcut("2")
      
      Button("Console") {
        appEnvironment.selectedSection = .console
      }
      .keyboardShortcut("3")
    }
  }
}

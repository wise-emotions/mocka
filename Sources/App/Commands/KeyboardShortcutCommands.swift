//
//  Mocka
//

import SwiftUI

struct KeyboardShortcutCommands: Commands {
  @ObservedObject var appEnvironment: AppEnvironment

  var body: some Commands {
    CommandGroup(replacing: .newItem) {
      Button("Add new API") {
        appEnvironment.selectedSection = .editor
      }
      .keyboardShortcut("n")
    }
  }
}

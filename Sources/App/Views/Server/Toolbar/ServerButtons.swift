import Foundation
import SwiftUI

/// A stack of buttons to execute commands on the server.
struct ServerButtons: View {
  /// Whether the server is currently running.
  let isServerRunning: Bool

  /// The start and stop server action.
  let startAndStopAction: () -> Void

  /// The restart server action.
  let restartAction: () -> Void

  /// The delete API call list action.
  let deleteAction: () -> Void

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 10) {
      SymbolButton(
        symbolName: isServerRunning ? "stop.circle" : "play.circle",
        action: startAndStopAction
      )
      SymbolButton(
        symbolName: "memories",
        action: restartAction
      )
      .disabled(!isServerRunning)

      SymbolButton(
        symbolName: "trash",
        action: deleteAction
      )
    }
  }
}

struct ServerButtonsPreview: PreviewProvider {
  static var previews: some View {
      ServerButtons(
        isServerRunning: false,
        startAndStopAction: {},
        restartAction: {},
        deleteAction: {}
      )
  }
}

struct ServerButtonsLibraryContent: LibraryContentProvider {
  let isServerRunning = false
  let startAndStopAction: () -> Void = {}
  let restartAction: () -> Void = {}
  let deleteAction: () -> Void = {}

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(
      ServerButtons(
        isServerRunning: isServerRunning,
        startAndStopAction: startAndStopAction,
        restartAction: restartAction,
        deleteAction: restartAction
      )
    )
  }
}

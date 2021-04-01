import Server
import SwiftUI

/// A toolbar view for the server.
struct ServerToolbar: View {
  /// The associated view model.
  @StateObject var viewModel = ServerToolbarViewModel()

  /// The `Server` environment object.
  @EnvironmentObject var server: Server

  /// Whether the server is currently running.
  @Binding var isServerRunning: Bool

  var body: some View {
    HStack(spacing: 16) {
      RoundedTextField(
        text: $viewModel.filterText
      )
      ServerButtons(
        isServerRunning: isServerRunning,
        startAndStopAction: startAndStopServer,
        restartAction: restartServer,
        deleteAction: emptyList
      )
    }
    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
    .background(Color.doppio)
  }

  /// Starts or stops the server depending on whether it is running or not.
  private func startAndStopServer() {
    switch isServerRunning {
    case true:
      try? server.stop()
    case false:
      try? server.start(with: ServerConfiguration(requests: []))
    }

    isServerRunning.toggle()
  }

  /// Restarts the server.
  private func restartServer() {
    try? server.restart(with: ServerConfiguration(requests: []))
  }

  /// Empties the list of requests.
  private func emptyList() {}
}

struct ServerToolbarPreview: PreviewProvider {
  static var previews: some View {
    Group {
      ServerToolbar(isServerRunning: .constant(false))
        .previewDisplayName("ServerToolbar with server not running")

      ServerToolbar(isServerRunning: .constant(true))
        .previewDisplayName("ServerToolbar with server running")
    }
    .previewLayout(.fixed(width: 370, height: 48))
  }
}

struct ServerToolbarLibraryContent: LibraryContentProvider {
  let isServerRunning: Binding<Bool> = .constant(false)

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(ServerToolbar(isServerRunning: isServerRunning))
  }
}

import SwiftUI

/// A toolbar view for the server.
struct ServerToolbar: View {
  @StateObject var viewModel = ServerToolbarViewModel()

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
    .background(Color("PrimaryColor"))
  }

  /// Starts or stops the server depending on whether it is running or not.
  private func startAndStopServer() {
    isServerRunning.toggle()
  }

  /// Restarts the server.
  private func restartServer() {}

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

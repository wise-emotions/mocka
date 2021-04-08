//
//  Mocka
//

import SwiftUI

/// The restart server button.
/// This button automatically handles the restart of the server
/// by using the `AppEnvironment`.
struct RestartServerButton: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: RestartServerButtonViewModel = RestartServerButtonViewModel()

  var body: some View {
    SymbolButton(
      symbolName: .memories,
      action: {
        viewModel.restartRunningServer(on: appEnvironment)
      }
    )
    .disabled(!appEnvironment.isServerRunning)
  }
}

//
//  Mocka
//

import SwiftUI

/// The start and stop server button.
/// This button automatically handles the start and stop of the server
/// by using the `AppEnvironment`.
struct StartAndStopServerButton: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: StartAndStopServerButtonViewModel = StartAndStopServerButtonViewModel()

  // MARK: - Body

  var body: some View {
    SymbolButton(
      symbolName: appEnvironment.isServerRunning ? .stopCircle : .playCircle,
      action: {
        viewModel.startAndStopRunningServer(on: appEnvironment)
      }
    )
  }
}

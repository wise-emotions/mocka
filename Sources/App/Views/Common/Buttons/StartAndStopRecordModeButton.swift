//
//  Mocka
//

import SwiftUI

/// The start and stop record mode button.
/// This button automatically handles the start and stop of the record mode
/// by using the `AppEnvironment`.
struct StartAndStopRecordModeButton: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: StartAndStopRecordModeButtonViewModel = StartAndStopRecordModeButtonViewModel()

  // MARK: - Body

  var body: some View {
    SymbolButton(
      symbolName: appEnvironment.isServerRecording ? .stopCircle : .startRecording,
      color: appEnvironment.isServerRunning ? Color.redEye : nil,
      action: {
        if appEnvironment.middlewareConfiguration == nil {
          appEnvironment.isRecordModeSettingsPresented.toggle()
        } else {
          viewModel.startAndStopRecordMode(on: appEnvironment)
        }
      }
    )
  }
}

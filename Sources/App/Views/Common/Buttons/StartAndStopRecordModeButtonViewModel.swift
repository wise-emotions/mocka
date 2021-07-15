//
//  Mocka
//

import Foundation

/// The ViewModel of the `ServerToolbar`.
final class StartAndStopRecordModeButtonViewModel: ObservableObject {

  // MARK: - Functions

  /// Start and stop the record mode.
  /// - Parameter appEnvironment: The `AppEnvironment` instance.
  func startAndStopRecordMode(on appEnvironment: AppEnvironment) {
    switch appEnvironment.isServerRecording {
    case true:
      try? appEnvironment.server.stop()
      
      appEnvironment.isServerRunning.toggle()
      appEnvironment.isServerRecording.toggle()
      
    case false:
      appEnvironment.isRecordModeSettingsPresented.toggle()
    }
  }
}

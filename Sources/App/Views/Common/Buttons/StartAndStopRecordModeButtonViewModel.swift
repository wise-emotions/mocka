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

    case false:
      guard let middlewareConfiguration = appEnvironment.middlewareConfiguration else {
        return
      }

      try? appEnvironment.server.startRecording(with: middlewareConfiguration)
    }

    appEnvironment.isServerRunning.toggle()
    appEnvironment.isServerRecording.toggle()
  }
}

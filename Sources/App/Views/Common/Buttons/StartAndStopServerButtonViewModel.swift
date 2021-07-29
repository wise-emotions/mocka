//
//  Mocka
//

import Foundation

/// The ViewModel of the `ServerToolbar`.
final class StartAndStopServerButtonViewModel: ObservableObject {

  // MARK: - Functions

  /// Start and stop the current running server instance.
  /// - Parameter appEnvironment: The `AppEnvironment` instance.
  func startAndStopRunningServer(on appEnvironment: AppEnvironment) {
    switch appEnvironment.isServerRunning {
    case true:
      try? appEnvironment.server.stop()

    case false:
      guard let serverConfiguration = appEnvironment.serverConfiguration else {
        appEnvironment.shouldShowStartupSettings = true
        return
      }

      try? appEnvironment.server.start(with: serverConfiguration)
    }
    
    appEnvironment.isServerRunning.toggle()
  }
}

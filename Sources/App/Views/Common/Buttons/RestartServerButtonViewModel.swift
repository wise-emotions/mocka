//
//  Mocka
//

import Foundation

/// The ViewModel of the `ServerToolbar`.
final class RestartServerButtonViewModel: ObservableObject {

  // MARK: - Functions

  /// Restart the current running server instance.
  /// - Parameter appEnvironment: The `AppEnvironment` instance.
  func restartRunningServer(on appEnvironment: AppEnvironment) {
    guard let serverConfiguration = appEnvironment.serverConfiguration else {
      appEnvironment.shouldShowStartupSettings = true
      return
    }

    try? appEnvironment.server.restart(with: serverConfiguration)
  }
}

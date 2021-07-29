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
      appEnvironment.failedRequestsNotificationSubscription = nil

    case false:
      guard let serverConfiguration = appEnvironment.serverConfiguration else {
        appEnvironment.shouldShowStartupSettings = true
        return
      }

      try? appEnvironment.server.start(with: serverConfiguration)
      
      // Subscribe to failed request notifications.
      appEnvironment.failedRequestsNotificationSubscription = appEnvironment.server.networkExchangesPublisher
        .receive(on: RunLoop.main)
        .filter {
          let statusCode = $0.response.status.code
          return statusCode >= 300 && statusCode <= 600
        }
        .sink {
          Logic.Settings.Notifications.add(notification: .failedResponse($0.response))
        }
    }

    appEnvironment.isServerRunning.toggle()
  }
}

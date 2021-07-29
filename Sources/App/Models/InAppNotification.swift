//
//  Mocka
//

import MockaServer
import UserNotifications

/// An in-app notification to be showed to the user.
enum InAppNotification {
  /// The in-app notification for when a request fails.
  case failedResponse(DetailedResponse)

  /// The `UNNotificationContent` for the in-app notification.
  var content: UNNotificationContent {
    let content = UNMutableNotificationContent()

    switch self {
    case let .failedResponse(failedResponse):
      content.body = "Received response with \(failedResponse.status.code) status code."
      content.title = "Request failed!"
      content.subtitle = "Endpoint: \(failedResponse.uri.path)"
      content.sound = .default
    }

    return content
  }
}

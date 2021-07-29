//
//  Mocka
//

import UserNotifications

/// An in-app notification to be showed to the user.
enum InAppNotification {
  /// The in-app notification for when a request fails.
  case failedResponse(statusCode: UInt, path: String)

  /// The `UNNotificationContent` for the in-app notification.
  var content: UNNotificationContent {
    let content = UNMutableNotificationContent()

    switch self {
    case let .failedResponse(statusCode, path):
      content.body = "Received response with \(statusCode) status code."
      content.title = "Request failed!"
      content.subtitle = "Endpoint: \(path)"
      content.sound = .default
    }

    return content
  }
}

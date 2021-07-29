//
//  Mocka
//

import UserNotifications

extension Logic.Settings {
  /// The logic related to notifications settings of the app.
  enum Notifications {}
}

extension Logic.Settings.Notifications {  
  /// Whether or not the in-app notifications are enabled.
  static var areInAppNotificationEnabled: Bool {
    get {
      UserDefaults.standard.bool(forKey: UserDefaultKey.areInAppNotificationEnabled)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.areInAppNotificationEnabled)
    }
  }
  
  /// The `UNUserNotificationCenter` used for handling notifications.
  private static var notificationCenter: UNUserNotificationCenter {
    .current()
  }
  
  /// Builds an `UNNotificationRequest` with the given `notification`'s content and adds it to the notification center.
  ///
  /// - Parameters:
  ///   - notification: The in app
  ///   - identifier: The identifier of the request that will be built.
  ///   - completion: The block to execute with the results. If the notification is successfully scheduled the returned error is `nil`.
  ///
  /// - Note: This method does nothing when `areInAppNotificationEnabled` is `false`.
  static func add(notification: InAppNotification, with identifier: String = UUID().uuidString, completion: CustomInteraction<Error?>? = nil) {
    addNotificationRequest(with: notification.content, identifier: identifier, completion: completion)
  }

  /// Builds an `UNNotificationRequest` with the given `content` and adds it to the notification center.
  ///
  /// - Parameters:
  ///   - content: The content of the request.
  ///   - identifier: The identifier of the request that will be built.
  ///   - completion: The block to execute with the results. If the notification is successfully scheduled the returned error is `nil`.
  ///
  /// - Note: This method does nothing when `areInAppNotificationEnabled` is `false`.
  static func addNotificationRequest(
    with content: UNNotificationContent,
    identifier: String = UUID().uuidString,
    completion: CustomInteraction<Error?>? = nil
  ) {
    guard areInAppNotificationEnabled else {
      return
    }

    requestNotificationsAuthorizationIfNecessary { isPermissionGiven, error in
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
      notificationCenter.add(request, withCompletionHandler: completion)
    }
  }

  /// Requests notifications permissions if the user never answered to it.
  /// - Parameter completion: The closure excecuted when the user answers the request.
  static func requestNotificationsAuthorizationIfNecessary(_ completion: @escaping AuthorizationRequestCompletion) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .notDetermined:
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completion)
        
      case .authorized, .provisional:
        completion(true, nil)
        
      case .denied:
        completion(false, NSError(domain: "App Permissions", code: 0, userInfo: [NSLocalizedDescriptionKey: "User denied notifications permissions"]))

      @unknown default:
        completion(false, NSError(domain: "App Permissions", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown authorizationStatus value"]))
        return
      }
    }
  }
}

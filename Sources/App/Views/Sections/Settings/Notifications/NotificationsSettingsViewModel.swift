//
//  Mocka
//

import SwiftUI

/// The `ViewModel` for the `NotificationsSettingsView`.
struct NotificationsSettingsViewModel {
  /// Whether or not the in-app notifications are enabled.
  var areInAppNotificationEnabled: Bool = Logic.Settings.Notifications.areInAppNotificationEnabled {
    didSet {
      Logic.Settings.Notifications.areInAppNotificationEnabled = areInAppNotificationEnabled
    }
  }
}

//
//  Mocka
//

import SwiftUI

/// The `ViewModel` for the `NotificationsSettingsView`.
struct NotificationsSettingsViewModel {
  /// The app environment object.
  var appEnvironment: AppEnvironment

  /// Whether or not notifications are enabled.
  var areNotificationEnabled: Bool {
    get {
      appEnvironment.areInAppNotificationEnabled
    }
    set {
      appEnvironment.areInAppNotificationEnabled = newValue
    }
  }
}

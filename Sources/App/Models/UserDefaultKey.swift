//
//  Mocka
//

import Foundation

/// The `Key`s used to save and fetch values from `UserDefaults`.
enum UserDefaultKey {
  /// The key for retrieving the activation status of the in-app notifications.
  static let areInAppNotificationEnabled = "areInAppNotificationEnabled"

  /// The workspace path that should be used when fetching and saving the requests and responses created by the user.
  static let workspaceURL = "workspaceURL"
}

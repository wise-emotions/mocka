//
//  Mocka
//

import UserNotifications
import XCTest

@testable import MockaApp
@testable import MockaServer

class NotificationsTests: XCTestCase {
  func testAddInAppNotification() {
    let notification: InAppNotification = .failedResponse(statusCode: 0, path: "test")
    let identifier = #function

    Logic.Settings.Notifications.add(notification: notification, with: identifier) { error in
      XCTAssertNil(error)
      UNUserNotificationCenter.current()
        .getDeliveredNotifications { notificationRequests in
          XCTAssertTrue(notificationRequests.contains { $0.request.identifier == identifier })
        }
    }
  }

}

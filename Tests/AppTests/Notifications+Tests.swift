//
//  Mocka
//

import UserNotifications
import XCTest

@testable import MockaApp
@testable import MockaServer

class NotificationsTests: XCTestCase {
  func testAddInAppNotification() {
    let identifier = #function
    let notification: InAppNotification = .failedResponse(statusCode: 0, path: "test")
    
    Logic.Settings.Notifications.add(notification: notification, with: identifier) { error in
      XCTAssertNil(error)
    }
    
    UNUserNotificationCenter.current().getDeliveredNotifications { notificationRequests in
      XCTAssertTrue(notificationRequests.contains { $0.request.identifier == identifier })
    }
  }
  
  func testAddNotificationRequest() {
    let identifier = #function
    let content = UNNotificationContent()
    
    Logic.Settings.Notifications.addNotificationRequest(with: content, identifier: identifier) { error in
      XCTAssertNil(error)
    }
   
    UNUserNotificationCenter.current().getDeliveredNotifications { notificationRequests in
      XCTAssertTrue(notificationRequests.contains { $0.request.identifier == identifier })
    }
  }
}

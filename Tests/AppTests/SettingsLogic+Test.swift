//
//  Mocka
//

import XCTest

@testable import MockaApp

class SettingsLogicTests: XCTestCase {

  // MARK: Variables

  // The `URL` of a temporary folder we will use for this test.
  static var temporaryWorkspaceURL: URL!

  // The full path where the configuration file should be present.
  private var configurationFilePath: String {
    Self.temporaryWorkspaceURL.appendingPathComponent(Logic.Settings.serverConfigurationFileName).path
  }

  // MARK: Set Up and Tear Down

  override class func setUp() {
    temporaryWorkspaceURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("Mocka"))
    try? FileManager.default.createDirectory(atPath: Self.temporaryWorkspaceURL.path, withIntermediateDirectories: true, attributes: nil)
  }

  override class func tearDown() {
    try? FileManager.default.removeItem(at: temporaryWorkspaceURL)
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
  }

  // MARK: Tests
  
  // Test that the creation of the server configuration file occurs at the root path.
  func testSettingsFileCreationAtWorkspaceRoot() {
    XCTAssertFalse(FileManager.default.fileExists(atPath: Logic.Settings.serverConfigurationFileName))
    UserDefaults.standard.set(Self.temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
    try? Logic.Settings.createConfiguration()
    XCTAssertTrue(FileManager.default.fileExists(atPath: configurationFilePath))
  }

  // Test that the creation of the server configuration file throws `MockaError.workspacePathDoesNotExist` if workspace URL is not set.
  func testSettingsFileCreationFailsWithoutWorkspaceRoot() {
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
    do {
      try Logic.Settings.createConfiguration()
      XCTFail("Was expecting the test to fail, but succeeded instead")
    } catch {
      guard case .workspacePathDoesNotExist = error as? MockaError else {
        XCTFail("Expected a `MockaError.workspacePathDoesNotExist` but got \(error) instead")
        return
      }
    }
  }
}

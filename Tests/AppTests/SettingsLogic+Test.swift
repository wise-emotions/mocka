//
//  Mocka
//

import XCTest

@testable import MockaApp

class SettingsLogicTests: XCTestCase {

  // MARK: Variables

  // The `URL` of a temporary folder we will use for this test.
  var temporaryWorkspaceURL: URL!

  // The full path where the configuration file should be present.
  private var configurationFilePath: String {
    temporaryWorkspaceURL.appendingPathComponent(Logic.Settings.serverConfigurationFileName).path
  }

  // MARK: Set Up and Tear Down

  override func setUp() {
    temporaryWorkspaceURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("Mocka"))
    try? FileManager.default.createDirectory(atPath: temporaryWorkspaceURL.path, withIntermediateDirectories: true, attributes: nil)
  }

  override func tearDown() {
    try? FileManager.default.removeItem(at: temporaryWorkspaceURL)
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
  }

  // MARK: Tests

  // Test `isWorkspaceURLValid` returns true.
  func testIsWorkspaceURLValidReturnsTrue() {
    UserDefaults.standard.set(temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
    try? Logic.Settings.updateServerConfigurationFile(ServerConnectionConfiguration())
    XCTAssertTrue(Logic.Settings.isWorkspaceURLValid)
  }

  // Test `isWorkspaceURLValid` returns false because it cannot find the `workspaceURL` in `UserDefaults`.
  func testIsWorkspaceURLValidReturnsFalseForMissingWorkSpaceURL() {
    XCTAssertFalse(Logic.Settings.isWorkspaceURLValid)
    XCTAssertNil(UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL))
  }

  // Test `isWorkspaceURLValid` returns false because it cannot find the serverConfiguration file in `workspaceURL`.
  func testIsWorkspaceURLValidReturnsFalseForMissingServerConfiguration() {
    XCTAssertFalse(Logic.Settings.isWorkspaceURLValid)
    XCTAssertFalse(FileManager.default.fileExists(
                    atPath: temporaryWorkspaceURL.appendingPathComponent(Logic.Settings.serverConfigurationFileName, isDirectory: false).path)
    )
  }

  // Test that the creation of the server configuration file occurs at the root path.
  func testSettingsFileCreationAtWorkspaceRoot() {
    XCTAssertFalse(FileManager.default.fileExists(atPath: Logic.Settings.serverConfigurationFileName))
    UserDefaults.standard.set(temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
    try? Logic.Settings.updateServerConfigurationFile(ServerConnectionConfiguration())
    XCTAssertTrue(FileManager.default.fileExists(atPath: configurationFilePath))
  }

  // Tests that the configuration file is created and updated with the correct values.
  func testUpdateServerConfigurationFileOverridesValues() {
    UserDefaults.standard.set(temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
    try? Logic.Settings.updateServerConfigurationFile(ServerConnectionConfiguration())

    var contents = FileManager.default.contents(
      atPath: temporaryWorkspaceURL.appendingPathComponent(Logic.Settings.serverConfigurationFileName, isDirectory: false).path
    )

    XCTAssertNotNil(contents)

    let configuration = try! JSONDecoder().decode(ServerConnectionConfiguration.self, from: contents!)
    XCTAssertEqual(configuration.hostname, "127.0.0.1")
    XCTAssertEqual(configuration.port, 8080)

    try? Logic.Settings.updateServerConfigurationFile(ServerConnectionConfiguration(hostname: "localhost", port: 3000))

    contents = FileManager.default.contents(
      atPath: temporaryWorkspaceURL.appendingPathComponent(Logic.Settings.serverConfigurationFileName, isDirectory: false).path
    )
    
    let newConfiguration = try! JSONDecoder().decode(ServerConnectionConfiguration.self, from: contents!)
    XCTAssertEqual(newConfiguration.hostname, "localhost")
    XCTAssertEqual(newConfiguration.port, 3000)
  }

  // Test that the creation of the server configuration file throws `MockaError.workspacePathDoesNotExist` if workspace URL is not set.
  func testSettingsFileCreationFailsWithoutWorkspaceRoot() {
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
    do {
      try Logic.Settings.updateServerConfigurationFile(ServerConnectionConfiguration())
      XCTFail("Was expecting the test to fail, but succeeded instead")
    } catch {
      guard case .workspacePathDoesNotExist = error as? MockaError else {
        XCTFail("Expected a `MockaError.workspacePathDoesNotExist` but got \(error) instead")
        return
      }
    }
  }
}

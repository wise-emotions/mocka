//
//  Mocka
//

import UniformTypeIdentifiers
import XCTest

@testable import MockaApp

class WorkspacePathLogicTests: XCTestCase {

  // MARK: Variables

  // The `URL` of a temporary folder we will use for this test.
  var temporaryWorkspaceURL: URL!

  // MARK: Set Up and Tear Down

  override func setUp() {
    // Sets up the `temporaryWorkspaceURL`.
    temporaryWorkspaceURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("Mocka"))
  }

  override func tearDown() {
    // Eventually cleans up any file or folder in the `temporaryWorkspaceURL`.
    try? FileManager.default.removeItem(at: temporaryWorkspaceURL)
  }

  // MARK: Tests

  // Test that the unwrapping error is thrown when the URL is not valid.
  func testWorkspaceURLUnwrapError() throws {
    XCTAssertThrowsError(try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: nil)) { error in
      XCTAssertEqual(error as? MockaError, MockaError.failedToUnwrapURL)
    }
  }

  // Test that the logic creates a new folder correctly.
  func testWorkspaceFolderCreation() throws {
    try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: temporaryWorkspaceURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: temporaryWorkspaceURL.path))
    XCTAssertEqual(try? temporaryWorkspaceURL.resourceValues(forKeys: [.contentTypeKey]).contentType, UTType.folder)
  }

  // Test that the logic uses an already existing folder correctly.
  func testWorkspaceFolderExisting() throws {
    try FileManager.default.createDirectory(at: temporaryWorkspaceURL, withIntermediateDirectories: true, attributes: nil)

    try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: temporaryWorkspaceURL)

    XCTAssertTrue(FileManager.default.fileExists(atPath: temporaryWorkspaceURL.path))
    XCTAssertEqual(try? temporaryWorkspaceURL.resourceValues(forKeys: [.contentTypeKey]).contentType, UTType.folder)
  }

  // Test that the right error is thrown when trying to use a file as the workspace folder.
  func testWorkspacePathContainsFile() throws {
    FileManager.default.createFile(atPath: temporaryWorkspaceURL.path, contents: nil, attributes: nil)

    XCTAssertThrowsError(try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: temporaryWorkspaceURL)) { error in
      XCTAssertEqual(error as? MockaError, MockaError.workspacePathNotFolder)
    }
  }

}

//
//  Mocka
//

import XCTest

@testable import MockaApp

class SourceTreeLogicTests: XCTestCase {

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

    // Create a "/App/GET - get all users" under workspace root folder with a valid request.
    let getAllUsersURL = temporaryWorkspaceURL.appendingPathComponent("App/GET - get all users")
    addDirectory(at: getAllUsersURL.path)
    addRequestWithJSONResponse(to: getAllUsersURL)

    // Create a "/App/POST - get all users" under workspace root folder with a valid request.
    let createUser = temporaryWorkspaceURL.appendingPathComponent("App/V2/POST - create user")
    addDirectory(at: createUser.path)
    addRequestWithNoContent(to: createUser)

    // Create a "/App/GET - get all admins" under workspace root folder with a not valid request.
    let getAllAdminsURL = temporaryWorkspaceURL.appendingPathComponent("App/GET - get all admins")
    addDirectory(at: getAllAdminsURL.path)
    addRequestWithJSONResponse(to: getAllAdminsURL, addResponse: false)

    // Create a "/App/GET - get all superusers" under workspace root folder with a no request.
    let getAllSuperusersURL = temporaryWorkspaceURL.appendingPathComponent("App/GET - get all superusers")
    addDirectory(at: getAllSuperusersURL.path)

    // Create a "/App/Void" under workspace root folder with a valid request.
    let voidURL = temporaryWorkspaceURL.appendingPathComponent("App/Void")
    addDirectory(at: voidURL.path)
    addRequestWithJSONResponse(to: voidURL)

    // Create a "/App/Generic" under workspace root folder with no request.
    let genericURL = temporaryWorkspaceURL.appendingPathComponent("App/Generic")
    addDirectory(at: genericURL.path)
  }

  override func setUp() {
    UserDefaults.standard.set(Self.temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
  }

  override class func tearDown() {
    try? FileManager.default.removeItem(at: temporaryWorkspaceURL)
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
  }

  // MARK: Tests

  // Tests the performance creating a realistic high number of requests nested vertically and horizontally.
  func testPerformanceForHighLevelOfRequests() {
    (0...200)
      .forEach { number in
        // Create a "/App/GET - get all users" under workspace root folder with a valid request.
        let getAllUsersURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/\(number)/GET - get all users")
        Self.addDirectory(at: getAllUsersURL.path)
        Self.addRequestWithJSONResponse(to: getAllUsersURL)
      }

    (0...200)
      .forEach { number in
        let numberPath = (0...number).map { String($0) }.joined(separator: "/")
        // Create a "/App/GET - get all users" under workspace root folder with a valid request.
        let getAllUsersURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/Test/\(numberPath)/GET - get all users")
        Self.addDirectory(at: getAllUsersURL.path)
        Self.addRequestWithJSONResponse(to: getAllUsersURL)
      }

    measure {
      _ = Logic.SourceTree.sourceTree()
    }
  }

  // Test only valid folders are considered.
  func testOnlyContentOfValidStructuresIsConsidered() {
    let contents = Logic.SourceTree.sourceTree()

    // The folder has only 4 valid folders out of the existing 6.
    // GET - get all users, V2, Void and Generic.
    XCTAssertEqual(contents.children?[0].children?.count, 4)
  }

  // Test fetching requests without setting workspace url fails.
  func testFetchingMockaRequestsFromSourceTreeWithoutSettingWorkspaceFails() {
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)

    do {
      let _ = try Logic.SourceTree.requests()
      XCTFail("Was expecting the test to fail, but succeeded instead")
    } catch {
      guard case .workspacePathDoesNotExist = error as? MockaError else {
        XCTFail("Was expecting a \(MockaError.workspacePathDoesNotExist) but got \(error) instead.")
        return
      }
    }
  }

  // Test MockaRequests are fetched correctly from the source tree.
  func testFetchingMockaRequestsFromSourceTree() {
    let requests = try! Logic.SourceTree.requests()
      .sorted {
        $0.requestedResponse.status.code < $1.requestedResponse.status.code
      }

    let expectedRequestOne = MockaApp.Request(
      path: ["api", "users"],
      method: .get,
      expectedResponse: Response(
        statusCode: 200,
        contentType: .applicationJSON,
        headers: [HTTPHeader(key: "Content-Type", value: "application/json")]
      )
    )

    let expectedRequestTwo = MockaApp.Request(
      path: ["api", "users"],
      method: .post,
      expectedResponse: Response(
        statusCode: 204,
        contentType: .none,
        headers: []
      )
    )

    XCTAssertEqual(requests[0].path, expectedRequestOne.path)
    XCTAssertEqual(requests[0].method, expectedRequestOne.method)
    XCTAssertEqual(Int(requests[0].requestedResponse.status.code), expectedRequestOne.expectedResponse.statusCode)
    XCTAssertEqual(requests[0].requestedResponse.headers.contentType, expectedRequestOne.expectedResponse.contentType)

    XCTAssertEqual(requests[1].path, expectedRequestTwo.path)
    XCTAssertEqual(requests[1].method, expectedRequestTwo.method)
    XCTAssertEqual(Int(requests[1].requestedResponse.status.code), expectedRequestTwo.expectedResponse.statusCode)
    XCTAssertEqual(requests[1].requestedResponse.headers.contentType, nil)
  }

  // Test `namespaceFolders` returns an array containing all the folders that serve as a namespace.
  func testNamespaceFoldersReturnArrayWithCorrectFolders() {
    let namespaceFolder = Logic.SourceTree.namespaceFolders(in: Logic.SourceTree.rootFileSystemNode)

    XCTAssertEqual(namespaceFolder.count, 5)
    XCTAssertEqual(namespaceFolder.map { $0.name }.sorted(by: <), ["App", "Generic", "V2", "Void", "Workspace gRoot"])
  }
}

// MARK: - Helpers

extension SourceTreeLogicTests {
  /// Adds a directory while creating intermediate directories.
  /// - Parameter path: The path where to create that directory.
  static func addDirectory(at path: String) {
    try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
  }

  /// Adds a `request.json` of type `.noContent`.
  /// - Parameter url: The `URL` where to create the request file.
  static func addRequestWithNoContent(to url: URL) {
    // Add the request.
    let request = MockaApp.Request(
      path: ["api", "users"],
      method: .post,
      expectedResponse: Response(
        statusCode: 204,
        contentType: .none,
        headers: []
      )
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try! encoder.encode(request)
    let requestFilePath = url.appendingPathComponent("request.json", isDirectory: false)
    try! String(data: data, encoding: .utf8)!.write(toFile: requestFilePath.path, atomically: true, encoding: String.Encoding.utf8)
  }

  /// Adds a `request.json` of type `.ok` with a `response.json`.
  /// - Parameters:
  ///   - url: The `URL` where to create the request file.
  ///   - addResponse: If `false`, `response.json` won't be created. This will lead to voiding the validity of the request.
  static func addRequestWithJSONResponse(to url: URL, addResponse: Bool = true) {
    // Add the request.
    let request = MockaApp.Request(
      path: ["api", "users"],
      method: .get,
      expectedResponse: Response(
        statusCode: 200,
        contentType: .applicationJSON,
        headers: [HTTPHeader(key: "Content-Type", value: "application/json")]
      )
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try! encoder.encode(request)
    let requestFilePath = url.appendingPathComponent("request.json", isDirectory: false)
    try! String(data: data, encoding: .utf8)!.write(toFile: requestFilePath.path, atomically: true, encoding: String.Encoding.utf8)

    guard addResponse else {
      return
    }

    // Add the response.
    let response = """
      [
        {
          "name": "userOne"
        },
        {
          "name": "userTwo"
        }
      ]
      """

    let responseFilePath = url.appendingPathComponent("response.json", isDirectory: false)
    try! response.write(toFile: responseFilePath.path, atomically: true, encoding: String.Encoding.utf8)
  }
}

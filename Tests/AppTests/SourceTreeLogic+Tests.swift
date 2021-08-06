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
  }

  override class func tearDown() {
    UserDefaults.standard.set(nil, forKey: UserDefaultKey.workspaceURL)
  }
  
  override func setUp() {
    UserDefaults.standard.set(Self.temporaryWorkspaceURL, forKey: UserDefaultKey.workspaceURL)
  }

  override func tearDown() {
    try? FileManager.default.removeItem(at: Self.temporaryWorkspaceURL)
  }
  
  // MARK: Tests

  /// Tests the performance creating a realistic high number of requests nested vertically and horizontally.
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
  
  func testFoldersCorrectlyCategorized() {
    // Given
    
    // A request folder named `/GET - get all users` under workspace root.
    let getAllUsersURL = Self.temporaryWorkspaceURL.appendingPathComponent("GET - get all users")
    Self.addDirectory(at: getAllUsersURL.path)
    Self.addRequestWithJSONResponse(to: getAllUsersURL)

    // A folder named `/App/GET - get all admins` under workspace root with no valid request, therefore qualifies as a namespace folder.
    let getAllAdminsURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/GET - get all admins")
    Self.addDirectory(at: getAllAdminsURL.path)

    // A folder `/App/Void` under workspace root folder with a valid request. This will be a namespace folder due to the name.
    let voidURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/Void")
    Self.addDirectory(at: voidURL.path)
    Self.addRequestWithJSONResponse(to: voidURL)

    // A folder `/App/Generic` under workspace root folder with no request.
    let genericURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/Generic")
    Self.addDirectory(at: genericURL.path)

    // A request folder `/App/POST - create user` under workspace root.
    let createUser = Self.temporaryWorkspaceURL.appendingPathComponent("App/POST - create user")
    Self.addDirectory(at: createUser.path)
    Self.addRequestWithNoContent(to: createUser)
    
    // When
    
    let workspace = Logic.SourceTree.sourceTree()
    let appFolder = workspace.namespaces.first(where: { $0.name == "App" })!
    
    // Then

    XCTAssertEqual(workspace.requests.count, 1) // `/GET - get all users`
    XCTAssertEqual(workspace.namespaces.count, 1) // `/App`
    
    XCTAssertEqual(appFolder.namespaces.count, 3)
    XCTAssertEqual(appFolder.namespaces.map { $0.name }.sorted(by: <).joined(separator: ", "), "GET - get all admins, Generic, Void")
    XCTAssertEqual(appFolder.requests.count, 1)
  }
  
  func testRequestsCorrectlyFetched() {
    // Given
    
    // A request folder named `/GET - get all users` under workspace root.
    let getAllUsersURL = Self.temporaryWorkspaceURL.appendingPathComponent("GET - get all users")
    Self.addDirectory(at: getAllUsersURL.path)
    Self.addRequestWithJSONResponse(to: getAllUsersURL)

    // A request folder `/App/POST - create user` under workspace root.
    let createUser = Self.temporaryWorkspaceURL.appendingPathComponent("App/POST - create user")
    Self.addDirectory(at: createUser.path)
    Self.addRequestWithNoContent(to: createUser)
    
    // A request folder `/App/V2/POST - create user` under workspace root.
    let createUserV2 = Self.temporaryWorkspaceURL.appendingPathComponent("App/V2/POST - create user v2")
    Self.addDirectory(at: createUserV2.path)
    Self.addRequestWithJSONResponse(to: createUserV2)
    
    // When
    
    let requests = try? Logic.SourceTree.requests()
    
    // Then
    
    XCTAssertEqual(requests?.count, 3)
  }
  
  func testNamespaceFoldersProperlyIdentified() {
    // Given
    
    // A request folder named `/GET - get all users` under workspace root.
    let getAllUsersURL = Self.temporaryWorkspaceURL.appendingPathComponent("GET - get all users")
    Self.addDirectory(at: getAllUsersURL.path)
    Self.addRequestWithJSONResponse(to: getAllUsersURL)

    // A folder named `/App/GET - get all admins` under workspace root with no valid request, therefore qualifies as a namespace folder.
    let getAllAdminsURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/GET - get all admins")
    Self.addDirectory(at: getAllAdminsURL.path)

    // A folder `/App/Void` under workspace root folder with a valid request. This will be a namespace folder due to the name.
    let voidURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/Void")
    Self.addDirectory(at: voidURL.path)
    Self.addRequestWithJSONResponse(to: voidURL)

    // A folder `/App/Generic` under workspace root folder with no request.
    let genericURL = Self.temporaryWorkspaceURL.appendingPathComponent("App/Generic")
    Self.addDirectory(at: genericURL.path)

    // A request folder `/App/POST - create user` under workspace root.
    let createUser = Self.temporaryWorkspaceURL.appendingPathComponent("App/POST - create user")
    Self.addDirectory(at: createUser.path)
    Self.addRequestWithNoContent(to: createUser)
    
    // When
    
    let namespaceFolders = try? Logic.SourceTree.namespaceFolders()
    
    // Then
    
    XCTAssertEqual(namespaceFolders?.count, 4)
    XCTAssertEqual(namespaceFolders?.map { $0.name }.sorted(by: <).joined(separator: ", "), "App, GET - get all admins, Generic, Void")
    
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
      path: ["api", "users", "\(url.lastPathComponent)"],
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
      path: ["api", "users", "\(url.lastPathComponent)"],
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

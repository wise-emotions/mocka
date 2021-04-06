//
//  Mocka
//

import XCTVapor

@testable import MockaServer

class ServerLaunchTests: XCTestCase {
  /// An instance of `AppServer`.
  let server = AppServer()

  override func tearDown() {
    // Stop the server if needed after each test.
    try? server.stop()
  }

  // Test server starting is successful and returns correct port and host.
  func testServerStartSuccessful() {

    XCTAssertNil(server.application)

    try? server.start(with: ServerHelpersTests.ServerConfiguration())

    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.port, 8080)
    XCTAssertEqual(server.host, "127.0.0.1")
  }

  // Test if server is already running, if we run a new instance `ServerError.instanceAlreadyRunning` is thrown.
  func testServerStartWhenInstanceExistsThrowing() {
    XCTAssertNil(server.application)

    try? server.start(with: ServerHelpersTests.ServerConfiguration())
    XCTAssertNotNil(server.application)

    do {
      try server.start(with: ServerHelpersTests.ServerConfiguration())
    } catch {
      guard case .instanceAlreadyRunning = error as? ServerError else {
        XCTFail("Was expecting `ServerError.instanceAlreadyRunning` but got \(error) instead")
        return
      }
    }
  }

  // Test that `server.stop()` stops the server, and sets `server.application` to `nil`.
  func testServerStopSuccessful() {
    XCTAssertNil(server.application)

    try? server.start(with: ServerHelpersTests.ServerConfiguration())
    XCTAssertNotNil(server.application)

    try? server.stop()
    XCTAssertNil(server.application)
  }

  func testRoutesCorrectlyRegistered() {
    XCTAssertEqual(server.routes.count, 0)

    try? server.start(with: ServerHelpersTests.ServerConfiguration())
    XCTAssertEqual(server.routes.count, 1)
    XCTAssertEqual(server.routes[0].method, .GET)
    XCTAssertEqual(server.routes[0].path[0].description, "api")
    XCTAssertEqual(server.routes[0].path[1].description, "test")
  }
}

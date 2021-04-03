//
// Mocka
//

import XCTest
import XCTVapor

@testable import Server

class ServerLaunchTests: XCTestCase {
  // Test server starting is successful and returns correct port and host.
  func testServerStartSuccessful() {
    let server = Server()
    XCTAssertNil(server.application)

    try? server.start(with: ServerTests.ServerConfiguration())
    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.port, 8080)
    XCTAssertEqual(server.host, "127.0.0.1")
  }

  // Test if server is already running, if we run a new instance `ServerError.instanceAlreadyRunning` is thrown.
  func testServerStartWhenInstanceExistsThrowing() {
    let server = Server()
    XCTAssertNil(server.application)

    try? server.start(with: ServerTests.ServerConfiguration())
    XCTAssertNotNil(server.application)

    do {
      try server.start(with: ServerTests.ServerConfiguration())
    } catch {
      guard case .instanceAlreadyRunning = error as? ServerError else {
        XCTFail("Was expecting `ServerError.instanceAlreadyRunning` but got \(error) instead")
        return
      }
    }
  }

  // Test that `server.stop()` stops the server, and sets `server.application` to nul.
  func testServerStopSuccessful() {
    let server = Server()

    XCTAssertNil(server.application)

    try? server.start(with: ServerTests.ServerConfiguration())

    XCTAssertNotNil(server.application)

    try? server.stop()

    XCTAssertNil(server.application)
  }

//  func testRoutesCorrectlyRegistered() {
//    let server = Server()
//    try? server.start(with: ServerTests.ServerConfiguration())
//
//    XCTAssertEqual(server.application?.routes.all.count, 1)
//    XCTAssertEqual(server.application?.routes.all[0].method, .GET)
//    XCTAssertEqual(server.application?.routes.all[0].path[0].description, "api")
//    XCTAssertEqual(server.application?.routes.all[0].path[1].description, "test")
//  }
}

import XCTest

@testable import Server

class ServerTests: XCTestCase {
  struct ServerConfiguration: ServerConfigurationProvider {
    let requests: [Request] = [Request(method: .get, path: ["api", "test"], responseLocation: nil)]
  }

  func testServerStartSuccessful() {
    let server = AppServer()

    XCTAssertNil(server.application)

    try? server.start(with: ServerConfiguration())

    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.application?.http.server.configuration.port, 8080)
    XCTAssertEqual(server.application?.http.server.configuration.hostname, "127.0.0.1")
  }

  func testServerWithCustomConfigurationStartSuccessful() {
    struct CustomConfiguration: ServerConfigurationProvider {
      let hostname: String = "localhost"
      let port: Int = 3000
      let requests: [Request] = [Request(method: .get, path: ["api", "test"], responseLocation: nil)]
    }

    let server = AppServer()

    XCTAssertNil(server.application)

    try? server.start(with: CustomConfiguration())

    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.application?.http.server.configuration.port, 3000)
    XCTAssertEqual(server.application?.http.server.configuration.hostname, "localhost")
  }

  func testServerStopSuccessful() {
    let server = AppServer()

    XCTAssertNil(server.application)

    try? server.start(with: ServerConfiguration())

    XCTAssertNotNil(server.application)

    server.stop()

    XCTAssertNil(server.application)
  }

  func testStartingServerTwiceOnSamePortThrows() {
    let server = AppServer()
    try? server.start(with: ServerConfiguration())

    XCTAssertThrowsError(try server.start(with: ServerConfiguration()))

    do {
      try server.start(with: ServerConfiguration())
    } catch {
      guard case .instanceAlreadyRunning = error as? ServerError else {
        XCTFail("Was expecting a ServerError.instanceAlreadyRunning")
        return
      }

      XCTAssertTrue(true)
    }
  }

  func testRoutesCorrectlyRegistered() {
    let server = AppServer()
    try? server.start(with: ServerConfiguration())

    XCTAssertEqual(server.application?.routes.all.count, 1)
    XCTAssertEqual(server.application?.routes.all[0].method, .GET)
    XCTAssertEqual(server.application?.routes.all[0].path[0].description, "api")
    XCTAssertEqual(server.application?.routes.all[0].path[1].description, "test")
  }
}

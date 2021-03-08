import Vapor
import XCTest

@testable import Server

class ServerTests: XCTestCase {
  func testServerStartSuccessful() {
    let server = Server()

    XCTAssertNil(server.application)

    try? server.start()

    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.application?.http.server.configuration.port, 8080)
    XCTAssertEqual(server.application?.http.server.configuration.hostname, "127.0.0.1")
  }

  func testServerWithCustomConfigurationStartSuccessful() {
    struct CustomConfiguration: ServerConfigurationProvider {
      let hostname: String = "localhost"
      let port: Int = 3000
    }

    let server = Server()

    XCTAssertNil(server.application)

    try? server.start(with: CustomConfiguration())

    XCTAssertNotNil(server.application)
    XCTAssertEqual(server.application?.http.server.configuration.port, 3000)
    XCTAssertEqual(server.application?.http.server.configuration.hostname, "localhost")
  }

  func testServerStopSuccessful() {
    let server = Server()

    XCTAssertNil(server.application)

    try? server.start()

    XCTAssertNotNil(server.application)

    server.stop()

    XCTAssertNil(server.application)
  }

  func testStartingServerTwiceOnSamePortThrows() {
    let server = Server()
    try? server.start()

    XCTAssertThrowsError(try server.start())

    do {
      try server.start()
    } catch {
      guard case .instanceAlreadyRunning = error as? ServerError else {
        XCTFail()
        return
      }

      XCTAssertTrue(true)
    }
  }
}

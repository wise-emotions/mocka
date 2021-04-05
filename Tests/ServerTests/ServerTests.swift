//
// Mocka
//

import XCTest

@testable import MockaServer

class ServerTests {}

// MARK: - Data Structures

extension ServerTests {
  struct ServerConfiguration: ServerConfigurationProvider {
    var hostname: String = "127.0.0.1"

    var port: Int = 8080

    var requests: Set<Request> = [
      Request(
        method: .get,
        path: ["api", "test"],
        requestedResponse: RequestedResponse(
          status: .ok,
          headers: ["Content-Type": "application/json"],
          body: ResponseBody(
            contentType: .applicationJSON,
            fileLocation: ServerTests.getFilePath(for: "DummyJSON", extension: "json")
          )
        )
      )
    ]
  }
}


// MARK: - Helpers

extension Bundle {
  internal static var tests: Bundle {
    Bundle(for: ServerTests.self)
  }
}

extension ServerTests {
  /// Returns the `URL` of the passed file in the `Bundle.tests`.
  static func getFilePath(for name: String, `extension`: String) -> URL {
    URL(string: Bundle.tests.path(forResource: name, ofType: `extension`)!)!
  }
}

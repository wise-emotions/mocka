//
// Mocka
//

import XCTest
import XCTVapor

@testable import Server

class ServerTests {}

// MARK: - Data Structures

extension ServerTests {
  struct ServerConfiguration: ServerConfigurationProvider {
    var requests: Set<Models.Request> = [
      Models.Request(
        method: .get,
        path: ["api", "test"],
        requestedResponse: Models.RequestedResponse(
          status: .ok,
          headers: ["Content-Type": "application/json"],
          body: Models.ResponseBody(
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

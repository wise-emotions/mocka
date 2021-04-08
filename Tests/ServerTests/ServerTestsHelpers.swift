//
// Mocka
//

import XCTest

@testable import MockaServer

class ServerTestsHelpers {}

// MARK: - Data Structures

extension ServerTestsHelpers {
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
            fileLocation: ServerTestsHelpers.getFilePath(for: "DummyJSON", extension: "json")
          )
        )
      )
    ]
  }
}

// MARK: - Helpers

extension Bundle {
  /// The `Bundle` for the server tests.
  internal static var tests: Bundle {
    Bundle(for: ServerTestsHelpers.self)
  }
}

extension ServerTestsHelpers {
  /// Returns the `URL` of the passed file in the `Bundle.tests`.
  /// - Parameters:
  ///   - name: The name of the file.
  ///   - extension: The extension of the file.
  /// - Returns: The path of the file inside the tests bundle.
  static func getFilePath(for name: String, `extension`: String) -> URL {
    URL(string: Bundle.tests.path(forResource: name, ofType: `extension`)!)!
  }
}

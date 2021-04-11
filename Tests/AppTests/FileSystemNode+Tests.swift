//
//  Mocka
//

import XCTest

@testable import MockaApp

class FileSystemNodeTests: XCTestCase {
  // Test that a node's `flatten` returns an array containing the node and the the children recursively.
  func testFileSystemNodeArrayFlattening() {
    let request = FileSystemNode(
      name: "request.json",
      url: URL(fileURLWithPath: "API/Unica/V1/request.json"),
      kind: .requestFile(
        Request(
          path: ["api", "test"],
          method: .post,
          expectedResponse: Response(statusCode: 204, contentType: .none, headers: [])
        )
      )
    )

    let versionFolder = FileSystemNode(
      name: "V1",
      url: URL(fileURLWithPath: "Root/App/V1"),
      kind: .folder(children: [request], isRequestFolder: false)
    )

    let appFolder = FileSystemNode(
      name: "App",
      url: URL(fileURLWithPath: "Root/App"),
      kind: .folder(children: [versionFolder], isRequestFolder: false)
    )

    let rootFolder = FileSystemNode(
      name: "Root",
      url: URL(fileURLWithPath: "Root"),
      kind: .folder(children: [versionFolder, appFolder], isRequestFolder: false)
    )

    let output = rootFolder.flatten()

    XCTAssertEqual(output.count, 4)
  }
}

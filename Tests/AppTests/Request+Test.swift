//
//  Mocka
//

import XCTest

@testable import MockaApp
@testable import MockaServer

class RequestTests: XCTestCase {

  // MARK: Tests

  // Test request is created properly using code that has no body.
  func testNoContentRequestCodeCreation() {
    let request = MockaApp.Request(
      path: ["api", "test"],
      method: .post,
      expectedResponse: Response(
        statusCode: 204,
        contentType: .none,
        headers: []
      )
    )

    XCTAssertEqual(request.path, ["api", "test"])
    XCTAssertEqual(request.method, .post)
    XCTAssertEqual(request.expectedResponse.statusCode, 204)
    XCTAssertEqual(request.expectedResponse.contentType, .none)
    XCTAssertEqual(request.expectedResponse.headers, [])
    XCTAssertEqual(request.expectedResponse.fileName, nil)
  }

  // Test request is created properly using code that has a body.
  func testJSONContentRequestCodeCreation() {
    let request = MockaApp.Request(
      path: ["api", "test"],
      method: .get,
      expectedResponse: Response(
        statusCode: 200,
        contentType: .applicationJSON,
        headers: [HTTPHeader(key: "Content-Type", value: "application/json")]
      )
    )

    XCTAssertEqual(request.path, ["api", "test"])
    XCTAssertEqual(request.method, .get)
    XCTAssertEqual(request.expectedResponse.statusCode, 200)
    XCTAssertEqual(request.expectedResponse.contentType, .applicationJSON)
    XCTAssertEqual(request.expectedResponse.headers, [HTTPHeader(key: "Content-Type", value: "application/json")])
    XCTAssertEqual(request.expectedResponse.fileName, "response.json")
  }

  // Test that the request is properly encoded with the right param names.
  func testRequestEncoding() {
    let request = MockaApp.Request(
      path: ["api", "test"],
      method: .get,
      expectedResponse: Response(
        statusCode: 200,
        contentType: .applicationJSON,
        headers: [HTTPHeader(key: "Content-Type", value: "application/json")]
      )
    )

    let expectedOutput = """
      {
        "path" : [
          "api",
          "test"
        ],
        "method" : "GET",
        "expectedResponse" : {
          "statusCode" : 200,
          "fileName" : "response.json",
          "headers" : [
            {
              "key" : "Content-Type",
              "value" : "application\\/json"
            }
          ],
          "contentType" : "application\\/json"
        }
      }
      """

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedRequest = try! encoder.encode(request)

    XCTAssertEqual(String(data: encodedRequest, encoding: .utf8), expectedOutput)
  }

  // Test a request is properly decoded given a data.
  func testRequestDecoding() {
    let expectedOutput = MockaApp.Request(
      path: ["api", "test"],
      method: .get,
      expectedResponse: Response(
        statusCode: 200,
        contentType: .applicationJSON,
        headers: [HTTPHeader(key: "Content-Type", value: "application/json")]
      )
    )

    let encodedRequest = """
      {
        "path" : [
          "api",
          "test"
        ],
        "method" : "GET",
        "expectedResponse" : {
          "statusCode" : 200,
          "fileName" : "response.json",
          "headers" : [
            {
              "key" : "Content-Type",
              "value" : "application\\/json"
            }
          ],
          "contentType" : "application\\/json"
        }
      }
      """
      .data(using: .utf8)!

    let request = try! JSONDecoder().decode(MockaApp.Request.self, from: encodedRequest)
    XCTAssertEqual(expectedOutput, request)
  }
}

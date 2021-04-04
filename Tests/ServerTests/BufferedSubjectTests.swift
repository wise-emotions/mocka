import XCTest

@testable import MockaServer

class BufferedSubjectTests: XCTestCase {
  /// Tests the right fetch of values from a `BufferedSubject`.
  func testBufferedSubject() {
    let bufferedSubject = BufferedSubject<Int, Never>()

    let values = [0, 1, 2, 3]
    let expectedValues = [0, 1, 2, 3, 4]
    let expectation = self.expectation(description: "Buffered subject send last buffered values")
    var receivedValues: [Int] = []

    values.forEach(bufferedSubject.send)

    let subscription = bufferedSubject.sink { _ in
      expectation.fulfill()
    } receiveValue: {
      receivedValues.append($0)
    }

    bufferedSubject.send(4)
    bufferedSubject.send(completion: .finished)

    waitForExpectations(timeout: 1) { _ in
      XCTAssertEqual(receivedValues, expectedValues)
      XCTAssertNotNil(subscription)
    }
  }

  /// Tests the right fetch of values from a `BufferedSubject` with a buffer size that is less than the sended values.
  func testBufferedSubjectWithBufferSize() {
    let bufferedSubject = BufferedSubject<Int, Never>(bufferSize: 1)

    let values = [0, 1, 2, 3]
    let expectedValues = [3, 4]
    let expectation = self.expectation(description: "Buffered subject send last buffered values limited by buffer size")
    var receivedValues: [Int] = []

    values.forEach(bufferedSubject.send)

    let subscription = bufferedSubject.sink { _ in
      expectation.fulfill()
    } receiveValue: {
      receivedValues.append($0)
    }

    bufferedSubject.send(4)
    bufferedSubject.send(completion: .finished)

    waitForExpectations(timeout: 1) { _ in
      XCTAssertEqual(receivedValues, expectedValues)
      XCTAssertNotNil(subscription)
    }
  }

  // Tests the empty fetch of values from a `BufferedSubject` by calling the `clearBuffer()` function.
  func testBufferedSubjectWithClearBuffer() {
    let bufferedSubject = BufferedSubject<Int, Never>(bufferSize: 1)

    let values = [0, 1, 2, 3]
    let expectedValues = [4]
    let expectation = self.expectation(description: "Buffered subject send no buffered values")
    var receivedValues: [Int] = []

    values.forEach(bufferedSubject.send)

    bufferedSubject.clearBuffer()

    let subscription = bufferedSubject.sink { _ in
      expectation.fulfill()
    } receiveValue: {
      receivedValues.append($0)
    }

    bufferedSubject.send(4)
    bufferedSubject.send(completion: .finished)

    waitForExpectations(timeout: 1) { _ in
      XCTAssertEqual(receivedValues, expectedValues)
      XCTAssertNotNil(subscription)
    }
  }
}

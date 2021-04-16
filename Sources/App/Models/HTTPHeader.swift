//
//  Mocka
//

import Foundation

/// A header of an `HTTP` request.
///
/// We opted for a custom `HTTPHeader` rather than using Vapor's because the latter cannot be made Hashable.
struct HTTPHeader: Hashable {
  /// The key of the header.
  let key: String

  /// The value of the header.
  let value: String

  /// The `HTTPHeader` instance as a tuple of (key, value).
  var tuple: (String, String) {
    (key, value)
  }
}

// MARK: - Codable

// To simplify how the data is edited inside the `request.json` file,
// we customize how we encode and extract the data.
//
// Without the custom encoder we would have:
// ```
//  {
//    "key": "someKey",
//    "value": "someValue"
//  }
// ```
//
// With the custom encoder we will have:
// ```
// {
//   "key": "value"
// }
// ```
extension HTTPHeader: Codable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    let header = try container.decode([String: String].self)
    assert(header.keys.count == 1 && header.values.count == 1)
    guard let key = header.keys.first, let value = header.values.first else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed decoding HTTPHeader")
    }

    self.key = key
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode([key: value])
  }
}

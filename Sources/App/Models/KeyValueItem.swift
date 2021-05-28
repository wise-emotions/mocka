//
//  Mocka
//

import Foundation

/// The key-value item structure.
struct KeyValueItem: Identifiable, Hashable {
  /// The unique ID of the key-value.
  let id = UUID()

  /// The key of the KeyValue parameter.
  var key: String

  /// The value of the KeyValue parameter.
  var value: String

  /// Returns the `KeyValueItem` as an `HTTPHeader`
  var header: HTTPHeader {
    HTTPHeader(key: key, value: value)
  }
}

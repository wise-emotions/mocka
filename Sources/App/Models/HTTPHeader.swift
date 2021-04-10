//
//  Mocka
//

import Foundation

/// A header of an `HTTP` request.
///
/// We opted for a custom `HTTPHeader` rather than using Vapor's because the latter cannot be made Hashable.
struct HTTPHeader: Codable, Hashable {
  /// The key of the header.
  let key: String

  /// The value of the header.
  let value: String

  /// The `HTTPHeader` instance as a tuple of (key, value).
  var tuple: (String, String) {
    (key, value)
  }
}

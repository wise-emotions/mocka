//
//  Mocka
//

import Foundation

/// The key-value item structure.
class KeyValueItem: Identifiable, ObservableObject {
  /// The unique ID of the key-value.
  let id = UUID()

  /// The key of the KeyValue parameter.
  var key: String

  /// The value of the KeyValue parameter.
  var value: String

  /// Creates a new `KeyValueItem` instance.
  /// - Parameters:
  ///   - key: The key.
  ///   - value: The value.
  init(key: String, value: String) {
    self.key = key
    self.value = value
  }
}

// MARK: - Hashable

extension KeyValueItem: Hashable {
  static func == (lhs: KeyValueItem, rhs: KeyValueItem) -> Bool {
    lhs.id == rhs.id && lhs.key == rhs.key && lhs.value == rhs.value
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(key)
    hasher.combine(value)
  }
}

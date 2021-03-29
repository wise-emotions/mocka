import Foundation

/// The key-value item structure.
struct KeyValueItem: Identifiable, Hashable {
  /// The unique ID of the key-value.
  let id = UUID()

  /// The key of the KeyValue parameter.
  let key: String

  /// The value of the KeyValue parameter.
  let value: String
}

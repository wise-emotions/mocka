//
//  Mocka
//

import SwiftUI

/// The ViewModel of the `KeyValueTable`.
class KeyValueTableViewModel: ObservableObject {

  // MARK: - Data Structure

  /// The table mode.
  /// Use `write` mode to allow the user edit each `TextField` and to be able to add new ones.
  /// Use `read` mode to disable user interactions.
  enum Mode {
    /// The write mode that allows the user to edit each `TextField` and to be able to add new ones.
    case write

    /// The read mode that disable user interactions.
    case read
  }

  // MARK: - Stored Properties

  /// The array of all the table items.
  @Published var keyValueItems: Binding<[KeyValueItem]>

  /// The table mode. In `write` mode an add button will be added.
  @Published var mode: Mode

  // MARK: - Init

  init(keyValueItems: Binding<[KeyValueItem]>, mode: Mode) {
    self.keyValueItems = keyValueItems
    self.mode = mode

    if mode == .write {
      addNewRow()
    }
  }

  // MARK: - Function

  /// Add a new row to the `KeyValueTable`.
  func addNewRow() {
    if let lastKeyValueItem = keyValueItems.wrappedValue.last,
      lastKeyValueItem.key.isNotEmpty,
      lastKeyValueItem.value.isNotEmpty
    {
      keyValueItems.wrappedValue.append(KeyValueItem(key: "", value: ""))
    } else if keyValueItems.wrappedValue.count == 0 {
      keyValueItems.wrappedValue.append(KeyValueItem(key: "", value: ""))
    }
  }
}

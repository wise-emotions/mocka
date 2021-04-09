//
//  Mocka
//

import SwiftUI

/// The ViewModel of the `KeyValueTable`.
class KeyValueTableViewModel: ObservableObject {

  // MARK: - Data Structure

  enum Mode {
    case write
    
    case read
  }

  // MARK: - Stored Properties

  /// The array of all the table items.
  @Published var keyValueItems: [KeyValueItem]

  /// The table mode. In `write` mode an add button will be added.
  @Published var mode: Mode

  // MARK: - Init

  init(keyValueItems: [KeyValueItem], mode: Mode) {
    self.keyValueItems = keyValueItems
    self.mode = mode
    
    if mode == .write {
      self.keyValueItems.append(KeyValueItem(key: "", value: ""))
    }
  }
}

//
//  Mocka
//

import SwiftUI

class KeyValueTableViewModel: ObservableObject {
  enum Mode {
    case write
    case read
  }

  @Published var keyValueItems: [KeyValueItem]
  @Published var mode: Mode
    
  init(keyValueItems: [KeyValueItem], mode: Mode) {
    self.keyValueItems = keyValueItems
    self.mode = mode
    
    if mode == .write {
      self.keyValueItems.append(KeyValueItem(key: "", value: ""))
    }
  }
}

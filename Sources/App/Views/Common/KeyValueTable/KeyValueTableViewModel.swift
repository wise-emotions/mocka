//
//  Mocka
//

import SwiftUI

class KeyValueTableViewModel: ObservableObject {
  @Published var keyValueItems: [KeyValueItem]
  @Published var shouldDisplayEmptyElement: Bool
    
  init(keyValueItems: [KeyValueItem], shouldDisplayEmptyElement: Bool) {
    self.keyValueItems = keyValueItems
    self.shouldDisplayEmptyElement = shouldDisplayEmptyElement
    
    if shouldDisplayEmptyElement {
      self.keyValueItems.append(KeyValueItem(key: "", value: ""))
    }
  }
}

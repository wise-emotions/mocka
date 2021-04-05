//
//  Mocka
//

import Cocoa

// Gets rid of the selection border around the text field.
extension NSTextField {
  open override var focusRingType: NSFocusRingType {
    get { .none }
    set {}
  }
}

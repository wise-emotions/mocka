//
//  Mocka
//

import SwiftUI

extension NSTextView {
  /// Remove `TextEditor` background.
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear
      drawsBackground = true
    }
  }
}

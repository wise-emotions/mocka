//
//  Mocka
//

import SwiftUI

extension NSTextView {
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear
      drawsBackground = true

    }
  }

  open override func scrollWheel(with event: NSEvent) {
    // 1st nextResponder is NSClipView
    // 2nd nextResponder is NSScrollView
    // 3rd nextResponder is NSResponder SwiftUIPlatformViewHost
    self.nextResponder?.nextResponder?.nextResponder?.scrollWheel(with: event)
  }
}

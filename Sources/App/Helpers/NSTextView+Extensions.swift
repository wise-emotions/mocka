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

  /// Remove `TextEditor` scroll.
  open override func scrollWheel(with event: NSEvent) {
    // The 1st nextResponder is NSClipView.
    // The 2nd nextResponder is NSScrollView.
    // The 3rd nextResponder is NSResponder SwiftUIPlatformViewHost.
    nextResponder?.nextResponder?.nextResponder?.scrollWheel(with: event)
  }
}

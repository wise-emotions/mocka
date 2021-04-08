//
//  Mocka
//

import SwiftUI

extension View {
  /// Helper that prints a value to the console while developing.
  /// Avoid using it in the final code.
  /// - Parameter value: Value to be printed.
  /// - Returns: Returns `self`, to be used inside any `View`.
  func debugPrint(_ value: Any) -> some View {
    #if DEBUG
      print(value)
    #endif
    return self
  }
}

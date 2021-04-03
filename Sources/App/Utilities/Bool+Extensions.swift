//
//  Mocka
//

import Foundation

extension Bool {
  /// Checks if the value of self is equal to false.
  /// This should be preferred over `!` for legibility.
  var isFalse: Bool {
    self == false
  }
}

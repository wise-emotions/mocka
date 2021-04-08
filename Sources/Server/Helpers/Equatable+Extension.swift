//
//  Mocka
//

import Foundation

extension Equatable {
  /// Checks that none of the elements included in an array correspond to `self`.
  /// This is more convenient way of doing `self != A, self != B, self != C`.
  /// - Parameter options: The list of options we want to compare `self` to.
  /// - Returns: True, if the array does not contain an element equal to `self`. False otherwise.
  func isNone(of options: [Self]) -> Bool {
    !options.contains { $0 == self }
  }
}

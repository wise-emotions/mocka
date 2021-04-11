//
//  Mocka
//

import Foundation

extension Bool {
  /// Checks if the value of self is equal to true.
  ///
  /// This should be used only in cases where the variable name is ambiguous.
  /// Example:
  ///
  ///     let toggleValue = true
  ///     if toggleValue.isTrue {
  ///       // code goes here
  ///     }
  ///
  /// Do not use it when the use case is evident.
  /// Example:
  ///
  ///     let isHidden = true
  ///     if isHidden {
  ///       // code goes here
  ///     }
  var isTrue: Bool {
    self
  }

  /// Checks if the value of self is equal to false.
  /// This should be preferred over `!` for legibility.
  var isFalse: Bool {
    !isTrue
  }
}

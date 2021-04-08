//
//  Mocka
//

import Foundation

extension String {
  /// Evaluates the format of a string from a specified regex.
  /// - Parameter regex: The regex to match.
  /// - Returns: A `Bool` indicating whether the string matches or not.
  func matchesRegex(_ regex: String) -> Bool {
    let predicate = NSPredicate(format: "self MATCHES %@", regex)
    return predicate.evaluate(with: self)
  }
  
  var asPrettyPrintedJSON: String? {
    data(using: .utf8)?.asPrettyPrintedJSON
  }
}


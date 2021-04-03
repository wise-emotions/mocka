//
//  Mocka
//

import Foundation

extension TimeInterval {
  /// Create a formatted `String` from a `TimeInterval`.
  /// - Parameter timeInterval: The `TimeInterval` to be formatted.
  /// - Returns: The formatted `String` in format `yyyy-MM-dd HH:mm:ss.SSS`.
  var timestampPrint: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

    return dateFormatter.string(from: Date(timeIntervalSince1970: self))
  }
}

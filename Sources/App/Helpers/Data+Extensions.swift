//
//  Mocka
//

import Foundation

extension Data {
  /// Converts the `Data` to a pretty printed JSON `String`.
  var prettyPrintedJSON: String? {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
      let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyPrintedString = String(data: jsonData, encoding: .utf8)
    else {
      return nil
    }

    return prettyPrintedString
  }
}

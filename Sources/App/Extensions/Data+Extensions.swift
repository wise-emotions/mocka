//
//  Mocka
//

import Foundation

extension Data {
  var asPrettyPrintedJSON: String? {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
      let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyPrintedString = String(data: jsonData, encoding:.utf8)
    else {
      return nil
    }
    
    return prettyPrintedString
  }
}

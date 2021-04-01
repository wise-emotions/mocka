//
//  Mocka
//

import Foundation

extension String {
  var asPrettyPrintedJSON: String? {
    data(using: .utf8)?.asPrettyPrintedJSON
  }
}

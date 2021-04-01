//
//  Mocka
//

import Foundation

extension URL {
  var prettyPrintedJSON: String? {
    try? Data(contentsOf: self).asPrettyPrintedJSON
  }
}

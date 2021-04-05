//
//  Mocka
//

import MockaServer
import UniformTypeIdentifiers

extension ResponseBody.ContentType {
  /// The `UTType` of the response file associated with the ResponseBody
  var uniformTypeIdentifier: UTType? {
    switch self {
    case .applicationJSON:
      return .json

    case .textCSS:
      return .css

    case .textCSV:
      return .csv

    case .textHTML:
      return .html

    case .textPlain:
      return .plainText

    case .textXML:
      return .xml

    case .custom:
      return nil
    }
  }
}

//
//  Mocka
//

import Foundation

extension Node {
  /// The type of the node.
  enum Kind {
    /// The node is a generic folder that can contain other folders.
    case folder
    
    /// The node is a request folder that should contain only the request and responses.
    case requestFolder
    
    /// The node is a file.
    case requestFile
  }
}

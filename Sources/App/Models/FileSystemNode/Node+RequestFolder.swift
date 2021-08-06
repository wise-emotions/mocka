//
//  Mocka
//

import Foundation

extension Node {
  /// A `Node` where `kind == .requestFolder`. Its children are files.
  struct RequestFolder: FolderNode, Identifiable, Equatable, Hashable {
    let kind = Node.Kind.requestFolder
    
    let name: String
    let url: URL
    
    /// The request file associated with the folder.
    let requestFile: RequestFile
  }
}

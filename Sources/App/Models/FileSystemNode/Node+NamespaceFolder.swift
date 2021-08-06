//
//  Mocka
//

import Foundation

extension Node {
  /// A `Node` where `kind == .folder`. Its children are other folders or requests.
  struct NamespaceFolder: FolderNode, Identifiable, Equatable, Hashable {
    let kind = Node.Kind.folder
    
    let name: String
    let url: URL
    
    /// The list of folders used as a namespace.
    let namespaces: [NamespaceFolder]
    
    /// The list of folders containing requests.
    let requests: [RequestFolder]
  }
}

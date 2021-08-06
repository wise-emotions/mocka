//
//  Mocka
//

import Foundation

extension Node {
  /// A `Node` where `kind == .file`.
  struct RequestFile: FileNode, Identifiable, Hashable {
    let kind = Node.Kind.requestFile
    
    let name: String
    let url: URL
    
    /// The `MockaApp.Request` extracted from the file.
    let request: MockaApp.Request
  }
}

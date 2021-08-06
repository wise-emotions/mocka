//
//  Mocka
//

import Foundation

extension Node {
  /// All actions that could be performed on a node.
  enum Action {
    /// The request can be edited.
    case editRequest

    /// A child request node can be created under the node.
    case createRequest

    /// A child folder node can be created under the node.
    case createFolder
  }
}

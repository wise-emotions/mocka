//
//  Mocka
//

import Foundation

/// A node in the file system tree starting with the root workspace.
///
/// This protocol cannot conform to `Identifiable` since it would trigger a
/// `Protocol 'FileSystemNode' can only be used as a generic constraint because it has Self or associated type requirements` when we try to return an array of `FileSystemNode`.
/// The workaround consists of conforming the concrete structs to `Identifiable` and have
/// ```
/// extension FileSystemNode where Self: Identifiable {
///   var id: String {
///     url.absoluteString
///   }
/// }
/// ```
/// to avoid having to implement `id` every single time.
/// When [SE-0309](https://github.com/apple/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md) is merged in swift,
/// we can get rid of this workaround.
protocol FileSystemNode {
  /// The name of the file or folder.
  var name: String { get }

  /// The kind of the node. Folder or `file`.
  var kind: Node.Kind { get }

  /// The `URL` to the node.
  var url: URL { get }
}

extension FileSystemNode {
  /// The list of available actions that can be performed on the node.
  var availableActions: [Node.Action] {
    switch kind {
    case .folder:
      return [.createRequest, .createFolder]
      
    case .requestFolder:
      return [.editRequest]

    case .requestFile:
      return [.editRequest]
    }
  }
}

extension FileSystemNode where Self: Identifiable {
  var id: String {
    url.absoluteString
  }
}

extension Node.RequestFile {
  /// The children of a folder.
  var children: [FileSystemNode]? {
    nil
  }
}

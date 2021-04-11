//
//  Mocka
//

import Foundation

/// An object representing a node (directory or file) in the filesystem.
struct FileSystemNode: Identifiable, Hashable {

  // MARK: - Stored Properties

  /// The identifier of the object.
  let id = UUID()

  /// The name of the file or folder.
  let name: String

  /// The kind of the node. Folder or `file`.
  let kind: Kind

  /// The `URL` to the node.
  let url: URL

  // MARK: - Computed Properties

  /// The children nodes of the directory. `nil` if the node represents a file.
  var children: [FileSystemNode]? {
    switch kind {
    case let .folder(children, _):
      return children

    case .requestFile:
      return nil
    }
  }

  // MARK: - Computed Properties

  /// Whether the node represents a directory in the filesystem.
  var isFolder: Bool {
    switch kind {
    case .folder:
      return true

    case .requestFile:
      return false
    }
  }

  // MARK: - Init

  /// Returns a `FileSystemNode`. An automatic `UUID` will be generated for each created node.
  /// - Parameters:
  ///   - name: The name of the file or folder.
  ///   - url: The `URL` to the node.
  ///   - kind: The kind of the node. Folder or `file`.
  init(name: String, url: URL, kind: FileSystemNode.Kind) {
    self.name = name
    self.url = url
    self.kind = kind
  }
}

// MARK: - Data Structure

extension FileSystemNode {
  /// The possibile kinds of `FileSystemNode`.
  enum Kind: Hashable {
    /// The node is a folder.
    /// `children` are the nodes inside of the folder.
    /// `isRequestFolder` is `true` when the folder contains a request.
    case folder(children: [FileSystemNode], isRequestFolder: Bool)

    /// The node is a request file.
    case requestFile(_ request: Request)
  }
}

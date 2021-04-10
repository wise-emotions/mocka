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

  /// The children nodes of the directory. `nil` if the node represents a file.
  let children: [FileSystemNode]?

  // MARK: - Computed Properties

  /// Whether the node represents a directory in the filesystem.
  var isFolder: Bool {
    kind == .folder
  }

  /// Whether the node represents a file in the filesystem.
  var isFile: Bool {
    kind == .file
  }

  // MARK: - Init

  /// Returns a `FileSystemNode`. An automatic `UUID` will be generated for each created node.
  /// - Parameters:
  ///   - name: The name of the file or folder.
  ///   - url: The `URL` to the node.
  ///   - kind: The kind of the node. Folder or `file`.
  ///   - children: The children nodes of the directory. `nil` if the node represents a file.
  init(name: String, url: URL, kind: FileSystemNode.Kind, children: [FileSystemNode]? = nil) {
    self.name = name
    self.url = url
    self.kind = kind
    self.children = children
  }
}

// MARK: - Data Structure

extension FileSystemNode {
  /// The possibile kinds of `FileSystemNode`.
  enum Kind {
    /// The node is a folder.
    case folder

    /// The node is a file.
    case file
  }
}

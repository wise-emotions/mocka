//
//  Mocka
//

import Foundation

/// An object representing a node (i.e: directory or file) in the filesystem.
struct FileSystemNode: Identifiable, Hashable {

  // MARK: - Stored Properties

  /// The identifier of the object.
  let id = UUID()

  /// The name of the file or folder.
  let name: String

  /// The children nodes of the directory. `nil` if the node represents a file.
  let children: [FileSystemNode]?

  // MARK: - Computed Properties

  /// Whether the node represents a directory in the filesystem.
  var isFolder: Bool {
    !isFile
  }

  /// Whether the node represents a file in the filesystem.
  var isFile: Bool {
    children == nil
  }

  // MARK: - Init

  init(name: String, children: [FileSystemNode]? = nil) {
    self.name = name
    self.children = children
  }
}

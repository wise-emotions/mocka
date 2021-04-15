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

  /// Whether the node represents a directory in the filesystem.
  var isFolder: Bool {
    switch kind {
    case .folder:
      return true

    case .requestFile:
      return false
    }
  }
  
  /// The list of available actions that can be performed on the node.
  var availableActions: [Action] {
    switch kind {
    case let .folder(children: _, isRequestFolder: isRequestFolder):
      return isRequestFolder ? [.edit, .delete] : [.create]
      
    case .requestFile(_):
      return [.edit, .delete]
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

  // MARK: - Functions

  /// Returns a set containing the node alongside all its children.
  func flatten() -> Set<FileSystemNode> {
    var nodes: Set<FileSystemNode> = [self]

    guard let children = children else {
      return nodes
    }

    nodes = children.reduce(into: nodes) {
      $0.formUnion($1.flatten())
    }

    return nodes
  }
}

// MARK: - Data Structure

extension FileSystemNode {
  /// All actions that could be performed on `FileSystemNode`.
  enum Action {
    /// A child node can be created under the node.
    case create
    
    /// The node can be deleted.
    case delete
    
    /// The node can be edited.
    case edit
  }

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

extension Array where Element == FileSystemNode {
  /// Returns a set containing all the node alongside their children.
  func flatten() -> Set<Element> {
    self.reduce(into: Set<FileSystemNode>()) {
      $0.formUnion($1.flatten())
    }
  }
}

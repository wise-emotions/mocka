//
//  Mocka
//

import Foundation

/// The view model of the `SourcesTreeView`.
final class SourcesTreeViewModel: ObservableObject {

  // MARK: - Constants

  /// The resource keys for the infos to extract from a `URL`.
  static let resourceKeys: Set<URLResourceKey> = [.nameKey, .isDirectoryKey]

  // MARK: - Stored Properties

  /// The contents of the directory.
  @Published var directoryContent: [FileSystemNode] = []

  // MARK: - Init

  init() {
    guard let directoryURL = FileManager.default.urls(for: .developerDirectory, in: .userDomainMask).first else {
      directoryContent = []
      return
    }

    directoryContent = enumerateDirectory(at: directoryURL)
  }

  /// Enumerates the contents of a directory.
  /// - Parameter url: The `URL` of the directory to scan.
  /// - Returns: An array of `FileSystemNode` containing all subnodes of the directory.
  private func enumerateDirectory(at url: URL) -> [FileSystemNode] {
    guard
      let directoryEnumerator = FileManager.default.enumerator(
        at: url,
        includingPropertiesForKeys: Array(SourcesTreeViewModel.resourceKeys),
        options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
      )
    else {
      return []
    }

    var nodes: [FileSystemNode] = []

    for case let fileURL as URL in directoryEnumerator {
      if let node = node(at: fileURL) {
        nodes.append(node)
      }
    }

    return nodes
  }

  /// Gets the filesystem node at the specified `URL`.
  /// - Parameter url: The `URL` of the node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`.
  private func node(at url: URL) -> FileSystemNode? {
    guard let (name, isDirectory) = resourceValues(for: url) else {
      return nil
    }

    return FileSystemNode(name: name, children: isDirectory ? enumerateDirectory(at: url) : nil)
  }

  /// Returns informations about the specified `URL`.
  /// - Parameter url: The `URL` to retrieve information from.
  /// - Returns: A tuple containing the name of the directory or file and a `Bool` indicating whether the `URL` represents a directory.
  private func resourceValues(for url: URL) -> (name: String, isDirectory: Bool)? {
    guard
      let resourceValues = try? url.resourceValues(forKeys: SourcesTreeViewModel.resourceKeys),
      let isDirectory = resourceValues.isDirectory,
      let name = resourceValues.name
    else {
      return nil
    }

    return (name: name, isDirectory: isDirectory)
  }
}

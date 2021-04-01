//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers

/// The view model of the `SourcesTreeView`.
final class SourcesTreeViewModel: ObservableObject {

  // MARK: - Constants

  /// The resource keys for the infos to extract from a `URL`.
  /// `.nameKey` returns the name of the file.
  /// `.contentTypeKey` returns the type of the file. Example "public.json".
  static let resourceKeys: Set<URLResourceKey> = [.nameKey, .contentTypeKey]

  /// The list of types allowed in the tree.
  static let allowedTypes: Set<UTType?> = [
    UTType("public.json"),
    UTType("public.comma-separated-values-text"),
    UTType("public.plain-text"),
    UTType("public.html"),
    UTType("public.xml"),
    UTType("public.css")
  ]

  /// The list of allowed file names.
  /// This list is used to filter out what files will be displayed in the sources tree.
  static let allowedFileNames: Set<String> = [
    "request.json",
    "response.json",
    "response.csv",
    "response.css",
    "response.html",
    "response.plain",
    "response.xml"
  ]

  // MARK: - Stored Properties

  /// The contents of the directory.
  @Published var directoryContent: [FileSystemNode] = []

  // MARK: - Init

  init() {
    guard let rootDirectory = Logic.RootPath.value else {
      directoryContent = []
      return
    }

    directoryContent = enumerateDirectory(at: rootDirectory)
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
    guard let (name, contentType) = resourceValues(for: url) else {
      return nil
    }

    if SourcesTreeViewModel.allowedTypes.contains(contentType), SourcesTreeViewModel.allowedFileNames.contains(name) {
      return FileSystemNode(name: name, fileURL: url)
    } else if contentType == UTType(kUTTypeFolder as String) {
      // Filter by contentType to make sure the directory is a folder, since files like Playgrounds are seen as directories.
      return FileSystemNode(name: name, fileURL: url, children: enumerateDirectory(at: url))
    }

    return nil
  }

  /// Returns informations about the specified `URL`.
  /// - Parameter url: The `URL` to retrieve information from.
  /// - Returns: A tuple containing the name of the directory or file and the `UTType` of the file or folder.
  private func resourceValues(for url: URL) -> (name: String, contentType: UTType)? {
    guard
      let resourceValues = try? url.resourceValues(forKeys: SourcesTreeViewModel.resourceKeys),
      let name = resourceValues.name,
      let contentType = resourceValues.contentType
    else {
      return nil
    }

    return (name, contentType)
  }
}

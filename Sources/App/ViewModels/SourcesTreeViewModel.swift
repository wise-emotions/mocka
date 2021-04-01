//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers
import Server

/// The view model of the `SourcesTreeView`.
final class SourcesTreeViewModel: ObservableObject {

  // MARK: - Constants

  /// The resource keys for the infos to extract from a `URL`.
  /// `.nameKey` returns the name of the file.
  /// `.contentTypeKey` returns the type of the file. Example "public.json".
  static let resourceKeys: Set<URLResourceKey> = [.nameKey, .contentTypeKey]

  /// The list of types allowed in the tree.
  static let allowedTypes: Set<UTType?> = [
    .commaSeparatedValues,
    .css,
    .html,
    .json,
    .plainText,
    .xml
  ]

  /// The list of allowed file names.
  /// This list is used to filter out what files will be displayed in the sources tree.
  static let allowedFileNames: Set<String> = ResponseBody.ContentType.allCases.reduce(into: Set<String>()) {
    guard let fileExtension = $1.expectedFileExtension else {
      return
    }
    $0.insert("request.\(fileExtension)")
    $0.insert("response.\(fileExtension)")
  }

  /// The regex the name of the folder should match to be allowed in the tree.
  static let folderNameRegex: String = "(CONNECT|DELETE|GET|HEAD|OPTIONS|PATCH|POST|PUT|TRACE)-[A-Za-z0-9-]*"

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
  /// - Returns: An array of `FileSystemNode` containing all sub-nodes of the directory.
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

    if isValidFile(name: name, contentType: contentType) {
      return FileSystemNode(name: name, url: url, kind: .file)
    } else {
      return folderNode(at: url)
    }
  }

  /// Creates the node for a folder, provided that the `URL` points to a valid folder.
  /// - Parameter url: The `URL` of the folder node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`. `nil` if the `URL` doesn't point to a folder or the folder is not valid.
  private func folderNode(at url: URL) -> FileSystemNode? {
    guard
      let (name, contentType) = resourceValues(for: url),
      contentType == .folder
    else {
      return nil
    }

    let children = enumerateDirectory(at: url)

    if children.contains(where: { $0.isFolder }) {
      return FileSystemNode(name: name, url: url, kind: .folder, children: children)
    } else {
      return name.matchesRegex(SourcesTreeViewModel.folderNameRegex) ? FileSystemNode(name: name, url: url, kind: .folder, children: children) : nil
    }
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

  /// Checks if the specified file name and content type are allowed in the tree.
  /// - Parameters:
  ///   - name: The name of the file to check.
  ///   - contentType: The type of the file to check.
  /// - Returns: A `Bool` indicating whether the file is valid and should be allowed in the tree.
  private func isValidFile(name: String, contentType: UTType) -> Bool {
    SourcesTreeViewModel.allowedTypes.contains(contentType) && SourcesTreeViewModel.allowedFileNames.contains(name)
  }
}

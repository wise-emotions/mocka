//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers
import MockaServer

/// The view model of the `SourcesTree`.
final class SourcesTreeViewModel: ObservableObject {

  // MARK: - Constants

  /// The resource keys for the infos to extract from a `URL`.
  /// `.nameKey` returns the name of the file.
  /// `.contentTypeKey` returns the type of the file. Example "public.json".
  private static let resourceKeys: Set<URLResourceKey> = [.nameKey, .contentTypeKey]

  /// The list of types allowed in the tree.
  private static let allowedTypes: Set<UTType> = ResponseBody.ContentType.allCases.reduce(into: Set<UTType>()) {
    guard let uniformTypeIdentifier = $1.uniformTypeIdentifier else {
      return
    }

    $0.insert(uniformTypeIdentifier)
  }

  /// The allowed name for a file containing a request.
  private static let allowedRequestFileName = "request.json"

  /// The list of allowed file names for a response.
  /// This list is used to filter out what files will be displayed in the sources tree.
  private static let allowedResponseFileNames = ResponseBody.ContentType.allCases.reduce(into: Set<String>()) {
    guard let fileExtension = $1.expectedFileExtension else {
      return
    }

    $0.insert("response.\(fileExtension)")
  }

  /// The regex the name of the folder should match to be allowed in the tree.
  private static var folderNameRegex: String {
    let allSupportedMethods = HTTPMethod.allCases.map {
      $0.rawValue
    }
    .joined(separator: "|")

    return "(\(allSupportedMethods))-[A-Za-z0-9-]*"
  }

  // MARK: - Stored Properties

  /// The contents of the directory.
  @Published var directoryContent: [FileSystemNode] = []

  // MARK: - Init

  /// Returns an instance of `SourcesTreeViewModel`.
  ///
  /// This instantiation will fail if the root path value has not been set yet.
  init() throws {
    guard let rootDirectory = Logic.RootPath.value else {
      throw MockaError.missingRootPathValue
    }

    directoryContent = contents(of: rootDirectory)
  }

  // MARK: - Functions

  /// Enumerates the contents of a directory.
  /// - Parameter url: The `URL` of the directory to scan.
  /// - Returns: An array of `FileSystemNode` containing all sub-nodes of the directory.
  private func contents(of url: URL) -> [FileSystemNode] {
    guard
      let directoryEnumerator = FileManager.default.enumerator(
        at: url,
        includingPropertiesForKeys: Array(SourcesTreeViewModel.resourceKeys),
        options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
      )
    else {
      return []
    }

    return directoryEnumerator.reduce(into: [FileSystemNode]()) {
      guard let url = $1 as? URL, let node = node(at: url) else {
        return
      }

      $0.append(node)
    }
  }

  /// Gets the filesystem node at the specified `URL`.
  /// - Parameter url: The `URL` of the node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`.
  private func node(at url: URL) -> FileSystemNode? {
    guard let (name, contentType) = resourceValues(for: url) else {
      return nil
    }

    if contentType == .folder {
      return folderNode(at: url)
    } else {
      return isValidFile(name: name, contentType: contentType) ?
        FileSystemNode(name: name, url: url, kind: .file) : nil
    }
  }

  /// Creates the node for a folder, provided that the `URL` points to a valid folder.
  /// - Parameter url: The `URL` of the folder node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`. `nil` if the `URL` doesn't point to a folder or the folder is not valid.
  private func folderNode(at url: URL) -> FileSystemNode? {
    guard let (name, contentType) = resourceValues(for: url), contentType == .folder else {
      return nil
    }

    let children = contents(of: url)

    // If the folder contains other folder, return the node.
    if children.contains(where: { $0.isFolder }) {
      return FileSystemNode(name: name, url: url, kind: .folder, children: children)
    } else {
      // Check if the folder name is sound. If not, return nil.
      // Check if the folder contains at least a request. If not, return nil.
      // Some folders can contain no response.
      guard
        name.matchesRegex(SourcesTreeViewModel.folderNameRegex) &&
          children.contains(where: { $0.name == SourcesTreeViewModel.allowedRequestFileName })
      else {
        return nil
      }

      return FileSystemNode(name: name, url: url, kind: .folder, children: children)
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
    if name == SourcesTreeViewModel.allowedRequestFileName {
      return true
    }

    return SourcesTreeViewModel.allowedTypes.contains(contentType) && SourcesTreeViewModel.allowedResponseFileNames.contains(name)
  }
}

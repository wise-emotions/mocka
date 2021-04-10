//
//  Mocka
//

import MockaServer
import UniformTypeIdentifiers

/// The ViewModel of the `SourceTree`.
final class SourceTreeViewModel: ObservableObject {

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
    let allSupportedMethods = HTTPMethod.allCases
      .map {
        $0.rawValue
      }
      .joined(separator: "|")

    return "(\(allSupportedMethods))-[A-Za-z0-9-]*"
  }

  // MARK: - Stored Properties

  /// The contents of the directory.
  @Published var directoryContent: [FileSystemNode] = []

  // MARK: - Init

  /// Returns an instance of `SourceTreeViewModel`.
  ///
  /// This instantiation will fail if the workspace path value has not been set yet.
  /// - Parameter workspacePath: The user workspace path.
  /// - Throws: `MockaError.missingWorkspacePathValue` if `path` is `nil`.
  init(workspacePath: URL?) throws {
    guard let workspaceDirectory = workspacePath else {
      throw MockaError.missingWorkspacePathValue
    }

    directoryContent = Logic.SourceTree.contents(of: workspaceDirectory)
  }
}

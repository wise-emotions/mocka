//
//  Mocka
//

import MockaServer
import SwiftUI

/// The ViewModel of the `SourceTree`.
final class SourceTreeViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The text that filters the requests.
  @Published var filterText: String = ""

  /// The contents of the directory.
  @Published var directoryContent: [FileSystemNode] = []

  /// The value of the workspace path.
  /// When this value is updated, the value in the user defaults is updated as well.
  @AppStorage(UserDefaultKey.workspaceURL) private var workspaceURL: URL?

  // MARK: - Computed Properties

  /// The directories contents filtered based on the the filtered text, if any.
  var filteredNodes: [FileSystemNode] {
    #warning("Needs implementation.")
    return directoryContent
  }

  // MARK: - Init

  /// Returns an instance of `SourceTreeViewModel`.
  ///
  /// This instantiation will fail if the workspace path value has not been set yet.
  /// - Throws: `MockaError.missingWorkspacePathValue` if `path` is `nil`.
  init() throws {
    try refreshContent()
  }

  // MARK: - Functions

  /// Creates the correct `EditorDetailViewModel` for the node.
  /// - Parameter node: The node we want to generate the `EditorDetailViewModel` for.
  /// - Returns: An instance of `EditorDetailViewModel`.
  func detailViewModel(for node: FileSystemNode) -> EditorDetailViewModel {
    switch node.kind {
    case .folder:
      return EditorDetailViewModel()

    case let .requestFile(request):
      // The parent of the node, but that is the folder with the regex `METHOD - name of API`.
      let requestFolderNode = directoryContent.flatten().first { $0.children?.contains(node) ?? false }!
      // The parent namespace folder.
      let parent = directoryContent.flatten().first { $0.children?.contains(requestFolderNode) ?? false }

      let requestNameTrimmingLowerBound = requestFolderNode.name.range(
        of: "\(request.method.rawValue) - "
      )?.upperBound ?? requestFolderNode.name.endIndex

      let requestName = String(requestFolderNode.name[requestNameTrimmingLowerBound..<requestFolderNode.name.endIndex])

      return EditorDetailViewModel(selectedRequest: request, requestName: requestName, requestParentFolder: parent)
    }
  }

  /// Updates the `directoryContent` by iterating over the contents of the workspace directory.
  func refreshContent() throws {
    guard let workspaceDirectory = workspaceURL else {
      throw MockaError.missingWorkspacePathValue
    }

    directoryContent = Logic.SourceTree.contents(of: workspaceDirectory)
  }
}

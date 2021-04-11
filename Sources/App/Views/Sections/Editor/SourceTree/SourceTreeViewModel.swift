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

  /// Updates the `directoryContent` by iterating over the contents of the workspace directory.
  func refreshContent() throws {
    guard let workspaceDirectory = workspaceURL else {
      throw MockaError.missingWorkspacePathValue
    }

    directoryContent = Logic.SourceTree.contents(of: workspaceDirectory)
  }
}

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

  /// The sourceTree of the workspace.
  var sourceTree: FileSystemNode {
    editorSectionEnvironment.sourceTree
  }

  /// When true the `EditorDetail` in `.create` mode will be shown.
  ///
  /// This is needed due to a limitation in `SwiftUI` where the toolbar cannot have its own navigation link invoked from a button.
  @Published var isShowingCreateRequestDetailView = false

  /// The value of the workspace path.
  /// When this value is updated, the value in the user defaults is updated as well.
  @AppStorage(UserDefaultKey.workspaceURL) private var workspaceURL: URL?

  /// The selected `FileSystemNode`.
  var selectedNode: FileSystemNode? = nil

  /// The node that is currently being renamed.
  var renamingNode: FileSystemNode? = nil

  /// The environment of the editor.
  private var editorSectionEnvironment: EditorSectionEnvironment

  // MARK: - Computed Properties

  /// The directories contents filtered based on the the filtered text, if any.
  var filteredNodes: [FileSystemNode] {
    #warning("Needs implementation")
    return sourceTree.children?.sorted(by: { $0.name < $1.name }) ?? []
  }

  /// Checks if the workspace contains any valid nodes.
  var isSourceTreeEmpty: Bool {
    guard let children = sourceTree.children else {
      return true
    }

    return children.isEmpty
  }

  // MARK: - Init

  /// Returns an instance of `SourceTreeViewModel`.
  ///
  /// This instantiation will fail if the workspace path value has not been set yet.
  /// - Throws: `MockaError.missingWorkspacePathValue` if `path` is `nil`.
  init(editorSectionEnvironment: EditorSectionEnvironment) {
    self.editorSectionEnvironment = editorSectionEnvironment
  }

  // MARK: - Functions

  /// Creates the correct `EditorDetailViewModel` for the node.
  /// - Parameter node: The node we want to generate the `EditorDetailViewModel` for.
  /// - Returns: An instance of `EditorDetailViewModel`.
  func detailViewModel(for node: FileSystemNode?) -> EditorDetailViewModel {
    if let selectedNode = selectedNode, selectedNode.isFolder {
      return EditorDetailViewModel(
        sourceTree: sourceTree,
        requestParentFolder: selectedNode,
        mode: .create,
        onSave: { [weak self] in
          try? self?.refreshContent()
        },
        onCancel: { [weak self] in
          self?.isShowingCreateRequestDetailView = false
        }
      )
    }

    guard let node = node else {
      return EditorDetailViewModel(
        sourceTree: sourceTree,
        mode: .create,
        onSave: { [weak self] in
          try? self?.refreshContent()
        },
        onCancel: { [weak self] in
          self?.isShowingCreateRequestDetailView = false
        }
      )
    }

    switch node.kind {
    case .folder:
      return EditorDetailViewModel(sourceTree: sourceTree)

    case .requestFile:
      let flatDirectories = sourceTree.flatten()
      // The parent of the node, but that is the folder with the regex `METHOD - name of API`.
      let requestFolderNode = flatDirectories.first { $0.children?.contains(node) ?? false }!
      // The parent namespace folder.
      let parent = flatDirectories.first { $0.children?.contains(requestFolderNode) ?? false }!

      return EditorDetailViewModel(
        sourceTree: sourceTree,
        requestFile: node, requestFolder: requestFolderNode, requestParentFolder: parent,
        onSave: { [weak self] in
          try? self?.refreshContent()
        }
      )
    }
  }

  /// Updates the `sourceTree` by iterating over the contents of the workspace directory.
  func refreshContent() throws {
    editorSectionEnvironment.sourceTree = Logic.SourceTree.sourceTree()
  }

  /// Returns the name of the action.
  /// - Parameter action: The `FileSystemNode.Action`.
  /// - Returns: The name of the action.
  func actionName(action: FileSystemNode.Action) -> String {
    switch action {
    case .createRequest:
      return "Add Request"

    case .createFolder:
      return "Add Folder"

    case .editRequest:
      return "Edit Request"
    }
  }

  /// Performs the action associated with the context menu item.
  /// - Parameters:
  ///   - action: The `FileSystemNode.Action` to perform.
  ///   - node: The `FileSystemNode` on which the action is performed to.
  func performAction(_ action: FileSystemNode.Action, on node: FileSystemNode? = nil) throws {
    selectedNode = node

    switch action {
    case .createRequest:
      isShowingCreateRequestDetailView = true

    case .createFolder:
      guard let parentFolder = node?.url ?? UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) else {
        throw MockaError.missingWorkspacePathValue
      }

      // Create a folder using the "untitled folder" name.
      // If the folder already exists, adds an incrementing postfix until the folder is successfully created.
      for index in 0...Int.max {
        let directoryName = "untitled folder" + (index == 0 ? "" : " \(index)")

        if let createdNode = try? Logic.SourceTree.addDirectory(at: parentFolder, named: directoryName) {
          renamingNode = createdNode
          break
        }
      }

      try refreshContent()

    case .editRequest:
      isShowingCreateRequestDetailView = true
    }
  }

  /// Renames the node.
  /// - Parameters:
  ///   - node: The `FileSystemNode` to rename.
  ///   - name: The updated name.
  func renameNode(_ node: FileSystemNode, to name: String) throws {
    try Logic.SourceTree.renameDirectory(node: node, to: name)
    renamingNode = nil
    try refreshContent()
  }
}

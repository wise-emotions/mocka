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
  var sourceTree: Node.NamespaceFolder {
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
    #warning("Needs correct implementation")
    var allFolders: [FileSystemNode] = sourceTree.namespaces
    allFolders.append(contentsOf: sourceTree.requests)
    return allFolders.sorted(by: { $0.name < $1.name })
  }
  
  /// Checks if the workspace contains any valid nodes.
  var isSourceTreeEmpty: Bool {
    sourceTree.namespaces.isEmpty && sourceTree.requests.isEmpty
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
    guard let node = node else {
      return EditorDetailViewModel(sourceTree: sourceTree)
    }
    
    switch node.kind {
    case .folder:
      return EditorDetailViewModel(sourceTree: sourceTree)
      
    case .requestFile, .requestFolder:
      if let requestFolder = node as? Node.RequestFolder {
        return EditorDetailViewModel(sourceTree: sourceTree, requestFolder: requestFolder)
      } else if
        let requestFile = node as? Node.RequestFile,
        let requestFolder = try? Logic.SourceTree.requestFolders().first(where: { $0.requestFile == requestFile })
      {
        return EditorDetailViewModel(sourceTree: sourceTree, requestFolder: requestFolder)
      } else {
        // Should never happen.
        return EditorDetailViewModel(sourceTree: sourceTree)
      }
    }
  }
  
  /// Updates the `sourceTree` by iterating over the contents of the workspace directory.
  func refreshContent() throws {
    editorSectionEnvironment.sourceTree = Logic.SourceTree.sourceTree()
  }
  
  /// Returns the name of the action.
  /// - Parameter action: The `Node.Action`.
  /// - Returns: The name of the action.
  func actionName(action: Node.Action) -> String {
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
  ///   - action: The `Node.Action` to perform.
  ///   - node: The `Node` on which the action is performed to.
  func performAction(_ action: Node.Action, on node: FileSystemNode? = nil) throws {
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
        
        if let createdNode = try? Logic.SourceTree.addNamespaceFolder(at: parentFolder, named: directoryName) {
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
  ///   - node: The `FolderNode` to rename.
  ///   - name: The updated name.
  func renameNode<T: FolderNode>(_ node: T, to name: String) throws {
    try Logic.SourceTree.rename(folder: node, to: name)
    renamingNode = nil
    try refreshContent()
  }
}

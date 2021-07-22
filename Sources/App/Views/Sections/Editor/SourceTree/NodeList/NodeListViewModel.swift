//
//  Mocka
//

import SwiftUI

class NodeListViewModel: ObservableObject {
  var nodes: [FileSystemNode]
  /// The node that is currently being renamed.
  var renamingNode: FileSystemNode?
  var listState: [URL: Bool]
  var detailViewModel: (FileSystemNode?) -> EditorDetailViewModel
  var renameNode: (FileSystemNode, String) throws -> Void
  var actionName: (FileSystemNode.Action) -> String
  var performAction: (FileSystemNode.Action, FileSystemNode?) throws -> Void

  init(
    nodes: [FileSystemNode],
    renamingNode: FileSystemNode?,
    listState: [URL: Bool],
    detailViewModel: @escaping (FileSystemNode?) -> EditorDetailViewModel,
    renameNode: @escaping (FileSystemNode, String) throws -> Void,
    actionName: @escaping (FileSystemNode.Action) -> String,
    performAction: @escaping (FileSystemNode.Action, FileSystemNode?) throws -> Void
  ) {
    self.nodes = nodes
    self.renamingNode = renamingNode
    self.listState = listState
    self.detailViewModel = detailViewModel
    self.renameNode = renameNode
    self.actionName = actionName
    self.performAction = performAction
  }
}

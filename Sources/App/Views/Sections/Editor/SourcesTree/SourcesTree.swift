//
//  Mocka
//

import SwiftUI

/// A view that displays the content of directories containing a request/response? pair in the form of a tree.
struct SourcesTree: View {
  /// The view model of the directory tree.
  @StateObject var viewModel: SourcesTreeViewModel

  var body: some View {
    List(viewModel.directoryContent, children: \.children) { node in
      NavigationLink(destination: Text(node.url.path)) {
        SourcesTreeNode(name: node.name, isFolder: node.isFolder)
      }
      .contextMenu(
        ContextMenu(
          menuItems: {
            Button("Delete", action: {})
            Button("Edit", action: {})
          }
        )
      )
    }
    .listStyle(SidebarListStyle())
  }
}

struct SourcesTreePreviews: PreviewProvider {
  static var previews: some View {
    SourcesTree(viewModel: try! SourcesTreeViewModel(workspacePath: nil))
  }
}

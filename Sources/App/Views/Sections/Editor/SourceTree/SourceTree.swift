//
//  Mocka
//

import SwiftUI

/// A view that displays the content of directories containing a request/response? pair in the form of a tree.
struct SourceTree: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @StateObject var viewModel: SourceTreeViewModel

  // MARK: - Body

  var body: some View {
    List(viewModel.directoryContent, children: \.children) { node in
      NavigationLink(destination: Text(node.url.path)) {
        SourceTreeNode(name: node.name, isFolder: node.isFolder)
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

// MARK: - Previews

struct SourceTreePreviews: PreviewProvider {
  static var previews: some View {
    SourceTree(viewModel: try! SourceTreeViewModel(workspacePath: nil))
  }
}

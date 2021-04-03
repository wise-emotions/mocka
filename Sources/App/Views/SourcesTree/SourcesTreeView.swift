//
//  Mocka
//

import SwiftUI

/// A view that displays the content of directories containing a request/response? pair in the form of a tree.
struct SourcesTreeView: View {
  /// The view model of the directory tree.
  @StateObject var viewModel: SourcesTreeViewModel

  var body: some View {
      List(viewModel.directoryContent, children: \.children) { node in
        NavigationLink(destination: Text(node.url.path)) {
          Node(name: node.name, isFolder: node.isFolder)
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

extension SourcesTreeView {
  /// A view that displays a node into a tree.
  struct Node: View {
    /// The name of the file or folder.
    let name: String

    /// Whether the node represents a folder or not.
    let isFolder: Bool

    var body: some View {
      HStack {
        Image(systemName: isFolder ? "folder" : "doc.fill")
          .foregroundColor(isFolder ? .accentColor : .latte)
          .frame(width: 24)

        Text(name)
      }
    }
  }
}

struct SourcesTreeView_Previews: PreviewProvider {
  static var previews: some View {
    SourcesTreeView(viewModel: try! SourcesTreeViewModel())
  }
}

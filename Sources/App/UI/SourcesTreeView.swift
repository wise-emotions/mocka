//
//  Mocka
//

import SwiftUI

/// A view that displays the content of a directory in the form of a tree.
struct SourcesTreeView: View {
  /// The view model of the directory tree.
  @StateObject var viewModel: SourcesTreeViewModel

  var body: some View {
    List(viewModel.directoryContent, children: \.children) { node in
      Node(name: node.name, isFolder: node.isFolder)
    }
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
        Image(systemName: isFolder ? "folder.fill" : "doc.text.fill")
          .foregroundColor(isFolder ? .yellow : .white)
          .frame(width: 24)

        Text(name)
      }
    }
  }
}

struct SourcesTreeView_Previews: PreviewProvider {
  static let exampleDirectoryContent = FileSystemNode(
    name: "Developer",
    children: [
      FileSystemNode(name: "Mocka", children: [
        FileSystemNode(name: "Sources"),
        FileSystemNode(name: "Resources")
      ]),
      FileSystemNode(name: "logo.png")
    ]
  )

  static var previews: some View {
    SourcesTreeView(viewModel: SourcesTreeViewModel())
  }
}

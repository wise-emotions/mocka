//
//  Mocka
//

import SwiftUI

/// A view that displays the content of a directory in the form of a tree.
struct SourcesTreeView: View {
  /// The parent node of the tree.
  let parentNode: FileSystemNode

  var body: some View {
    if let nodes = parentNode.children {
      List(nodes, children: \.children) { node in
        Text(node.name)
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
    SourcesTreeView(parentNode: exampleDirectoryContent)
  }
}

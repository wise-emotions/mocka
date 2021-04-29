//
//  Mocka
//

import SwiftUI

/// A view that displays a node into a tree.
struct SourceTreeNode: View {

  // MARK: - Stored Properties

  /// The name of the file or folder.
  let name: String

  /// Whether the node represents a folder or not.
  let isFolder: Bool

  // MARK: - Body

  var body: some View {
    HStack {
      Image(systemName: isFolder ? SFSymbol.folder.rawValue : SFSymbol.document.rawValue)
        .foregroundColor(isFolder ? .accentColor : .latte)
        .frame(width: 24)

      Text(name)
    }
  }
}

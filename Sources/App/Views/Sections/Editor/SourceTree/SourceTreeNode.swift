//
//  Mocka
//

import Introspect
import SwiftUI

/// A view that displays a node into a tree.
struct SourceTreeNode: View {

  // MARK: - Stored Properties

  /// The name of the file or folder.
  @State var name: String

  /// Whether the `TextField` should become the first responder.
  /// - Note: This is needed since invoking `becomeFirstResponder` more than once will result in resigning the first responder.
  @State var shouldBecomeFirstResponder: Bool

  /// Whether the node represents a folder or not.
  let isFolder: Bool

  /// Whether the node is being renamed or not.
  let isRenaming: Bool

  // MARK: - Interaction

  /// The user renamed the node.
  var onRenamed: ((String) -> Void)?

  // MARK: - Body

  var body: some View {
    HStack {
      Image(systemName: isFolder ? SFSymbol.folder.rawValue : SFSymbol.document.rawValue)
        .foregroundColor(isFolder ? .accentColor : .latte)
        .frame(width: 24)

      if isRenaming {
        TextField(
          "Folder name", text: $name,
          onCommit: {
            if name.isNotEmpty {
              onRenamed?(name)
            }
          }
        )
        .introspectTextField { textField in
          if isRenaming && shouldBecomeFirstResponder {
            textField.becomeFirstResponder()
            shouldBecomeFirstResponder = false
          }
        }
      } else {
        Text(name)
      }
    }
  }

  // MARK: - Init

  /// Creates an instance of `SourceTreeNode`.
  /// - Parameters:
  ///   - name: The name of the node.
  ///   - isFolder: Whether the node is a folder or not.
  ///   - isRenaming: Whether the node is being renamed.
  ///   - onRenamed: The closure invoked after renaming the node with the new name.
  init(name: String, isFolder: Bool, isRenaming: Bool = false, onRenamed: ((String) -> Void)? = nil) {
    self.name = name
    self.shouldBecomeFirstResponder = isRenaming
    self.isFolder = isFolder
    self.isRenaming = isRenaming
    self.onRenamed = onRenamed
  }
}

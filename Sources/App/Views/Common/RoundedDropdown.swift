//
//  Mocka
//

import MockaServer
import SwiftUI

/// A dropdown with rounded border.
struct RoundedDropdown<Item: Hashable>: View {
  /// The title of the dropdown.
  let title: String

  /// The selected item.
  @Binding var selection: Item?

  /// A list of item to display in the menu.
  let items: [Item]

  /// The `KeyPath` leading to a `String` describing the item.
  let itemTitleKeyPath: KeyPath<Item, String>

  var body: some View {
    Menu {
      ForEach(items, id: \.hashValue) { item in
        Button(item[keyPath: itemTitleKeyPath]) {
          onSelect(item)
        }.tag(item.hashValue)
      }
    } label: {
      Text(selection?[keyPath: itemTitleKeyPath] ?? title)
    }
    .menuStyle(BorderlessButtonMenuStyle())
    .font(.system(size: 12))
    .padding(.horizontal, 14)
    .padding(.vertical, 10)
    .overlay(borderOverlay)
  }

  /// Handles the selection of an item in the menu and updates the binding.
  private func onSelect(_ item: Item) {
    selection = item
  }

  /// An overlay that draws a rounded border on the view.
  private var borderOverlay: some View {
    RoundedRectangle(cornerRadius: 6, style: .continuous)
      .stroke(Color.americano, lineWidth: 1)
  }
}

struct RoundedDropdown_Preview: PreviewProvider {
  static var previews: some View {
    RoundedDropdown(
      title: "Method",
      selection: .constant(HTTPMethod.get),
      items: HTTPMethod.allCases,
      itemTitleKeyPath: \.rawValue
    )
    .previewLayout(.fixed(width: 160, height: 64))
  }
}

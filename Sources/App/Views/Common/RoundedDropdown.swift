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
    .menuStyle(RoundedBorderMenuStyle())
  }

  /// Handles the selection of an item in the menu and updates the binding.
  private func onSelect(_ item: Item) {
    selection = item
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

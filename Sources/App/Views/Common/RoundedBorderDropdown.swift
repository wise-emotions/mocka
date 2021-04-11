//
//  Mocka
//

import MockaServer
import SwiftUI

/// A dropdown with rounded border.
struct RoundedBorderDropdown<Item: Hashable>: View {
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
        }
        .foregroundColor(.latte)
        .tag(item.hashValue)
      }
    } label: {
      Text(selection?[keyPath: itemTitleKeyPath] ?? title)
        .foregroundColor(.latte)
    }
    .menuStyle(RoundedBorderMenuStyle())
  }

  /// Handles the selection of an item in the menu and updates the binding.
  private func onSelect(_ item: Item) {
    selection = item
  }
}

struct RoundedBorderDropdownPreview: PreviewProvider {
  static var previews: some View {
    RoundedBorderDropdown(
      title: "Method",
      selection: .constant(HTTPMethod.get),
      items: HTTPMethod.allCases,
      itemTitleKeyPath: \.rawValue
    )
    .previewLayout(.fixed(width: 160, height: 64))
  }
}
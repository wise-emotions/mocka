//
//  Mocka
//

import MockaServer
import SwiftUI

/// A dropdown with rounded border.
struct RoundedBorderDropdown<Item: Hashable>: View {

  // MARK: - Stored Properties

  /// The title of the dropdown.
  let title: String

  /// A list of item to display in the menu.
  let items: [Item]

  /// The `KeyPath` leading to a `String` describing the item.
  let itemTitleKeyPath: KeyPath<Item, String>

  /// The selected item.
  @Binding var selection: Item?

  // MARK: - Body

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

// MARK: - Previews

struct RoundedBorderDropdownPreview: PreviewProvider {
  static var previews: some View {
    RoundedBorderDropdown(
      title: "Method",
      items: HTTPMethod.allCases,
      itemTitleKeyPath: \.rawValue,
      selection: .constant(HTTPMethod.get)
    )
    .previewLayout(.fixed(width: 160, height: 64))
  }
}

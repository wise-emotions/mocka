//
//  Mocka
//

import Cocoa
import MockaServer
import SwiftUI

/// A dropdown with rounded border.
struct RoundedBorderDropdown<Item: Hashable>: NSViewRepresentable {
  /// The coordinator object of the view.
  final class Coordinator {

    // MARK: - Stored Properties

    /// The selected item.
    private var selection: Binding<Item?>

    /// The list of item displayed in the menu.
    private let items: [Item]

    // MARK: - Init

    /// Creates an instance of `RoundedBorderDropdown`.
    /// - Parameters:
    ///   - selection: The `Binding` representing the item selected in the dropdown.
    ///   - items: The list of items to display in the dropdown menu.
    init(_ selection: Binding<Item?>, items: [Item]) {
      self.selection = selection
      self.items = items
    }

    // MARK: - Functions

    /// Handles the selection of the dropdown menu and updates the `selection` binding.
    /// - Parameter sender: The sender of the action.
    @objc
    func changedSelection(_ sender: NSPopUpButton) {
      let selectedIndex = sender.indexOfSelectedItem

      guard selectedIndex >= 0 && selectedIndex < items.count else {
        return
      }

      selection.wrappedValue = items[selectedIndex]
    }
  }

  // MARK: - Stored Properties

  /// The title of the dropdown.
  let title: String

  /// A list of item to display in the menu.
  let items: [Item]

  /// The `KeyPath` leading to a `String` describing the item.
  let itemTitleKeyPath: KeyPath<Item, String>

  /// The selected item.
  @Binding var selection: Item?

  /// Whether the control is enabled or not.
  let isEnabled: Bool

  // MARK: - NSViewRepresentable

  func makeNSView(context: Context) -> NSRoundedBorderDropdown {
    let button = NSRoundedBorderDropdown(frame: .zero, pullsDown: false)
    button.isEnabled = isEnabled
    button.addItems(withTitles: items.map { $0[keyPath: itemTitleKeyPath] })

    // Remove selection for initial state, if no selection is already made.
    let selectionIndex = items.firstIndex { $0[keyPath: itemTitleKeyPath] == selection?[keyPath: itemTitleKeyPath] }
    button.selectItem(at: selectionIndex ?? -1)

    button.setTitle(selection?[keyPath: itemTitleKeyPath] ?? title)

    button.target = context.coordinator
    button.action = #selector(context.coordinator.changedSelection)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 36).isActive = true
    return button
  }

  func updateNSView(_ nsView: NSRoundedBorderDropdown, context: Context) {
    nsView.setTitle(selection?[keyPath: itemTitleKeyPath] ?? title)
    nsView.isEnabled = isEnabled
  }

  func makeCoordinator() -> Coordinator {
    Coordinator($selection, items: items)
  }
}

// MARK: - Previews

struct RoundedBorderDropdownPreview: PreviewProvider {
  static var previews: some View {
    RoundedBorderDropdown(
      title: "Method",
      items: HTTPMethod.allCases,
      itemTitleKeyPath: \.rawValue,
      selection: .constant(HTTPMethod.get),
      isEnabled: true
    )
    .previewLayout(.fixed(width: 160, height: 64))
  }
}

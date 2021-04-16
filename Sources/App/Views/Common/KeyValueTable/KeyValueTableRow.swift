//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {

  // MARK: - Stored Properties

  /// The item to show inside the row.
   var item: KeyValueItem

  /// The row mode.
  /// Useful to disable user interaction on `read` mode.
  var mode: KeyValueTableViewModel.Mode

  /// The index of the item.
  var index: Int

  // MARK: - Body

  var body: some View {
    HStack {
      Group {
        switch mode {
        case .read:
          Text(item.key)
            .contextMenuCopy(item.key)

          Text(item.value)
            .contextMenuCopy(item.value)

        case .write:
          TextField(item.key, text: .constant(item.key))
            .contextMenuCopy(item.key)

          TextField(item.value, text: .constant(item.value))
            .contextMenuCopy(item.value)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
      .textFieldStyle(PlainTextFieldStyle())
      .foregroundColor(Color.latte)
    }
    .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
    .cornerRadius(5)
  }
}

// MARK: - Previews

struct KeyValueTableRowPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableRow(item: KeyValueItem(key: "Key", value: "Value"), mode: .read, index: 0)

    KeyValueTableRow(item: KeyValueItem(key: "", value: ""), mode: .read, index: 1)

    KeyValueTableRow(item: KeyValueItem(key: "Key", value: "Value"), mode: .write, index: 0)

    KeyValueTableRow(item: KeyValueItem(key: "", value: ""), mode: .write, index: 1)
  }
}

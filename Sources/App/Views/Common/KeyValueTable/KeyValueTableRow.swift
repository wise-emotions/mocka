//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {
  /// The item to show inside the row.
  @State var item: KeyValueItem

  /// The row mode.
  /// Useful to disable user interaction on `read` mode.
  @State var mode: KeyValueTableViewModel.Mode

  /// The index of the item.
  var index: Int

  var body: some View {
    HStack {
      Group {
        switch mode {
        case .read:
          Text(item.key)
            .contextMenu {
              Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.key, forType: .string)
              }) {
                Text("Copy Key")
              }
            }

          Text(item.value)
            .contextMenu {
              Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.value, forType: .string)
              }) {
                Text("Copy Value")
              }
            }

        case .write:
          TextField(item.key, text: $item.key)
            .contextMenu {
              Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.key, forType: .string)
              }) {
                Text("Copy Key")
              }
            }

          TextField(item.value, text: $item.value)
            .contextMenu {
              Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.value, forType: .string)
              }) {
                Text("Copy Value")
              }
            }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
      .textFieldStyle(PlainTextFieldStyle())
      .foregroundColor(Color.latte)
    }
    .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
    .cornerRadius(5)
  }
}

struct KeyValueTableRowPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableRow(item: KeyValueItem(key: "Key", value: "Value"), mode: .read, index: 0)

    KeyValueTableRow(item: KeyValueItem(key: "", value: ""), mode: .read, index: 1)

    KeyValueTableRow(item: KeyValueItem(key: "Key", value: "Value"), mode: .write, index: 0)

    KeyValueTableRow(item: KeyValueItem(key: "", value: ""), mode: .write, index: 1)
  }
}

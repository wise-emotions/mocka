//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {
  enum Kind {
    case textField

    case add
  }

  /// The item to show inside the row.
  @Binding var items: [KeyValueItem]

  @State var kind: Kind

  @State var mode: KeyValueTableViewModel.Mode
  
  /// The index of the item.
  var index: Int
    
  var body: some View {
    switch kind {
    case .textField:
      HStack {
        Group {
          TextField(items[index].key, text: $items[index].key)
            .disabled(mode == .read)

          TextField(items[index].value, text: $items[index].value)
            .disabled(mode == .read)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .textFieldStyle(PlainTextFieldStyle())
        .foregroundColor(Color.latte)
      }
      .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
      .cornerRadius(4)

    case .add:
      HStack {
        Spacer()

        SymbolButton(
          symbolName: .plusCircle,
          action: {
            items.append(KeyValueItem(key: "", value: ""))
          }
        )
      }
      .frame(minWidth: 20, maxWidth: .infinity)
    }
  }
}

struct KeyValueTableRowPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableRow(items: .constant([KeyValueItem(key: "Key", value: "Value")]), kind: .textField, mode: .read, index: 0)

    KeyValueTableRow(items: .constant([KeyValueItem(key: "", value: "")]), kind: .add, mode: .read, index: 1)

    KeyValueTableRow(items: .constant([KeyValueItem(key: "Key", value: "Value")]), kind: .textField, mode: .write, index: 0)

    KeyValueTableRow(items: .constant([KeyValueItem(key: "", value: "")]), kind: .add, mode: .write, index: 1)
  }
}

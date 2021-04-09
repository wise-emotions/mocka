//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {
  /// The item to show inside the row.
  @State var item: KeyValueItem

  @State var mode: KeyValueTableViewModel.Mode
  
  /// The index of the item.
  var index: Int
    
  var body: some View {
    HStack {
      Group {
        TextField(item.key, text: $item.key)
          .disabled(mode == .read)

        TextField(item.value, text: $item.value)
          .disabled(mode == .read)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
      .textFieldStyle(PlainTextFieldStyle())
      .foregroundColor(Color.latte)
    }
    .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
    .cornerRadius(4)
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

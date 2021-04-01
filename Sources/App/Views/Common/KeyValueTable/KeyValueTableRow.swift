//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {
  /// The item to show inside the row.
  var item: KeyValueItem

  /// The index of the item.
  var index: Int

  var body: some View {
    HStack {
      Group {
        TextField(item.key, text: .constant(item.key))
          .foregroundColor(Color.latte)

        TextField(item.value, text: .constant(item.value))
          .foregroundColor(Color.latte)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
      .textFieldStyle(PlainTextFieldStyle())
    }
    .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
    .cornerRadius(4)
  }
}

struct KeyValueTableRowPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableRow(item: KeyValueItem(key: "Test", value: "Multiline\nTest\nTest"), index: 0)
  }
}

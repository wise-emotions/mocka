//
//  Mocka
//

import SwiftUI

/// The row of the `KeyValueTable`.
struct KeyValueTableRow: View {
  /// The item to show inside the row.
  @Binding var items: [KeyValueItem]

  @State var isAddItemButtonVisible: Bool = false
  
  /// The index of the item.
  var index: Int
    
  var body: some View {
    HStack {
      if items.count - 1 == index {
        Button("Add") {
          items.append(KeyValueItem(key: "", value: ""))
        }
        .frame(width: 20, height: 20, alignment: .leading)

        Spacer()
      } else {
        Group {
          TextField(items[index].key, text: $items[index].key)
          
          TextField(items[index].value, text: $items[index].value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .textFieldStyle(PlainTextFieldStyle())
        .foregroundColor(Color.latte)
      }
    }
    .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
    .cornerRadius(4)
  }
}

struct KeyValueTableRowPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableRow(items: .constant([KeyValueItem(key: "Key", value: "Value")]), index: 0)
  }
}

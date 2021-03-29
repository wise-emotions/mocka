import SwiftUI

extension KeyValueTable {
  /// The row of the `KeyValueTable`.
  struct Row: View {
    /// The item to show inside the row.
    var item: KeyValueItem

    /// The index of the item.
    var index: Int

    var body: some View {
      HStack() {
        Group {
          TextField(item.key, text: .constant(item.key))
            .foregroundColor(Color.latte)

          TextField(item.value, text: .constant(item.value))
            .foregroundColor(Color.latte)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .textFieldStyle(PlainTextFieldStyle())
      }
      .frame(height: 28)
      .background(index.isMultiple(of: 2) ? Color.lungo : Color.doppio)
      .cornerRadius(4)
    }
  }
}

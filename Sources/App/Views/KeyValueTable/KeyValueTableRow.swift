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

          TextField(item.value, text: .constant(item.value))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .textFieldStyle(PlainTextFieldStyle())
      }
      .frame(height: 28)
      .background(index.isMultiple(of: 2) ? Color("SecondaryColor") : Color("PrimaryColor"))
      .cornerRadius(4)
    }
  }
}

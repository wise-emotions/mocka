import SwiftUI

extension KeyValueTable {
  /// The header of the `KeyValueTable`.
  struct Header: View {
    var body: some View {
      HStack {
        Text("Key")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.system(size: 13, weight: .semibold, design: .default))
          .foregroundColor(Color.latte)

        Text("Value")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.system(size: 13, weight: .semibold, design: .default))
          .foregroundColor(Color.latte)
      }
    }
  }
}

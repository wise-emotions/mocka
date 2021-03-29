import SwiftUI

extension KeyValueTable {
  /// The header of the `KeyValueTable`.
  struct Header: View {
    var body: some View {
      HStack {
        Text("Key")
          .frame(maxWidth: .infinity, alignment: .leading)

        Text("Value")
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

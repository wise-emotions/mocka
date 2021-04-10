//
//  Mocka
//

import SwiftUI

/// The header of the `KeyValueTable`.
struct KeyValueTableHeader: View {

  // MARK: - Body

  var body: some View {
    HStack {
      Group {
        Text("Key")

        Text("Value")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.system(size: 13, weight: .semibold, design: .default))
      .foregroundColor(.latte)
    }
  }
}

// MARK: - Previews

struct KeyValueTableHeaderPreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTableHeader()
  }
}

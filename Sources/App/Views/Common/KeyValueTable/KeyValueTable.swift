//
//  Mocka
//

import SwiftUI

/// The key-value table structure.
struct KeyValueTable: View {
  /// List of key-value items.
  var keyValueItems: [KeyValueItem]

  var body: some View {
    VStack {
      KeyValueTableHeader()

      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(Array(keyValueItems.enumerated()), id: \.offset) { index, item in
            KeyValueTableRow(item: item, index: index)
          }
        }
      }
    }
    .padding()
    .background(Color.doppio)
  }
}

struct KeyValueTablePreviews: PreviewProvider {
  static var previews: some View {
    KeyValueTable(keyValueItems: [
      KeyValueItem(key: "Test", value: "Test"),
      KeyValueItem(key: "Test2", value: "Test2"),
      KeyValueItem(key: "Test3", value: "Test3\nasd\nasaTest"),
    ])
  }
}

struct KeyValueTableLibraryContent: LibraryContentProvider {
  let keyValueItems: [KeyValueItem] = []

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(KeyValueTable(keyValueItems: keyValueItems))
  }
}

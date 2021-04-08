//
//  Mocka
//

import SwiftUI

/// The key-value table structure.
struct KeyValueTable: View {
  @ObservedObject var viewModel: KeyValueTableViewModel

  var body: some View {
    VStack {
      KeyValueTableHeader()

      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(viewModel.keyValueItems, id: \.self) { item in
            KeyValueTableRow(items: $viewModel.keyValueItems, index: viewModel.keyValueItems.firstIndex(where: { $0 == item })!
)
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
    KeyValueTable(
      viewModel: KeyValueTableViewModel(
        keyValueItems: [
          KeyValueItem(key: "Test", value: "Test"),
          KeyValueItem(key: "Test2", value: "Test2"),
          KeyValueItem(key: "Test3", value: "Test3\nasd\nasaTest"),
        ],
        shouldDisplayEmptyElement: true
      )
    )
  }
}

struct KeyValueTableLibraryContent: LibraryContentProvider {
  let keyValueItems: [KeyValueItem] = []
  let shouldDisplayEmptyElement: Bool = false
  
  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: keyValueItems, shouldDisplayEmptyElement: shouldDisplayEmptyElement)))
  }
}

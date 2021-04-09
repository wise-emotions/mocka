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
          ForEach(Array(viewModel.keyValueItems.enumerated()), id: \.offset) { index, item in
            KeyValueTableRow(
              item: item,
              mode: viewModel.mode,
              index: index
            )
          }
        }
      }

      if viewModel.mode == .write {
        HStack {
          Spacer()

          SymbolButton(
            symbolName: .plusCircle,
            action: {
              viewModel.keyValueItems.append(KeyValueItem(key: "", value: ""))
            }
          )
        }
        .frame(minWidth: 20, maxWidth: .infinity)
      }
    }
    .padding()
    .background(Color.doppio)
  }
}

struct KeyValueTablePreviews: PreviewProvider {
  static let rows = [KeyValueItem](
    repeating: KeyValueItem(
      key: "Hello",
      value: "World"
    ),
    count: 10
  )

  static var previews: some View {
    KeyValueTable(
      viewModel: KeyValueTableViewModel(
        keyValueItems: rows,
        mode: .write
      )
    )
  }
}

struct KeyValueTableLibraryContent: LibraryContentProvider {
  let keyValueItems: [KeyValueItem] = []
  let mode: KeyValueTableViewModel.Mode = .read
  
  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: keyValueItems, mode: mode)))
  }
}

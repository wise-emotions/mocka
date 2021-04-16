//
//  Mocka
//

import SwiftUI

/// The key-value table structure.
struct KeyValueTable: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @ObservedObject var viewModel: KeyValueTableViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      KeyValueTableHeader()

      ForEach(Array(viewModel.keyValueItems.wrappedValue.enumerated()), id: \.offset) { index, _ in
        KeyValueTableRow(
          item: viewModel.keyValueItems[index],
          mode: viewModel.mode,
          index: index
        )
      }
      .drawingGroup(on: viewModel.mode == .read)

      if viewModel.mode == .write {
        HStack {
          Spacer()

          SymbolButton(
            symbolName: .plusCircle,
            action: {
              viewModel.addNewRow()
            }
          )
        }
        .frame(minWidth: 20, maxWidth: .infinity)
      }
    }
    .padding()
    .background(Color.doppio)
    .cornerRadius(6)
  }
}

// MARK: - Previews

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
        keyValueItems: .constant(rows),
        mode: .write
      )
    )

    KeyValueTable(
      viewModel: KeyValueTableViewModel(
        keyValueItems: .constant(rows),
        mode: .read
      )
    )
  }
}

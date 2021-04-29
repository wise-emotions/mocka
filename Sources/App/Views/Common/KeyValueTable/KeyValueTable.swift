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
          item: Binding(
            get: { viewModel.keyValueItems.wrappedValue[index] },
            set: { viewModel.keyValueItems.wrappedValue[index] = $0 }
          ),
          mode: viewModel.mode,
          index: index
        )
      }
      .drawingGroup(on: viewModel.mode == .read)
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

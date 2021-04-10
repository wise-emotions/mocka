//
//  Mocka
//

import SwiftUI

/// This `View` should be used inside an `if` or `switch` to be shown when the root `View` has no available data.
struct EmptyState: View {

  // MARK: - Stored Properties

  /// The symbol to be shown on top of the `Text`.
  let symbol: SFSymbol

  /// The empty state message.
  let text: String

  // MARK: - Body

  var body: some View {
    VStack {
      Spacer()

      Image(systemName: symbol.rawValue)
        .resizable()
        .frame(width: 45, height: 45)
        .padding()
        .font(.body)
      Text(text)
        .font(.body)

      Spacer()
    }
  }
}

// MARK: - Previews

struct EmptyStatePreviews: PreviewProvider {
  static var previews: some View {
    EmptyState(symbol: .folder, text: "Empty Folder")
  }
}

//
//  Mocka
//

import SwiftUI

struct EmptyState: View {

  // MARK: - Stored Properties

  let symbol: SFSymbol

  let text: String

  // MARK: - Body

  var body: some View {
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

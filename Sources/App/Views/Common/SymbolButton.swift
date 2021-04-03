//
//  Mocka
//

import SwiftUI

/// A `Button` with plain style and SF Symbol as image.
struct SymbolButton: View {
  /// The name of the SF Symbol.
  var symbolName: SFSymbol

  /// The action to execute when the button is tapped.
  var action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: {
        Image(systemName: symbolName.rawValue)
          .font(.system(size: 16, weight: .regular, design: .default))
      }
    )
    .buttonStyle(PlainButtonStyle())
    .frame(width: 20, height: 20, alignment: .center)
  }
}

struct SymbolButtonPreviews: PreviewProvider {
  static var previews: some View {
    SymbolButton(symbolName: .playCircle, action: {})
  }
}

struct SymbolButtonLibraryContent: LibraryContentProvider {
  let symbolName: SFSymbol = .playCircle
  let action = {}

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(SymbolButton(symbolName: symbolName, action: action))
  }
}

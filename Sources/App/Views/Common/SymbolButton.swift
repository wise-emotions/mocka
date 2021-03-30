import SwiftUI

/// A `Button` with plain style and SF Symbol as image.
struct SymbolButton: View {
  /// The name of the SF Symbol.
  var symbolName: String

  /// The action to execute when the button is tapped.
  var action: () -> Void

  var body: some View {
    Button(action: action, label: {
      Image(systemName: symbolName)
        .font(.system(size: 16, weight: .regular, design: .default))
    })
    .buttonStyle(PlainButtonStyle())
  }
}

struct SymbolButtonPreviews: PreviewProvider {
  static var previews: some View {
    SymbolButton(symbolName: "play.circle", action: {})
  }
}

struct SymbolButtonLibraryContent: LibraryContentProvider {
  let symbolName = "play.circle"
  let action = {}

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(SymbolButton(symbolName: symbolName, action: action))
  }
}

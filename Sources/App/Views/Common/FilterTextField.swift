//
//  Mocka
//

import SwiftUI

/// An iOS-style `TextField`.
struct FilterTextField: View {
  /// The text to display and edit.
  @Binding var text: String

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Image(systemName: SFSymbol.magnifyingGlass.rawValue)
        .foregroundColor(Color(.tertiaryLabelColor))

      RoundedTextField(title: "Filter", text: $text)
        .textFieldStyle(PlainTextFieldStyle())
    }
    .background(Color.espresso)
    .cornerRadius(6)
  }
}

struct SearchTextFieldPreview: PreviewProvider {
  static var previews: some View {
    Group {
      FilterTextField(text: .constant(""))
        .previewDisplayName("SearchTextField without input")

      FilterTextField(text: .constant("transactions"))
        .previewDisplayName("SearchTextField with input")
    }
    .previewLayout(.fixed(width: 370, height: 48))
  }
}

struct SearchTextFieldLibraryContent: LibraryContentProvider {
  let text = Binding.constant("TextField")

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(FilterTextField(text: text))
  }
}

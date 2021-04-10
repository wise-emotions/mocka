//
//  Mocka
//

import SwiftUI

/// An iOS-style `TextField`.
struct FilterTextField: View {

  // MARK: - Store Properties

  /// The text to display and edit.
  @Binding var text: String

  // MARK: - Body

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 4) {
      Image(systemName: SFSymbol.magnifyingGlass.rawValue)
        .foregroundColor(Color(.tertiaryLabelColor))
        .padding(.leading, 8)

      RoundedTextField(title: "Filter", text: $text)
        .textFieldStyle(PlainTextFieldStyle())
    }
    .background(Color.espresso)
    .cornerRadius(6)
  }
}

// MARK: - Previews

struct FilterTextFieldPreview: PreviewProvider {
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

// MARK: - Library

struct FilterTextFieldLibraryContent: LibraryContentProvider {
  let text = Binding.constant("TextField")

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(FilterTextField(text: text))
  }
}

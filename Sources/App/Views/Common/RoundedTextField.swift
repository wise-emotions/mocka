//
//  Mocka
//

import SwiftUI

/// An iOS-style `TextField`.
struct RoundedTextField: View {
  /// The rounded text field title, aka placeholder.
  /// This is named `title` to keep the SwiftUI `TextField` style.
  let title: String

  /// The text to display and edit.
  @Binding var text: String

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      TextField(title, text: $text)
        .textFieldStyle(PlainTextFieldStyle())
    }
    .font(.system(size: 12))
    .padding(.leading, 6)
    .frame(height: 28)
    .background(Color.espresso)
    .cornerRadius(6)
  }
}

struct RoundedTextFieldPreview: PreviewProvider {
  static var previews: some View {
    Group {
      RoundedTextField(title: "Title", text: .constant(""))
        .previewDisplayName("RoundedTextField without input")

      RoundedTextField(title: "Title", text: .constant("Example"))
        .previewDisplayName("RoundedTextField with input")
    }
    .previewLayout(.fixed(width: 370, height: 48))
  }
}

struct RoundedTextFieldLibraryContent: LibraryContentProvider {
  let title = "Title"

  let text = Binding.constant("TextField")

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(RoundedTextField(title: title, text: text))
  }
}

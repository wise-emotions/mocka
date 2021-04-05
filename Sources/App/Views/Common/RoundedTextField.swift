//
//  Mocka
//

import SwiftUI

/// An iOS-style `TextField`.
struct RoundedTextField: View {
  /// The text to display and edit.
  @Binding var text: String

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(Color(.tertiaryLabelColor))

      TextField("Filter", text: $text)
        .textFieldStyle(PlainTextFieldStyle())
    }
    .font(.system(size: 12))
    .padding(.leading, 6)
    .frame(height: 28)
    .background(Color.espresso)
    .cornerRadius(6)
  }
}

// Gets rid of the selection border around the text field.
extension NSTextField {
  open override var focusRingType: NSFocusRingType {
    get { .none }
    set {}
  }
}

struct RoundedTextFieldPreview: PreviewProvider {
  static var previews: some View {
    Group {
      RoundedTextField(text: .constant(""))
        .previewDisplayName("RoundedTextField without input")

      RoundedTextField(text: .constant("transactions"))
        .previewDisplayName("RoundedTextField with input")
    }
    .previewLayout(.fixed(width: 370, height: 48))
  }
}

struct RoundedTextFieldLibraryContent: LibraryContentProvider {
  let text = Binding.constant("TextField")

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(RoundedTextField(text: text))
  }
}

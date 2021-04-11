//
//  Mocka
//

import SwiftUI

/// An iOS-style `TextField`.
struct RoundedTextField: View {

  // MARK: - Data Structure

  /// The height size of the `RoundedTextField`.
  enum Size {
    /// Height = 28
    case medium

    /// Height = 36
    case large
  }

  // MARK: - Stored Properties

  /// The rounded text field title, aka placeholder.
  /// This is named `title` to keep the SwiftUI `TextField` style.
  let title: String

  /// The `Size` of the textfield.
  /// This value influences the height of the view.
  var size: Size = .large

  /// The text to display and edit.
  @Binding var text: String

  // MARK: - Body

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      TextField(title, text: $text)
        .textFieldStyle(PlainTextFieldStyle())
    }
    .font(.system(size: 12))
    .padding(.leading, 6)
    .frame(height: size == .medium ? 28 : 36)
    .background(Color.espresso)
    .cornerRadius(6)
  }
}

// MARK: - Previews

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

// MARK: - Library

struct RoundedTextFieldLibraryContent: LibraryContentProvider {
  let title = "Title"

  let text = Binding.constant("TextField")

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(RoundedTextField(title: title, text: text))
  }
}

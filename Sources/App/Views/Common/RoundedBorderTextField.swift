//
//  Mocka
//

import MockaServer
import SwiftUI

/// A text field with rounded border.
struct RoundedBorderTextField: View {
  /// The title of the text field. This is displayed when no text has been entered in the field.
  let title: String

  /// The text entered in the field.
  @Binding var text: String

  var body: some View {
    TextField(title, text: $text)
      .textFieldStyle(PlainTextFieldStyle())
      .padding(.horizontal, 14)
      .padding(.vertical, 10)
      .overlay(borderOverlay)
  }

  /// An overlay that draws a rounded border on the view.
  private var borderOverlay: some View {
    RoundedRectangle(cornerRadius: 6, style: .continuous)
      .stroke(Color.americano, lineWidth: 1)
  }
}

struct RoundedBorderTextFieldPreview: PreviewProvider {
  static var previews: some View {
    Group {
      RoundedBorderTextField(title: "Path", text: .constant(""))
        .previewDisplayName("RoundedBorderTextField without input")

      RoundedBorderTextField(title: "Path", text: .constant("/Developer"))
        .previewDisplayName("RoundedBorderTextField with input")
    }
    .previewLayout(.fixed(width: 370, height: 48))
  }
}

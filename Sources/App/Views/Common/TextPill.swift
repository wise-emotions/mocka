//
// Mocka
//

import SwiftUI

/// A pill containing an uppercased text.
struct TextPill: View {

  // MARK: - Stored Properties

  /// The `text` inside the `TextPill`.
  let text: String

  // MARK: - Body

  var body: some View {
    Text(text.uppercased())
      .font(.system(size: 12, weight: .bold))
      .padding(8)
      .frame(height: 20)
      .background(Color.ristretto)
      .cornerRadius(100)
      .foregroundColor(.latte)
  }
}

// MARK: - Previews

struct TextPillViewPreviews: PreviewProvider {
  static var previews: some View {
    TextPill(text: "delete")
  }
}

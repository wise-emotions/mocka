//
// Mocka
//

import SwiftUI

/// A pill containing an uppercased text.
struct TextPillView: View {
  
  // MARK: - Stored Properties
  
  /// The `text` inside the `TextPillView`.
  let text: String
  
  // MARK: - Body
  
  var body: some View {
    Text(text.uppercased())
      .font(.system(size: 12, weight: .bold))
      .padding(8)
      .frame(height: 20)
      .background(Color.ristretto)
      .cornerRadius(100)
      .foregroundColor(Color.latte)
  }
}

struct RequestTypePillView_Previews: PreviewProvider {
  static var previews: some View {
    TextPillView(text: "delete")
  }
}

import SwiftUI

/// A pill containing an uppercased text.
struct TextPillView: View {
  
  // MARK: - Stored Properties
  
  /// The `text` inside the `TextPillView`.
  let text: String
  
  // MARK: - Body
  
  var body: some View {
    Text(text.uppercased())
      .font(.system(size: 13, weight: .bold))
      .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
      .background(Color.secondary)
      .cornerRadius(10)
  }
}

struct RequestTypePillView_Previews: PreviewProvider {
  static var previews: some View {
    TextPillView(text: "delete")
  }
}

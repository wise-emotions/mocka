import SwiftUI

struct TextPillView: View {
  let text: String

  var body: some View {
    Text(text)
      .font(.system(size: 13, weight: .bold))
      .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
      .background(Color.secondary)
      .cornerRadius(10)
  }
}

struct RequestTypePillView_Previews: PreviewProvider {
  static var previews: some View {
    TextPillView(text: "DELETE")
  }
}

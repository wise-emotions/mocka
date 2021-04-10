import SwiftUI

/// A Section with a `title` and a `content` view as body.
struct RequestInfoViewSectionView<ContentView: View>: View {
  /// The `title` of the Section.
  let title: String

  /// The `content` of the Section.
  let content: () -> ContentView

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 13, weight: .semibold, design: .default))
        .foregroundColor(Color.latte)

      content()
        .background(Color.doppio)
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(8)
    }
  }
}

// MARK: - Preview

struct RequestInfoViewSectionViewPreviews: PreviewProvider {
  static var previews: some View {
    RequestInfoViewSectionView(title: "URL") {
      TextField("/api/v1/transactions/*/pippo", text: .constant("/api/v1/transactions/*/pippo"))
        .padding()
        .textFieldStyle(PlainTextFieldStyle())
        .font(.system(size: 13, weight: .regular, design: .default))
        .foregroundColor(Color.latte)
    }
  }
}
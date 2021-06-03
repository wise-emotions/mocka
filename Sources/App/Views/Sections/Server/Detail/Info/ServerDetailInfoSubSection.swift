//
//  Mocka
//

import MockaServer
import SwiftUI

/// A Section with a `title` and a `content` view as body.
struct ServerDetailInfoSubSection<ContentView: View>: View {

  // MARK: - Stored Properties

  /// The `title` of the Section.
  let title: String

  /// The `content` of the Section.
  let content: () -> ContentView

  // MARK: - Body

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 13, weight: .semibold, design: .default))
        .foregroundColor(.latte)

      content()
        .background(Color.doppio)
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(8)
    }
  }
}

// MARK: - Preview

struct ServerDetailInfoSubSectionViewPreviews: PreviewProvider {
  static var previews: some View {
    ServerDetailInfoSubSection(title: "URL") {
      TextField(NetworkExchange.mock.request.uri.string, text: .constant(NetworkExchange.mock.request.uri.string))
        .padding()
        .textFieldStyle(PlainTextFieldStyle())
        .font(.system(size: 13, weight: .regular, design: .default))
        .foregroundColor(Color.latte)
    }
  }
}

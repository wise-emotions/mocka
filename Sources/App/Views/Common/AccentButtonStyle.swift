//
//  Mocka
//

import SwiftUI

/// This button adheres to `ButtonStyle` protocol set the button color to the `accentColor` selected by the user.
struct AccentButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(configuration.isPressed ? Color.accentColor : Color.latte)
      .background(configuration.isPressed ? Color.latte : Color.accentColor)
      .cornerRadius(6.0)
  }
}

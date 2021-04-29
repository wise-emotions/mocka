//
//  Mocka
//

import AppKit
import SwiftUI

/// This button adheres to `ButtonStyle` protocol set the button color to the `accentColor` selected by the user.
struct AccentButtonStyle: ButtonStyle {
  /// Whether or not the button is enabled.
  let isEnabled: Bool

  /// Returns an instance of `AccentButtonStyle`
  /// - Parameter isEnabled: Whether or not the button is enabled.
  init(isEnabled: Bool = true) {
    self.isEnabled = isEnabled
  }

  /// Computes the background color based of its state.
  /// - Parameter isPressed: Whether or not the button is pressed.
  /// - Returns: A `Color`.
  func backgroundColor(isPressed: Bool) -> Color {
    guard isEnabled else {
      return Color.accentColor.opacity(0.3)
    }

    return isPressed ? Color.latte : Color.accentColor
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    return configuration.label
      .foregroundColor(configuration.isPressed ? Color.accentColor : .milk)
      .background(backgroundColor(isPressed: configuration.isPressed))
      .cornerRadius(6.0)
  }
}

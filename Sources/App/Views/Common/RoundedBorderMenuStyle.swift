//
//  Mocka
//

import SwiftUI

/// A menu style that displays a button with rounded border that toggles the display of the menu’s contents when pressed.
struct RoundedBorderMenuStyle: MenuStyle {
  func makeBody(configuration: Configuration) -> some View {
    Menu(configuration)
      .menuStyle(BorderlessButtonMenuStyle())
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

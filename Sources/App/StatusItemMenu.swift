//
//  Mocka
//

import SwiftUI

struct StatusItemMenu: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var didTapItem: Interaction?

  var body: some View {
    VStack(alignment: .leading) {
      Button("Start Server") {
        print("Start Server")
        didTapItem?()
      }
      .disabled(appEnvironment.isServerRunning)
      .buttonStyle(MenuBarButton())

      Button("Stop Server") {
        print("Stop Server")
        didTapItem?()
      }
      .disabled(appEnvironment.isServerRunning.inverted())
      .buttonStyle(MenuBarButton())

      Button("Restart Server") {
        print("Restart Server")
        didTapItem?()
      }
      .disabled(appEnvironment.isServerRunning.inverted())
      .buttonStyle(MenuBarButton())
    }
  }
}

struct MenuBarButton: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled: Bool
  @State var isHover = false

  var foregroundColor: Color {
    isEnabled ? .latte : .americano
  }

  var backgroundColor: Color {
    isEnabled && isHover ? .americano : .clear
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding([.leading, .trailing], 5)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(backgroundColor)
      .cornerRadius(3)
      .padding([.leading, .trailing], 5)
      .foregroundColor(foregroundColor)
      .onHover(perform: { hovering in
        isHover = hovering
      })
  }
}

struct StatusItemMenu_Previews: PreviewProvider {
  static var previews: some View {
    StatusItemMenu()
      .previewLayout(.fixed(width: 200, height: 200))
      .environmentObject(AppEnvironment())
  }
}

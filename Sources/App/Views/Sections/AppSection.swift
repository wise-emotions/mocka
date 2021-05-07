//
//  Mocka
//

import SwiftUI

/// This is the common app section used to show all the other sections.
/// This `View` is responsible for rendering the right section based on the
/// `appEnvironment.selectedSection` property.
struct AppSection: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  // MARK: - Body

  var body: some View {
    switch appEnvironment.selectedSection {
    case .server:
      ServerSection()

    case .editor:
      EditorSection()
        .environmentObject(EditorEnvironment())

    case .console:
      ConsoleSection()
    }
  }
}

// MARK: - Previews

struct AppSectionPreview: PreviewProvider {
  static var previews: some View {
    AppSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

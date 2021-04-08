//
//  Mocka
//

import Foundation
import SwiftUI

/// This is the common app section used to show all the other sections.
/// This `View` is responsible for rendering the right section based on the
/// `appEnvironment.selectedSection` property.
struct AppSection: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    switch appEnvironment.selectedSection {
    case .server:
      KeyValueTable(
        viewModel: KeyValueTableViewModel(
          keyValueItems: [
            KeyValueItem(key: "Test", value: "Test"),
            KeyValueItem(key: "Test2", value: "Test2"),
            KeyValueItem(key: "Test3", value: "Test3\nasd\nasaTest"),
          ],
          shouldDisplayEmptyElement: true
        )
      )
    
    case .editor:
      ServerSection()

    case .console:
      ServerSection()
    }
  }
}

struct AppSectionPreview: PreviewProvider {
  static var previews: some View {
    AppSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

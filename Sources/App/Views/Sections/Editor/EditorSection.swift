//
//  Mocka
//

import MockaServer
import SwiftUI

/// This is the server section of the app.
/// It shows the list of the `NetworkExchange`s and its details.
struct EditorSection: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The editor environment object.
  @EnvironmentObject var editorEnvironment: EditorEnvironment

  // MARK: - Body

  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)

      SourceTree(viewModel: SourceTreeViewModel(editorEnvironment: editorEnvironment))

      EditorDetail(viewModel: EditorDetailViewModel(sourceTree: editorEnvironment.sourceTree))
    }
    .background(Color.doppio)
  }
}

// MARK: - Previews

struct EditorSectionPreview: PreviewProvider {
  static var previews: some View {
    EditorSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

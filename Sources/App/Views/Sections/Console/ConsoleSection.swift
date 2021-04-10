//
//  Mocka
//

import MockaServer
import SwiftUI

/// This is the console section of the app.
/// It shows the list of server logs.
struct ConsoleSection: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  // MARK: - Body

  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)

      ConsoleList(viewModel: ConsoleListViewModel(consoleLogsPublisher: appEnvironment.server.consoleLogsPublisher))
    }
    .background(Color.doppio)
  }
}

// MARK: - Previews

struct ConsoleSectionPreviews: PreviewProvider {
  static var previews: some View {
    ConsoleSection()
      .environmentObject(AppEnvironment())
  }
}

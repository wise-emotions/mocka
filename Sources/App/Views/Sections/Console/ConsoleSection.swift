//
//  Mocka
//

import MockaServer
import SwiftUI

/// This is the console section of the app.
/// It shows the list of server logs.
struct ConsoleSection: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)

      LogEventList(viewModel: LogEventListViewModel(consoleLogsPublisher: appEnvironment.server.consoleLogsPublisher))
    }
    .background(Color.doppio)
  }
}

struct ConsoleSectionPreviews: PreviewProvider {
  static var previews: some View {
    ConsoleSection()
      .environmentObject(AppEnvironment())
  }
}

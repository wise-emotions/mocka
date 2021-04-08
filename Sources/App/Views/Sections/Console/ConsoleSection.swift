//
//  Mocka
//

import MockaServer
import SwiftUI

struct ConsoleSection: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment
  
  var body: some View {
    NavigationView {
      Sidebar(selectedSection: $appEnvironment.selectedSection)
      
      LogEventList(viewModel: ConsoleSectionViewModel(consoleLogsPublisher: appEnvironment.server.consoleLogsPublisher))
    }
    .background(Color.doppio)
  }
}

struct ConsoleSection_Previews: PreviewProvider {
  static var previews: some View {
    ConsoleSection()
      .environmentObject(AppEnvironment())
  }
}

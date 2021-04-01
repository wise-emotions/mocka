//
//  Mocka
//

import Server
import SwiftUI

struct ConsoleSection: View {  
  /// The `WindowManager` environment object.
  @EnvironmentObject var windowManager: WindowManager
  
  @StateObject var viewModel: ConsoleSectionViewModel
  
  var body: some View {
    HStack {
      VStack(spacing: 0) {
        ServerToolbar(isServerRunning: .constant(false))
          .frame(width: 410, alignment: .center)
        LogEventListView(
          logEvents: Binding<[LogEvent]>(
            get: { viewModel.filteredLogEvents },
            set: { _,_ in }
          )
        )
      }
    }
    .background(Color.doppio)
    .padding(.top, windowManager.titleBarHeight(to: .remove))
  }
}

struct ConsoleSection_Previews: PreviewProvider {
  static var previews: some View {
    ConsoleSection(viewModel: ConsoleSectionViewModel(consoleLogsPublisher: Server().consoleLogsPublisher))
  }
}

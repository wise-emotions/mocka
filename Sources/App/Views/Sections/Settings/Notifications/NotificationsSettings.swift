//
//  Mocka
//

import SwiftUI

/// The notifications settings view.
struct NotificationsSettings: View {
  /// The `ViewModel` for the view.
  @State var viewModel: NotificationsSettingsViewModel
  
  var body: some View {
    VStack {
      Toggle("Notifiche per request fallite", isOn: $viewModel.areInAppNotificationEnabled)
        .toggleStyle(CheckboxToggleStyle())
    }
  }
}

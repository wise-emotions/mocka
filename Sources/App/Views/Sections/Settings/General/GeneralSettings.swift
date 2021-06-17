//
//  Mocka
//

import SwiftUI

struct GeneralSettings: View {
  @ObservedObject var viewModel = GeneralSettingsViewModel()

  var body: some View {
    VStack {
      Toggle("Launch at login", isOn: $viewModel.shouldLaunchAtLogin)
    }
    .padding()
    .frame(width: 300)
  }
}

import Combine
import ServiceManagement

final class GeneralSettingsViewModel: ObservableObject {
  static let launchHelperBundleIdentifier = "com.wisemotions.MockaLaunchHelper"

  @Published var shouldLaunchAtLogin: Bool

  private var subscriptions = Set<AnyCancellable>()

  init() {
    shouldLaunchAtLogin = NSWorkspace.shared.runningApplications.contains {
      $0.bundleIdentifier == Self.launchHelperBundleIdentifier
    }

    $shouldLaunchAtLogin.sink {
      SMLoginItemSetEnabled(Self.launchHelperBundleIdentifier as CFString, $0)
    }
    .store(in: &subscriptions)
  }
}

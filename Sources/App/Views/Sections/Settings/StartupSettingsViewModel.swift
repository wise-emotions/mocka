//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The view model of the `StartupSettings`.
final class StartupSettingsViewModel: ObservableObject {
  /// The workspace path to be set.
  @Published var workspacePath: String = ""

  /// Handle the workspace path error.
  @Published var workspacePathError: MockaError? = nil

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented: Bool = false
}

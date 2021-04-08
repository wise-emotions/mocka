//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The view model of the `StartupSettings`.
final class StartupSettingsViewModel: ObservableObject {
  /// The workspace path to be set.
  ///
  /// It isn't a nullable property because it's used
  /// inside a `Binding` object that needs a `String`.
  @Published var workspacePath: String = ""

  /// Handle the workspace path error.
  @Published var workspacePathError: MockaError? = nil

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented: Bool = false

  /// Check the validity of the given path.
  /// - Parameter path: If valid, returns the path.
  func checkURL(_ path: String) {
    do {
      try Logic.WorkspacePath.check(URL(fileURLWithPath: path))
      workspacePath = path
      workspacePathError = nil
    } catch {
      workspacePath = path

      guard let workspacePathError = error as? MockaError else {
        return
      }

      self.workspacePathError = workspacePathError
    }
  }

  /// The `fileImporter` completion function.
  /// This function is called once the user selected a folder.
  /// It sets the path in case of success, and the error in case of error.
  /// - Parameter result: The `Result` object from the `fileImporter` completion.
  func selectFolder(with result: Result<[URL], Error>) {
    guard let workspacePath = Logic.Startup.selectFolder(from: result) else {
      workspacePathError = .missingWorkspacePathValue
      return
    }

    self.workspacePath = workspacePath
    workspacePathError = nil
  }

  /// Confirms the selected startup settings
  /// by creating the configuration file in the right path.
  /// - Parameters:
  ///   - appEnvironment: The `AppEnvironment` instance.
  ///   - presentationMode: The `View` `PresentationMode`.
  func confirmSettings(for appEnvironment: AppEnvironment, with presentationMode: Binding<PresentationMode>) {
    let workspaceURL = URL(fileURLWithPath: workspacePath)

    do {
      appEnvironment.workspaceURL = workspaceURL

      try Logic.WorkspacePath.check(workspaceURL)
      try Logic.Startup.createConfiguration()

      presentationMode.wrappedValue.dismiss()
    } catch {
      guard let workspacePathError = error as? MockaError else {
        return
      }

      self.workspacePathError = workspacePathError
    }
  }
}

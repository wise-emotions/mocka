//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The ViewModel of the `ServerSettings`.
final class ServerSettingsViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// Specify if the `StartupSettings` has been opened from the main app settings `Settings`.
  let isShownFromSettings: Bool

  /// The workspace path to be set.
  ///
  /// It's important to keep it nullable because by default
  /// it will use the observed `workspaceURL` property.
  @Published var workspacePath: String = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL)?.path ?? "" {
    didSet {
      checkURL(workspacePath)
    }
  }

  /// The hostname of the server for the connection.
  ///
  /// It isn't a nullable property because it's used
  /// inside a `Binding` object that needs a `String`.
  @Published var hostname: String = Logic.Settings.serverConfiguration?.hostname ?? "127.0.0.1" {
    didSet {
      let filtered = hostname.filter { $0.isNumber || $0 == "." }

      if hostname != filtered {
        hostname = filtered
      }
    }
  }

  /// The port of the server for the connection.
  /// If the value passed cannot be casted as an Integer, this will default to `8080`.
  ///
  /// It isn't an Integer, not it is nullable because it's used
  /// inside a `Binding` object that needs a `String`.
  @Published var port: String = String(Logic.Settings.serverConfiguration?.port ?? 8080) {
    didSet {
      let filtered = port.filter { $0.isNumber }

      if port != filtered {
        port = filtered
      }
    }
  }

  /// Handle the workspace path error.
  @Published var workspacePathError: MockaError? = nil

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented: Bool = false

  /// The value of the workspace path.
  /// When this value is updated, the value in the user defaults is updated as well.
  @AppStorage(UserDefaultKey.workspaceURL) private var workspaceURL: URL?

  // MARK: - Init

  /// Creates the `ServerSettingsViewModel`.
  /// - Parameter isShownFromSettings: Specify if the `View` is opened by the `Settings` window or not.
  init(isShownFromSettings: Bool) {
    self.isShownFromSettings = isShownFromSettings
  }

  // MARK: - Functions

  /// Check the validity of the given path.
  /// - Parameter path: If valid, returns the path.
  func checkURL(_ path: String) {
    do {
      try Logic.WorkspacePath.isFolder(URL(fileURLWithPath: path))

      workspacePathError = nil
    } catch {
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
    guard let workspacePath = Logic.Settings.selectFolder(from: result) else {
      workspacePathError = .missingWorkspacePathValue
      return
    }

    self.workspacePath = workspacePath
    workspacePathError = nil
  }

  /// Confirms the selected startup settings
  /// by creating the configuration file in the right path.
  /// In case of error the `workspaceURL` returns to `nil`.
  /// - Parameter presentationMode: The `View` `PresentationMode`.
  func confirmSettings(with presentationMode: Binding<PresentationMode>) {
    let workspaceURL = URL(fileURLWithPath: workspacePath)

    do {
      self.workspaceURL = workspaceURL

      try Logic.WorkspacePath.isFolder(workspaceURL)
      try Logic.Settings.updateServerConfigurationFile(
        ServerConnectionConfiguration(hostname: hostname, port: Int(port) ?? 8080)
      )

      if isShownFromSettings {
        // Currently we can't close a window from SwiftUI.
        NSApplication.shared.keyWindow?.close()
      } else {
        // This is how the dismiss in handled in SwiftUI.
        presentationMode.wrappedValue.dismiss()
      }
    } catch {
      guard let workspacePathError = error as? MockaError else {
        return
      }

      self.workspaceURL = nil
      self.workspacePathError = workspacePathError
    }
  }
}
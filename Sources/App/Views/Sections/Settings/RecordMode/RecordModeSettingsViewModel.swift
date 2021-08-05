//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The ViewModel of the `ServerSettings`.
final class RecordModeSettingsViewModel: ObservableObject {

  // MARK: - Stored Properties
  
  var appEnvironment: AppEnvironment
  
  /// The folder where the record mode requests will be saved.
  @Published var recordingPath: String {
    didSet {
      // When the user modifies the `recordingPath` we must remove any `recordingPathError` if present.
      // This is needed in order to remove the red `RoundedRectangle` around the `RoundedTextField` of the "record mode folder" entry.
      // In this way the red `RoundedRectangle` will be hidden while the user is editing the `recordingPath` in the entry.
      recordingPathError = nil
    }
  }

  /// The base URL that will be passed to the middleware for the record mode to start.
  @Published var middlewareBaseURL: String

  /// Handle the workspace path error.
  @Published var recordingPathError: MockaError? = nil

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented: Bool = false
  
  /// Whether or not the overwrite response checkbox is enabled.
  @Published var shouldOverwriteResponse: Bool = true

  // MARK: - Init

  /// Creates a new instance with the app environment.
  /// - Parameter appEnvironment: The app environment.
  init(appEnvironment: AppEnvironment) {
    self.appEnvironment = appEnvironment
    
    middlewareBaseURL = appEnvironment.middlewareBaseURL?.absoluteString ?? ""
    recordingPath = appEnvironment.selectedRecordingPath?.path ?? ""
  }
  
  // MARK: - Functions

  /// The `fileImporter` completion function.
  /// This function is called once the user selected a folder.
  /// It sets the path in case of success, and the error in case of error.
  /// - Parameter result: The `Result` object from the `fileImporter` completion.
  func selectFolder(with result: Result<[URL], Error>) {
    guard let recordingFolder = Logic.Settings.selectFolder(from: result) else {
      recordingPathError = .missingWorkspacePathValue
      return
    }

    self.recordingPath = recordingFolder
    recordingPathError = nil
  }
  
  /// Confirms the selected startup settings
  /// by creating the configuration file in the right path.
  /// In case of error the `workspaceURL` returns to `nil`.
  func confirmSettingsAndStartRecording() {
    let recordingURL = URL(fileURLWithPath: recordingPath)
    let middlewareURL = URL(string: middlewareBaseURL)
    
    do {
      try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: recordingURL)
      
      appEnvironment.middlewareBaseURL = middlewareURL
      appEnvironment.selectedRecordingPath = recordingURL
      appEnvironment.isRecordModeSettingsPresented.toggle()

      guard let middlewareConfiguration = appEnvironment.middlewareConfiguration, appEnvironment.isServerRecording.isFalse else {
        return
      }
      
      try? appEnvironment.server.startRecording(with: middlewareConfiguration)
      
      appEnvironment.isServerRunning.toggle()
      appEnvironment.isServerRecording.toggle()
    } catch {
      guard let recordingPathError = error as? MockaError else {
        return
      }

      self.recordingPathError = recordingPathError
    }
  }
}

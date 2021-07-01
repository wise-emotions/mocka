//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The ViewModel of the `ServerSettings`.
final class RecordModeSettingsViewModel: ObservableObject {

  // MARK: - Stored Properties
  
  /// The folder where the record mode requests will be saved.
  @Published var recordingPath: String = "" {
    didSet {
      // When the user modifies the `recordingPath` we must remove any `recordingPathError` if present.
      // This is needed in order to remove the red `RoundedRectangle` around the `RoundedTextField` of the "record mode folder" entry.
      // In this way the red `RoundedRectangle` will be hidden while the user is editing the `recordingPath` in the entry.
      recordingPathError = nil
    }
  }

  /// The base URL that will be passed to the middleware for the record mode to start.
  @Published var middlewareBaseURL: String = ""

  /// Handle the workspace path error.
  @Published var recordingPathError: MockaError? = nil

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented: Bool = false
  
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
  /// - Parameter presentationMode: The `View` `PresentationMode`.
  func confirmSettings(with appEnvironment: AppEnvironment) {
    let recordingURL = URL(fileURLWithPath: recordingPath)
    let middlewareURL = URL(string: middlewareBaseURL)
    
    do {
      try Logic.WorkspacePath.checkURLAndCreateFolderIfNeeded(at: recordingURL)
      
      appEnvironment.middlewareBaseURL = middlewareURL
      appEnvironment.selectedRecordingPath = recordingURL
      
      NSApplication.shared.keyWindow?.close()
    } catch {
      guard let recordingPathError = error as? MockaError else {
        return
      }

      self.recordingPathError = recordingPathError
    }
  }
}

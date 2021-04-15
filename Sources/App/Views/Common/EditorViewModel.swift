//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The ViewModel of the `Editor`.
class EditorViewModel: ObservableObject {

  // MARK: - Data Structure

  /// The editor mode.
  /// Use `write` mode to allow the user edit the `TextEditor`.
  /// Use `read` mode to disable user interactions.
  enum Mode {
    /// The write mode that allows the user to edit the `TextEditor`.
    case write

    /// The read mode that disable user interactions.
    case read
  }

  // MARK: - Stored Properties

  /// The text of the editor.
  @Published var text: String 

  /// Wether the user is dragging a file over the editor.
  @Published var isDraggingOver = false

  /// Whether the `fileImporter` is presented.
  @Published var fileImporterIsPresented = false

  /// The table mode. In `write` mode an add button will be added.
  @Published var mode: Mode

  // MARK: - Computed Properties

  /// Whether or not the input is a valid json.
  var isValidJSON: Bool {
    text.prettyPrintedJSON != nil
  }

  /// The color of the border of the text editor.
  var borderColor: Color {
    guard isDraggingOver.isFalse else {
      return Color.irish
    }

    guard text.isNotEmpty else {
      return .clear
    }

    return isValidJSON ? .clear : Color.redEye
  }

  /// Whether or not the error label is visible.
  var isErrorLabelVisible: Bool {
    isValidJSON.isFalse
  }

  init(text: String = "", mode: Mode = .read) {
    self.text = text
    self.mode = mode
  }

  // MARK: - Functions

  /// Imports a file from the `fileImporter`.
  /// - Parameter result: The `URL` selected by the `fileImporter`.
  /// - Returns: Returns the selected path as `String`.
  func importFile(from result: Result<[URL], Error>) {
    guard
      let selectedFileURL = try? result.get().first,
      selectedFileURL.startAccessingSecurityScopedResource(),
      let input = try? Data(contentsOf: selectedFileURL).prettyPrintedJSON
    else {
      return
    }

    text = input
    selectedFileURL.stopAccessingSecurityScopedResource()
  }

  /// Pretty print the json.
  func prettyPrintJSON() {
    guard let prettyPrintedJSON = text.prettyPrintedJSON else {
      return
    }

    text = prettyPrintedJSON
  }

  /// This function handles the `onDrop` event.
  /// - Parameter providers: The array of `NSItemProvider` for conveying
  ///                        data or a file between processes during drag and drop.
  /// - Returns: Returns `true` if is a valid file, otherwise `false`.
  func handleOnDrop(providers: [NSItemProvider]) -> Bool {
    guard let provider = providers.first else {
      return false
    }

    provider.loadDataRepresentation(
      forTypeIdentifier: UTType.fileURL.identifier,
      completionHandler: { urlData, error in
        DispatchQueue.main.async { [weak self] in
          guard let data = urlData, let json = data.prettyPrintedJSON else {
            return
          }

          self?.text = json
        }
      }
    )

    return true
  }
}

//
//  Mocka
//

import SwiftUI

/// The ViewModel of the `Editor`.
class EditorViewModel: ObservableObject {
  @Published var textInput: String = ""
  @Published var isDraggingOver = false
  @Published var isPresented = false
  
  // MARK: - Computed Properties
  
  /// Whether or not the input is a valid json.
  var isValidJSON: Bool {
    textInput.asPrettyPrintedJSON != nil
  }
  
  /// The color of the border of the text editor.
  var borderColor: Color {
    guard !isDraggingOver else {
      return Color.irish
    }
    
    guard !textInput.isEmpty else {
      return .clear
    }
    
    return isValidJSON ? .clear : Color.redEye
  }
  
  /// Whether or not the error label is visible.
  var isErrorLabelVisible: Bool {
    !isValidJSON
  }
  
  // MARK: - Functions
  
  /// Imports a JSON from the fileImporter.
  /// - Parameter result: The `URL` selected by the `fileImporter`.
  /// - Returns: Returns the selected path as `String`.
  func importJSON(from result: Result<[URL], Error>) {
    guard
      let selectedFileURL = try? result.get().first,
      selectedFileURL.startAccessingSecurityScopedResource(),
      let jsonInput = selectedFileURL.prettyPrintedJSON
    else {
      return
    }
    
    textInput = jsonInput
    selectedFileURL.stopAccessingSecurityScopedResource()
  }

  /// Pretty print the json.
  func processJSON() {
    guard let validJSON = textInput.asPrettyPrintedJSON else {
      return
    }
    
    textInput = validJSON
  }
  
  func handleOnDrop(providers: [NSItemProvider]) -> Bool {
    guard let provider = providers.first else {
      return false
    }
    
    provider.loadDataRepresentation(
      forTypeIdentifier: "public.file-url",
      completionHandler: { urlData, error in
        DispatchQueue.main.async { [weak self] in
          guard
            let data = urlData,
            let json = (NSURL(absoluteURLWithDataRepresentation: data, relativeTo: nil) as URL).prettyPrintedJSON
          else {
            return
          }

          self?.textInput = json
        }
      }
    )
    
    return true
  }
}

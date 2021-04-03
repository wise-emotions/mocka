//
//  Mocka
//

import SwiftUI

class AddAPIViewModel: ObservableObject {
  @Published var textInput: String = ""
  @Published var isDraggingOver = false
  @Published var isPresented = false
  
  // MARK: - Computed Properties
  
  var isValidJSON: Bool {
    textInput.asPrettyPrintedJSON != nil
  }
  
  var borderColor: Color {
    guard !isDraggingOver else {
      return .green
    }
    
    guard !textInput.isEmpty else {
      return .clear
    }
    
    return isValidJSON ? .clear : .red
  }
  
  var isErrorLabelVisible: Bool {
    !isValidJSON
  }
  
  // MARK: - Functions
  
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
    
    provider.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (urlData, error) in
      DispatchQueue.main.async { [weak self] in
        guard
          let data = urlData,
          let json = (NSURL(absoluteURLWithDataRepresentation: data, relativeTo: nil) as URL).prettyPrintedJSON
        else {
          return
        }
        
        self?.textInput = json
      }
    })
    
    return true
  }
}

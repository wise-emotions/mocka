//
//  Mocka
//

import SwiftUI

class AddAPIViewModel: ObservableObject {
  @Published var textInput: String = ""
  
  // MARK: - Computed Properties
  
  var isValidJSON: Bool {
    textInput.asPrettyPrintedJSON != nil
  }
  
  var borderColor: Color {
    guard !textInput.isEmpty else {
      return .clear
    }
    
    return isValidJSON ? .clear : .red
  }
  
  var isErrorLabelVisible: Bool {
    !isValidJSON
  }
  
  // MARK: - Functions
  
  func importJSON(from fileURL: URL?) {
    guard
      let url = fileURL,
      let json = url.prettyPrintedJSON
    else {
      return
    }
    
    textInput = json
  }
  
  func processJSON() {
    guard let validJSON = textInput.asPrettyPrintedJSON else {
      return
    }
    
    textInput = validJSON
  }
}

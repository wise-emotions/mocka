//
//  Mocka
//

import SwiftUI

struct AddAPIView: View {
  @ObservedObject var viewModel = AddAPIViewModel()
  @State private var dragOver = false
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button("Importa") {
          let panel = NSOpenPanel()
          panel.allowsMultipleSelection = false
          panel.canChooseDirectories = false
          panel.allowedFileTypes = ["json"]
          if panel.runModal() == .OK {
            viewModel.importJSON(from: panel.url)
          }
        }
      }
      
      TextEditor(text: $viewModel.textInput)
        .font(.title3)
        .border(viewModel.borderColor)
        .onChange(of: viewModel.textInput, perform: { value in
          viewModel.processJSON()
        })
        .padding()
    }
  }
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      AddAPIView(viewModel: AddAPIViewModel())
    }
  }
}

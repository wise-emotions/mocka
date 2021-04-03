//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

struct AddAPIView: View {
  @ObservedObject var viewModel = AddAPIViewModel()
  
  var body: some View {
    ZStack() {
      VStack {
        HStack {
          Spacer()
          Button("Importa"){
            viewModel.isPresented = true
          }
          .fileImporter(isPresented: $viewModel.isPresented, allowedContentTypes: [UTType.json], allowsMultipleSelection: false, onCompletion: { result in
            viewModel.importJSON(from: result)
          })
        }
        
        TextEditor(text: $viewModel.textInput)
          .font(.body)
          .border(viewModel.borderColor)
          .onChange(of: viewModel.textInput, perform: { value in
            viewModel.processJSON()
          })
          .padding()
      }
    }
    .onDrop(of: ["public.file-url"], isTargeted: $viewModel.isDraggingOver, perform: viewModel.handleOnDrop(providers:))
  }
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      AddAPIView(viewModel: AddAPIViewModel())
    }
  }
}


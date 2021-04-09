//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The editor view.
/// Used to edit an API body.
struct Editor: View {
  /// The associated ViewModel.
  @ObservedObject var viewModel = EditorViewModel()
  
  var body: some View {
    ZStack() {
      VStack {
        HStack {
          Text("Response Body")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .foregroundColor(Color.latte)
            .padding(.leading)
          
          Spacer()

          Button("Importa") {
            viewModel.isPresented = true
          }
          .fileImporter(isPresented: $viewModel.isPresented, allowedContentTypes: [UTType.json], allowsMultipleSelection: false, onCompletion: { result in
            viewModel.importJSON(from: result)
          })
          .padding(.trailing)
        }
        
        TextEditor(text: $viewModel.textInput)
          .font(.body)
          .border(viewModel.borderColor)
          .onChange(of: viewModel.textInput, perform: { value in
            viewModel.processJSON()
          })
          .padding(.horizontal)
      }
    }
    .onDrop(of: ["public.file-url"], isTargeted: $viewModel.isDraggingOver, perform: viewModel.handleOnDrop(providers:))
  }
}

struct EditorPreviews: PreviewProvider {
  static var previews: some View {
    Editor(viewModel: EditorViewModel())
  }
}

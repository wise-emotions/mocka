//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The editor view.
/// Used to edit an API body.
struct Editor: View {
  /// The associated ViewModel.
  @StateObject var viewModel = EditorViewModel()

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text("Response Body")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .foregroundColor(Color.latte)
            .padding(.leading)

          Spacer()

          Button("Importa") {
            viewModel.fileImporterIsPresented = true
          }
          .fileImporter(
            isPresented: $viewModel.fileImporterIsPresented,
            allowedContentTypes: [.html, .css, .csv, .text, .json, .xml],
            allowsMultipleSelection: false,
            onCompletion: viewModel.importFile(from:)
          )
          .padding(.trailing)
        }

        TextEditor(text: $viewModel.text)
          .font(.body)
          .border(viewModel.borderColor)
          .onChange(
            of: viewModel.text,
            perform: { _ in
              viewModel.prettyPrintJSON()
            }
          )
          .padding(.horizontal)
      }
    }
    .onDrop(
      of: [UTType.fileURL.identifier],
      isTargeted: $viewModel.isDraggingOver,
      perform: viewModel.handleOnDrop(providers:)
    )
  }
}

struct EditorPreviews: PreviewProvider {
  static var previews: some View {
    Editor(viewModel: EditorViewModel())
  }
}

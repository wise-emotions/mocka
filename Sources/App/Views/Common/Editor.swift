//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The editor view.
/// Used to edit an API body.
struct Editor: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @ObservedObject var viewModel = EditorViewModel()

  // MARK: - Body

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text("Response Body")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .foregroundColor(Color.latte)

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
        }

        TextEditor(
          text: viewModel.mode == .write ? $viewModel.text : .constant(viewModel.text)
        )
        .font(.body)
        .frame(minHeight: 40)
        .background(Color.doppio)
        .cornerRadius(8)
        .border(viewModel.borderColor)
        .onChange(
          of: viewModel.text,
          perform: { _ in
            viewModel.prettyPrintJSON()
          }
        )
      }
    }
    .onDrop(
      of: [UTType.fileURL.identifier],
      isTargeted: $viewModel.isDraggingOver,
      perform: viewModel.handleOnDrop(providers:)
    )
  }
}

// MARK: - Previews

struct EditorPreviews: PreviewProvider {
  static var previews: some View {
    Editor(viewModel: EditorViewModel())
  }
}

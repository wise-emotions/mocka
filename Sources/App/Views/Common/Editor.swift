//
//  Mocka
//

import Sourceful
import SwiftUI
import UniformTypeIdentifiers

/// The editor view.
/// Used to edit an API body.
struct Editor: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @ObservedObject var viewModel: EditorViewModel

  // MARK: - Body

  var body: some View {
    ZStack {
      VStack(spacing: 16) {
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

        MockaSourceCodeTextEditor(
          text: $viewModel.text,
          theme: MockaSourceCodeTheme(),
          isEnabled: viewModel.mode == .write
        )
        .font(.body)
        .frame(height: 320)
        .background(Color.lungo)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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

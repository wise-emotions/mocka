//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The startup settings view.
/// This view is shown in case the `workspaceURL` doesn't exist.
struct RecordModeSettings: View {

  // MARK: - Stored Properties

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel: RecordModeSettingsViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      Text("Before starting the record mode, you need to choose a path where the requests and responses will be saved.\nYou also need to input the base URL that will be used to perform the network calls.")
        .frame(height: 50)
        .font(.body)
        .padding(.vertical)

      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Text("Recording folder path")
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          VStack {
            RoundedTextField(title: "Recording folder path", text: $viewModel.recordingPath)
              .frame(width: 300)
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(Color.redEye, lineWidth: viewModel.recordingPathError == nil ? 0 : 1)
              )

            Text("Please note that the selected folder must exist and it will not be automatically created.")
              .font(.subheadline)
              .frame(width: 300, height: 30)
              .padding(.top, -6)
              .foregroundColor(.macchiato)
          }

          Button("Select folder") {
            viewModel.fileImporterIsPresented.toggle()
          }
          .frame(height: 30)
          .fileImporter(
            isPresented: $viewModel.fileImporterIsPresented,
            allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false,
            onCompletion: viewModel.selectFolder(with:)
          )
        }

        HStack {
          Text("Recording base URL")
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Recording base URL", text: $viewModel.middlewareBaseURL)
            .frame(width: 300)
        }
      }

      VStack(alignment: .trailing) {
        Button(
          action: {
            viewModel.confirmSettings(with: appEnvironment)
          },
          label: {
            Text("OK")
              .frame(width: 100, height: 21)
          }
        )
        .buttonStyle(AccentButtonStyle())
        .padding(.horizontal)
        .padding(.top)
      }
    }
    .padding(25)
  }
}

// MARK: - Previews

struct RecordModeSettingsPreview: PreviewProvider {
  static var previews: some View {
    RecordModeSettings(viewModel: RecordModeSettingsViewModel())
  }
}

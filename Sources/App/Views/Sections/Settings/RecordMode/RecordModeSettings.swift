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
      Text(
        "Before starting the record mode, you need to choose a path where the requests and responses will be saved.\nYou also need to input the base URL that will be used to perform the network calls."
      )
      .frame(height: 50)
      .font(.body)
      .padding(.vertical)

      VStack(alignment: .leading, spacing: 16) {
        HStack(alignment: .top) {
          Text("Recording folder path")
            .font(.subheadline)
            .frame(width: 120, alignment: .trailing)
            .padding(.top, 11)

          VStack {
            RoundedTextField(title: "Recording folder path", text: $viewModel.recordingPath)
              .frame(width: 344)
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(Color.redEye, lineWidth: viewModel.recordingPathError == nil ? 0 : 1)
              )

            Text("Please note that the selected folder must exist and it will not be automatically created.")
              .font(.subheadline)
              .frame(width: 344, height: 30)
              .padding(.top, -6)
              .foregroundColor(.macchiato)
          }

          Button("Select folder") {
            viewModel.fileImporterIsPresented.toggle()
          }
          .frame(height: 36)
          .fileImporter(
            isPresented: $viewModel.fileImporterIsPresented,
            allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false,
            onCompletion: viewModel.selectFolder(with:)
          )
        }

        HStack(alignment: .top) {
          Text("Recording base URL")
            .font(.subheadline)
            .frame(width: 120, alignment: .trailing)
            .padding(.top, 11)

          RoundedTextField(title: "Recording base URL", text: $viewModel.middlewareBaseURL)
            .frame(width: 344)
        }

        HStack {
          Toggle(isOn: $viewModel.shouldOverwriteResponse) {
            Text("Overwrite already existing responses")
          }
          .padding(.top, 10)
          .padding(.leading, 128)
        }
      }

      VStack {
        HStack {
          Spacer()

          Button(
            action: {
              appEnvironment.isRecordModeSettingsPresented.toggle()
            },
            label: {
              Text("Cancel")
                .padding(.horizontal)
            }
          )

          Button(
            action: {
              viewModel.confirmSettingsAndStartRecording()
            },
            label: {
              Text("Start recording")
                .frame(height: 20)
                .padding(.horizontal)
            }
          )
          .buttonStyle(AccentButtonStyle())
        }
      }
      .padding(.top)
    }
    .padding(25)
  }
}

// MARK: - Previews

struct RecordModeSettingsPreview: PreviewProvider {
  static var previews: some View {
    RecordModeSettings(viewModel: RecordModeSettingsViewModel(appEnvironment: AppEnvironment()))
  }
}

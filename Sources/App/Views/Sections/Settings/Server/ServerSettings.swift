//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The startup settings view.
/// This view is shown in case the `workspaceURL` doesn't exist.
struct ServerSettings: View {

  // MARK: - Stored Properties

  /// The current color scheme of the app.
  @Environment(\.colorScheme) var colorScheme: ColorScheme

  /// A binding to the current presentation mode of the view associated with this environment.
  @Environment(\.presentationMode) var presentationMode

  /// The associated ViewModel.
  @StateObject var viewModel: ServerSettingsViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      Text("Welcome to Mocka")
        .font(.largeTitle)
        .foregroundColor(.latte)
        .isHidden(viewModel.isShownFromSettings, remove: true)

      Text("Before starting you need to select a workspace path.\nYou can also set an optional server's address and port.")
        .frame(height: 32)
        .font(.body)
        .foregroundColor(.latte)
        .padding(.vertical)
        .isHidden(viewModel.isShownFromSettings, remove: true)

      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Text("Workspace folder")
            .font(.headline)
            .foregroundColor(.latte)
            .frame(width: 120, height: 30, alignment: .trailing)

          VStack {
            RoundedTextField(title: "Workspace folder", text: $viewModel.workspacePath)
              .frame(width: 300)
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(Color.redEye, lineWidth: viewModel.workspacePathError == nil ? 0 : 1)
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
          .foregroundColor(.latte)
          .frame(height: 30)
          .fileImporter(
            isPresented: $viewModel.fileImporterIsPresented,
            allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false,
            onCompletion: viewModel.selectFolder(with:)
          )
        }

        HStack {
          Text("Server address")
            .foregroundColor(.latte)
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server address", text: $viewModel.hostname)
            .frame(width: 300)
        }

        HStack {
          Text("Server port")
            .font(.headline)
            .foregroundColor(.latte)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server port", text: $viewModel.port)
            .frame(width: 300)
        }

        HStack {
          Toggle(isOn: $viewModel.isGitRepositoryCreationEnabled) {
            Text("Create Git Repository")
          }
          .disabled(viewModel.isGitRepositoryAlreadyCreated)
          .padding(.top, 10)
          .padding(.leading, 128)
        }
      }

      VStack(alignment: .trailing) {
        Button(
          action: {
            viewModel.confirmSettings(with: presentationMode)
          },
          label: {
            Text("OK")
              .frame(width: 100, height: 21)
          }
        )
        .buttonStyle(AccentButtonStyle(colorScheme: colorScheme))
        .padding(.horizontal)
        .padding(.top)
      }
    }
    .padding(25)
  }
}

// MARK: - Previews

struct StartupSettingsPreviews: PreviewProvider {
  static var previews: some View {
    ServerSettings(viewModel: ServerSettingsViewModel(isShownFromSettings: false))

    ServerSettings(viewModel: ServerSettingsViewModel(isShownFromSettings: true))
  }
}

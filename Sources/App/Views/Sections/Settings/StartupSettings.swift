//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

/// The startup settings view.
/// This view is shown in case the `workspaceURL` doesn't exist.
struct StartupSettings: View {

  // MARK: - Stored Properties

  /// A binding to the current presentation mode of the view associated with this environment.
  @Environment(\.presentationMode) var presentationMode

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated ViewModel.
  @StateObject var viewModel = StartupSettingsViewModel()

  // MARK: - Body

  var body: some View {
    let workspacePathBinding = Binding {
      viewModel.workspacePath
    } set: {
      viewModel.checkURL($0)
    }

    VStack {
      Text("Welcome to Mocka")
        .font(.largeTitle)

      Text("Before starting you need to select a workspace path.\nYou can also set an optional server's address and port.")
        .frame(height: 32)
        .font(.body)
        .padding(.vertical)

      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Text("Workspace folder")
            .font(.headline)
            .frame(width: 120, height: 30, alignment: .trailing)

          VStack {
            RoundedTextField(title: "Workspace folder", text: workspacePathBinding)
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
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server address", text: $viewModel.hostname)
            .frame(width: 300)
        }

        HStack {
          Text("Server port")
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server port", text: $viewModel.port)
            .frame(width: 300)
        }
      }

      VStack(alignment: .trailing) {
        Button(
          action: {
            viewModel.confirmSettings(for: appEnvironment, with: presentationMode)
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

struct StartupSettingsPreviews: PreviewProvider {
  static var previews: some View {
    StartupSettings()
  }
}

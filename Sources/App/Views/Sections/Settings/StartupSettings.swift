//
//  Mocka
//

import SwiftUI
import UniformTypeIdentifiers

struct StartupSettings: View {
  @Environment(\.presentationMode) var presentationMode

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  /// The associated view model.
  @StateObject var viewModel = StartupSettingsViewModel()

  var body: some View {
    let workspacePathBinding = Binding {
      viewModel.workspacePath
    } set: {
      do {
        try Logic.WorkspacePath.check(URL(fileURLWithPath: $0))
        viewModel.workspacePath = $0
        viewModel.workspacePathError = nil
      } catch {
        viewModel.workspacePath = $0

        guard let workspacePathError = error as? MockaError else {
          return
        }

        viewModel.workspacePathError = workspacePathError
      }
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

          Button(
            action: {
              viewModel.fileImporterIsPresented.toggle()
            },
            label: {
              Text("Select folder")
            }
          )
          .frame(height: 30)
          .fileImporter(
            isPresented: $viewModel.fileImporterIsPresented,
            allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false,
            onCompletion: { result in
              guard let workspacePath = Logic.Startup.selectFolder(from: result) else {
                viewModel.workspacePathError = .missingWorkspacePathValue
                return
              }

              viewModel.workspacePath = workspacePath
              viewModel.workspacePathError = nil
            }
          )
        }

        HStack {
          Text("Server address")
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server address", text: .constant("127.0.0.1"))
            .frame(width: 300)
        }

        HStack {
          Text("Server port")
            .font(.headline)
            .frame(width: 120, alignment: .trailing)

          RoundedTextField(title: "Server port", text: .constant("8080"))
            .frame(width: 300)
        }
      }

      VStack(alignment: .trailing) {
        Button(
          action: {
            let workspaceURL = URL(fileURLWithPath: viewModel.workspacePath)

            do {
              try Logic.WorkspacePath.check(workspaceURL)
              try Logic.Startup.createConfiguration(for: workspaceURL)

              appEnvironment.workspaceURL = workspaceURL
              presentationMode.wrappedValue.dismiss()
            } catch {
              guard let workspacePathError = error as? MockaError else {
                return
              }

              viewModel.workspacePathError = workspacePathError
            }
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

struct SettingsPreviews: PreviewProvider {
  static var previews: some View {
    StartupSettings()
  }
}

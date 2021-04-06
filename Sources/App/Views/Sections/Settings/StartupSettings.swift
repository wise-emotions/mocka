//
//  Mocka
//

import SwiftUI

struct StartupSettings: View {
  @Environment(\.presentationMode) var presentationMode

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  @State var workspacePath: String = ""

  @State var workspacePathError: MockaError = .missingWorkspacePathValue

  var body: some View {
    let workspacePathBinding = Binding {
      self.workspacePath
    } set: {
      do {
        try Logic.WorkspacePath.check(URL(fileURLWithPath: $0))
        self.workspacePath = $0
      } catch {
        self.workspacePath = $0

        guard let workspacePathError = error as? MockaError else {
          return
        }

        self.workspacePathError = workspacePathError
      }
    }

    VStack {
      Text("Welcome to Mocka")
        .font(.largeTitle)

      Text("Before starting you need to select a workspace path.\nYou can also set an optional server's address and port.")
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

            Text("Please note that the selected folder must exist and it will not be automatically created.")
              .font(.subheadline)
              .frame(width: 300, height: 30)
              .padding(.top, -6)
              .foregroundColor(.macchiato)
          }

          Button(
            action: {},
            label: {
              Text("Select folder")
            }
          )
          .frame(height: 30)
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
            let workspaceURL = URL(fileURLWithPath: workspacePath)
            do {
              try Logic.Startup.createConfiguration(for: workspaceURL)

              appEnvironment.workspaceURL = workspaceURL
              presentationMode.wrappedValue.dismiss()
            } catch {
              #warning("Handle error case")
            }
          },
          label: {
            Text("OK")
              .frame(maxWidth: 100, maxHeight: 21)
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

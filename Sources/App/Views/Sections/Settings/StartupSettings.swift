//
//  Mocka
//

import SwiftUI

struct StartupSettings: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    VStack {
      Text("Welcome to Mocka")
        .font(.largeTitle)

      Text("Before starting you need to select a root project path.\nYou can also set an optional server's address and port.")
        .font(.body)
        .padding(.vertical)

      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Text("Root project path:")
            .font(.headline)
            .frame(width: 120, alignment: .leading)

          VStack {
            RoundedTextField(title: "Root project path", text: .constant("Path"))
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
              Text("Select")
            }
          )
          .frame(height: 30)
        }

        HStack {
          Text("Server address:")
            .font(.headline)
            .frame(width: 120, alignment: .leading)

          RoundedTextField(title: "Server address", text: .constant("127.0.0.1"))
            .frame(width: 300)
        }

        HStack {
          Text("Server port:")
            .font(.headline)
            .frame(width: 120, alignment: .leading)

          RoundedTextField(title: "Server port", text: .constant("8080"))
            .frame(width: 300)
        }
      }

      VStack(alignment: .trailing) {
        Button(
          action: {
            try? Logic.RootPath.set(URL(fileURLWithPath: "/Users/fabriziobrancati/Desktop/Mocka"))
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

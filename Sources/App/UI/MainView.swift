import SwiftUI
import Server

struct MainView: View {
  let server = Server()

  var body: some View {
    HStack(content: {
      Button("Start", action: {
        try? server.start(with: ServerConfiguration(requests: requests))
      })
      Button("Stop", action: {
        server.stop()
      })
    })
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

extension MainView {
  var requests: [Request] {
    [Request(method: .get, path: "api/test", responseLocation: nil)]
  }
}

struct ServerConfiguration: ServerConfigurationProvider {
  var requests: [Request]

  init(requests: [Request]) {
    self.requests = requests
  }
}

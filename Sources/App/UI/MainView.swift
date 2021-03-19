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
        try? server.stop()
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
  var requests: Set<Request> {
    [
      Request(
        method: .get,
        path: ["api", "204"],
        requestedResponse: RequestedResponse(
            status: .noContent,
            headers: [:],
            content: nil
          )
      )
    ]
  }
}

struct ServerConfiguration: ServerConfigurationProvider {
  var requests: Set<Request>

  init(requests: Set<Request>) {
    self.requests = requests
  }
}

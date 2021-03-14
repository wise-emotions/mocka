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
      ),
      Request(
        method: .post,
        path: ["api", "200"],
        requestedResponse: RequestedResponse(
          status: .ok,
          headers: [:],
          content: .applicationJSON(url: URL(string: "/Users/TheInkedEngineer/Code/Wise/mocka/Tests/ServerTests/Resources/DummyJSON.json")!)
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

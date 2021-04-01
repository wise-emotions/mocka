import Foundation
import Server

struct ServerConfiguration: ServerConfigurationProvider {
  var requests: Set<Request>

  init(requests: Set<Request>) {
    self.requests = requests
  }
}

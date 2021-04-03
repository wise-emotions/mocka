import Foundation
import Server

struct ServerConfiguration: ServerConfigurationProvider {
  var requests: Set<Models.Request>

  init(requests: Set<Models.Request>) {
    self.requests = requests
  }
}

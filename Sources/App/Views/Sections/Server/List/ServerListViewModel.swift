//
//  Mocka
//

import Foundation

/// The view model of the `ServerToolbar`.
final class ServerListViewModel: ObservableObject {
  /// The text that filters the requests.
  @Published var filterText: String = ""
}

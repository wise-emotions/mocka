//
//  Mocka
//

import Foundation

/// The ViewModel of the `ServerToolbar`.
final class ServerListViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The text that filters the requests.
  @Published var filterText: String = ""
}

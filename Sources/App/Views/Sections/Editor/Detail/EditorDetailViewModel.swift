//
//  Mocka
//

import SwiftUI

/// The ViewModel of the `EditorDetail` view.
final class EditorDetailViewModel: ObservableObject {

  /// The selected `MockaApp.Request`.
  let selectedRequest: Request?

  /// If true, the `UI` should display the empty state `UI`.
  var shouldShowEmptyState: Bool {
    selectedRequest == nil
  }

  /// Creates an instance of `EditorDetailViewModel`.
  /// - Parameter selectedRequest: The `MockaApp.Request` we want to display its details. Defaults to `nil`.
  init(selectedRequest: Request? = nil) {
    self.selectedRequest = selectedRequest
  }
}

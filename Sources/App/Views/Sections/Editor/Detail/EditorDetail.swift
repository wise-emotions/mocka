//
//  Mocka
//

import SwiftUI

/// A view that displays the details of a request.
struct EditorDetail: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @StateObject var viewModel: EditorDetailViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      if viewModel.shouldShowEmptyState {
        EmptyState(symbol: .document, text: "Select a request to display its details")
      } else {
        Text("Detail")
      }
    }
  }
}

//
//  Mocka
//

import MockaServer
import SwiftUI

/// This is the common app section used to show all the other sections.
/// This `View` is responsible for rendering the right section based on the
/// `appEnvironment.selectedSection` property.
struct AppSection: View {

  // MARK: - Stored Properties
  
  /// The associated ViewModel.
  @ObservedObject var viewModel: AppSectionViewModel

  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  // MARK: - Body

  var body: some View {
    switch appEnvironment.selectedSection {
    case .server:
      ServerSection()

    case .editor:
      EditorSection()
        .environmentObject(EditorSectionEnvironment())

    case .console:
      ConsoleSection()
    }
  }
}

// MARK: - Previews

struct AppSectionPreview: PreviewProvider {
  static let networkExchanges = [NetworkExchange](
    repeating: NetworkExchange.mock,
    count: 10
  )

  static var previews: some View {
    AppSection(viewModel: AppSectionViewModel(recordModeNetworkExchangesPublisher: networkExchanges.publisher.eraseToAnyPublisher()))
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

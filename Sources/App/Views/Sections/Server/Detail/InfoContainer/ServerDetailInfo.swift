import MockaServer
import SwiftUI
import Foundation

/// The View containing the details of the Request and Response pair.
struct ServerDetailInfo: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  let viewModel: ServerDetailInfoViewModel

  // MARK: - Body

  var body: some View {
    TabView {
      ServerDetailInfoSection(viewModel: viewModel.modelForRequestTab)
        .tabItem {
          Text(viewModel.titleForRequestTab)
        }

      ServerDetailInfoSection(viewModel: viewModel.modelForResponseTab)
        .tabItem {
          Text(viewModel.titleForResponseTab)
        }
    }
    .padding()
    .background(Color.doppio)
  }
}

// MARK: - Preview

struct RequestInfoContainerViewPreviews: PreviewProvider {
  static var previews: some View {
    ServerDetailInfo(
      viewModel: ServerDetailInfoViewModel(networkExchange: NetworkExchange.mock)
    )
  }
}

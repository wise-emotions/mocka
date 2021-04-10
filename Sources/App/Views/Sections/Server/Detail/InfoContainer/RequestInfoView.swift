import MockaServer
import SwiftUI
import Foundation

/// The View containing the details of the Request and Response pair.
struct RequestInfoView: View {

  // MARK: - Stored Properties

  /// The  view model of this `RequestInfoView`.
  let viewModel: RequestInfoViewModel

  // MARK: - Body

  var body: some View {
    TabView {
      ContainerSectionView(viewModel: viewModel.modelForRequestTab)
        .tabItem {
          Text(viewModel.titleForRequestTab)
        }

      ContainerSectionView(viewModel: viewModel.modelForResponseTab)
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
    RequestInfoView(
      viewModel: RequestInfoViewModel(networkExchange: NetworkExchange.mock)
    )
  }
}

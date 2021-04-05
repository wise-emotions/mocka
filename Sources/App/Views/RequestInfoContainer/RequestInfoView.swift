import Server
import SwiftUI
import Foundation

/// The View containing the details of the Request and Response pair.
struct RequestInfoView: View {

  /// The  view model of this `RequestInfoView`.
  let viewModel: RequestInfoViewModel

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

struct RequestInfoContainerView_Previews: PreviewProvider {
  static var previews: some View {
    RequestInfoView(
      viewModel: RequestInfoViewModel(networkExchange: NetworkExchange.mock)
    )
  }
}

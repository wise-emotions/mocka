//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI

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
            .foregroundColor(.milk)
        }

      ServerDetailInfoSection(viewModel: viewModel.modelForResponseTab)
        .tabItem {
          Text(viewModel.titleForResponseTab)
            .foregroundColor(.milk)
        }
    }
    .padding()
    .background(Color.doppio)
  }
}

// MARK: - Preview

struct ServerDetailInfoViewPreviews: PreviewProvider {
  static var previews: some View {
    ServerDetailInfo(
      viewModel: ServerDetailInfoViewModel(networkExchange: NetworkExchange.mock)
    )
  }
}

//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI

/// The View containing the details of the Request and Response pair.
struct ServerDetailInfo: View {

  // MARK: - Stored Properties

  /// The current color scheme of the app.
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  
  /// The associated ViewModel.
  let viewModel: ServerDetailInfoViewModel
  
  // MARK: - Computed Properties
  
  /// The `Color` for the `Text` elements in the `TabView`.
  private var textColor: Color {
    colorScheme == .dark ? .latte : .doppio
  }

  // MARK: - Body

  var body: some View {
    TabView {
      ServerDetailInfoSection(viewModel: viewModel.modelForRequestTab)
        .tabItem {
          Text(viewModel.titleForRequestTab)
            .foregroundColor(textColor)
        }

      ServerDetailInfoSection(viewModel: viewModel.modelForResponseTab)
        .tabItem {
          Text(viewModel.titleForResponseTab)
            .foregroundColor(textColor)
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

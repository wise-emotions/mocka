//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI 

struct ServerDetail: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @State var viewModel: ServerDetailViewModel?

  // MARK: - Body

  var body: some View {
    VStack {
      Divider()

      if let viewModel = viewModel {
        ServerDetailHeader(
          viewModel: ServerDetailHeaderViewModel(
            networkExchange: viewModel.networkExchange
          )
        )

        ServerDetailInfo(
          viewModel: ServerDetailInfoViewModel(
            networkExchange: viewModel.networkExchange
          )
        )
      } else {
        EmptyState(symbol: .tableCells, text: "Tap an API call on the left to see its details here")
      }
    }
    .frame(minWidth: Size.minimumDetailWidth)
  }
}

// MARK: - Previews

struct ServerDetailPreview: PreviewProvider {
  static var previews: some View {
    ServerDetail()
      .previewLayout(.fixed(width: 1024, height: 600))

    ServerDetail(viewModel: ServerDetailViewModel(networkExchange: NetworkExchange.mock))
      .previewLayout(.fixed(width: 1024, height: 600))
  }
}

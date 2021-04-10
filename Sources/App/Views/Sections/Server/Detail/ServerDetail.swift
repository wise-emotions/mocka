//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI 

struct ServerDetail: View {
  @State var viewModel: ServerDetailViewModel?

  var body: some View {
    VStack {
      Divider()

      if let viewModel = viewModel {
        ServerRequestDetailHeaderView(
          viewModel: ServerRequestDetailHeaderViewModel(
            networkExchange: viewModel.networkExchange
          )
        )

        RequestInfoView(
          viewModel: RequestInfoViewModel(
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

struct ServerDetailPreview: PreviewProvider {
  static var previews: some View {
    ServerDetail()
      .previewLayout(.fixed(width: 1024, height: 600))

    ServerDetail(viewModel: ServerDetailViewModel(networkExchange: NetworkExchange.mock))
      .previewLayout(.fixed(width: 1024, height: 600))
  }
}

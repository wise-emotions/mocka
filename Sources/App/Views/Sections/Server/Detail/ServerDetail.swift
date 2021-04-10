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
        RequestInfoView(viewModel: RequestInfoViewModel(networkExchange: viewModel.networkExchange))
      } else {
        Spacer()

        Text("Tap an API call on the list on the left")

        Spacer()
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

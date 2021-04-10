//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI 

struct ServerDetail: View {
  var body: some View {
    VStack {
      Divider()

      RequestInfoView(viewModel: RequestInfoViewModel(networkExchange: NetworkExchange.mock))
    }
    .frame(minWidth: Size.minimumDetailWidth)
  }
}

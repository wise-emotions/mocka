import Foundation
import Server
import SwiftUI 

struct ServerDetail: View {
  var body: some View {
    VStack {
      Text("Header")
      
      RequestInfoView(viewModel: RequestInfoViewModel(networkExchange: NetworkExchange.mock, kind: .request))
    }
    .frame(minWidth: Constants.minimumDetailWidth)
  }
}

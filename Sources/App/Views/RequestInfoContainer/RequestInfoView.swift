import Server
import SwiftUI
import Foundation

struct RequestInfoView: View {

  @StateObject var viewModel: RequestInfoViewModel
    
  var body: some View {
    ZStack(alignment: .top) {
      
      ContainerSectionView(viewModel: viewModel)

      WiseSegmentedControl(
        selection: $viewModel.kind,
        items: RequestInfoViewModel.Kind.allCases,
        itemTitles: RequestInfoViewModel.Kind.allCases.map(\.rawValue)
      )
      .offset(y: -12)
    }
    .background(Color.lungo.cornerRadius(5))
    .padding()
    .background(Color.doppio)
  }
}

// MARK: - Preview

struct RequestInfoContainerView_Previews: PreviewProvider {
  static var previews: some View {
    RequestInfoView(
      viewModel: RequestInfoViewModel(
        networkExchange: NetworkExchange.mock,
        kind: .request
      )
    )
  }
}

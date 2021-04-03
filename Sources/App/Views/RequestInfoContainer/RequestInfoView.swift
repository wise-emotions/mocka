import Server
import SwiftUI
import Foundation

struct RequestInfoView: View {

  @StateObject var viewModel: RequestInfoViewModel
    
  var body: some View {
    ZStack(alignment: .top) {
      
      ContainerSectionView(viewModel: viewModel)

      Picker(selection: $viewModel.kind, label: EmptyView()) {
        ForEach(RequestInfoViewModel.Kind.allCases, id: \.self) { kind in
          Text(kind.rawValue).tag(kind)
            .font(.system(size: 13, weight: .regular, design: .default))
            .foregroundColor(Color.latte)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .frame(width: 160, height: 24)
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

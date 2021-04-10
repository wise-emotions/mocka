//
// Mocka
//

import MockaServer
import SwiftUI


/// The header of the `ServerRequestDetailView`.
struct ServerRequestDetailHeaderView: View {

  /// The  view model of this `ServerRequestDetailHeaderView`.
  let viewModel: ServerRequestDetailHeaderViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 16){
      HStack(alignment: .top, spacing: 8) {
        TextPillView(text: viewModel.httpMethod.rawValue)
        Text(viewModel.path)
          .font(.system(size: 13))
          .foregroundColor(Color.latte)
          .fixedSize(horizontal: false, vertical: true)
          .contextMenuCopy(viewModel.urlString)
      }
      HStack(spacing: 10) {
        HTTPStatusCodeEllipse(httpStatus: viewModel.httpStatus)
        Text(String("\(viewModel.httpStatus) \(viewModel.httpStatusMeaning)"))
          .font(.system(size: 13))
          .foregroundColor(Color.macchiato)
        Spacer()
        Text(viewModel.timestamp)
          .font(.system(size: 13))
          .foregroundColor(Color.macchiato)
          .padding(.trailing, 6)
      }
    }
    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 24))
  }
}

// MARK: - Preview

struct ServerRequestDetailHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ServerRequestDetailHeaderView(
      viewModel: ServerRequestDetailHeaderViewModel(
        networkExchange: NetworkExchange.mock
      )
    )
    .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity)
  }
}

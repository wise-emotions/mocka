//
//  Mocka
//

import MockaServer
import SwiftUI

/// The header of the `ServerDetail`.
struct ServerDetailHeader: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  let viewModel: ServerDetailHeaderViewModel

  // MARK: - Body

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top, spacing: 8) {
        TextPill(text: viewModel.httpMethod.rawValue)
        Text(viewModel.urlString)
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

struct ServerRequestDetailHeaderViewPreviews: PreviewProvider {
  static var previews: some View {
    ServerDetailHeader(
      viewModel: ServerDetailHeaderViewModel(
        networkExchange: NetworkExchange.mock
      )
    )
  }
}

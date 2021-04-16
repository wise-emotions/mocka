//
//  Mocka
//

import MockaServer
import SwiftUI

/// The server list item. To be used inside a `ServerList` element.
struct ServerListItem: View {

  // MARK: - Stored Properties

  /// The `ViewModel` of the view.
  let viewModel: ServerListItemViewModel

  // MARK: - Body

  var body: some View {
    HStack {
      HTTPStatusCodeEllipse(httpStatus: viewModel.networkExchange.response.status.code)
        .padding(.leading, 8)

      VStack(alignment: .leading, spacing: 10) {
        HStack {
          TextPill(text: viewModel.networkExchange.request.httpMethod.rawValue)

          Text(viewModel.networkExchange.request.uri.string)
            .font(.system(size: 12))
            .foregroundColor(.latte)
            .padding(.trailing, 8)
            .frame(height: 16)
        }

        HStack(spacing: 4) {
          Text(String(viewModel.networkExchange.response.status.code))
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.macchiato)

          Text(viewModel.networkExchange.response.status.reasonPhrase)
            .font(.system(size: 11))
            .foregroundColor(.macchiato)

          Spacer()

          Text(viewModel.networkExchange.response.timestamp.timestampPrint)
            .font(.system(size: 11))
            .foregroundColor(.macchiato)
            .padding(.trailing, 4)
        }
      }
      .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 8))
    }
    .background(Color.doppio)
    .cornerRadius(5)
  }
}

// MARK: - Previews

struct ItemPreviews: PreviewProvider {
  static var previews: some View {
    ServerListItem(viewModel: ServerListItemViewModel(networkExchange: NetworkExchange.mock))
  }
}

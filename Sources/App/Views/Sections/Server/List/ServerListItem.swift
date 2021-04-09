//
//  Mocka
//

import MockaServer
import SwiftUI

/// The server list item. To be used inside a `ServerList` element.
struct ServerListItem: View {
  /// The `ViewModel` of the view.
  let viewModel: ServerListItemViewModel

  var body: some View {
    HStack {
      HTTPStatusCodeEllipse(httpStatus: viewModel.networkExchange.response.status.code)
        .padding(.leading, 8)

      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Text(viewModel.networkExchange.request.httpMethod.rawValue)
            .font(.system(size: 12, weight: .bold))
            .padding(8)
            .frame(height: 20)
            .background(Color.ristretto)
            .cornerRadius(100)
            .foregroundColor(.latte)
            .frame(width: 77, alignment: .leading)
          Text(viewModel.networkExchange.request.uri.path)
            .font(.system(size: 12))
            .foregroundColor(.latte)
            .padding(.trailing, 8)
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
    .background(Color.lungo)
    .cornerRadius(5)
  }
}

struct ItemPreviews: PreviewProvider {
  static var previews: some View {
    ServerListItem(viewModel: ServerListItemViewModel(networkExchange: NetworkExchange.mock))
  }
}

struct ItemLibraryContent: LibraryContentProvider {
  let viewModel: ServerListItemViewModel = ServerListItemViewModel(networkExchange: NetworkExchange.mock)

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(
      ServerListItem(viewModel: ServerListItemViewModel(networkExchange: NetworkExchange.mock))
    )
  }
}

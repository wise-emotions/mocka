//
//  Mocka
//

import MockaServer
import SwiftUI

/// The scrollable section containing the information about the request/response pair.
struct ServerDetailInfoSection: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  let viewModel: ServerDetailInfoSectionViewModel

  // MARK: - Body

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 24) {
        ServerDetailInfoSubSection(title: "URL") {
          Text(viewModel.urlString)
            .padding()
            .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 13, weight: .regular, design: .default))
            .foregroundColor(Color.latte)
            .contextMenuCopy(viewModel.urlString)
        }

        if viewModel.isQuerySectionVisible {
          ServerDetailInfoSubSection(title: "Query") {
            KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: viewModel.queryParameters, mode: .read))
          }
        }

        if viewModel.isHeadersSectionVisible {
          ServerDetailInfoSubSection(title: "Headers") {
            KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: viewModel.headers, mode: .read))
          }
        }

        if viewModel.isBodySectionVisible {
          ServerDetailInfoSubSection(title: "Body") {
            TextEditor(text: .constant(viewModel.body))
              .padding()
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
          }
        }
      }
      .padding(.horizontal)
      .padding(.bottom)
    }
  }
}

// MARK: - Preview

struct ServerDetailInfoSectionPreviews: PreviewProvider {
  static var previews: some View {
    ServerDetailInfoSection(
      viewModel: ServerDetailInfoSectionViewModel(
        networkExchange: NetworkExchange.mock,
        kind: .request
      )
    )
  }
}

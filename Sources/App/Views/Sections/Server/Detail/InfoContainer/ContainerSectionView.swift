//
//  Mocka
//

import MockaServer
import SwiftUI

extension RequestInfoView {
  /// The scrollable section containing the information about the request/response pair.
  struct ContainerSectionView: View {

    // MARK: - Stored Properties

    /// The view model of this `ContainerSectionView`.
    let viewModel: RequestInfoViewModel.ContainerSectionViewModel

    // MARK: - Body

    var body: some View {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 24) {
          RequestInfoViewSectionView(title: "URL") {
            Text(viewModel.urlString)
              .padding()
              .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
              .contextMenuCopy(viewModel.urlString)
          }

          if viewModel.isQuerySectionVisible {
            RequestInfoViewSectionView(title: "Query") {
              KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: viewModel.queryParameters, mode: .read))
            }
          }

          if viewModel.isHeadersSectionVisible {
            RequestInfoViewSectionView(title: "Headers") {
              KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: viewModel.headers, mode: .read))
            }
          }

          if viewModel.isBodySectionVisible {
            RequestInfoViewSectionView(title: "Body") {
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
}

// MARK: - Preview

struct RequestInfoViewPreviews: PreviewProvider {
  static var previews: some View {
    RequestInfoView.ContainerSectionView(
      viewModel: RequestInfoViewModel.ContainerSectionViewModel(
        networkExchange: NetworkExchange.mock,
        kind: .request
      )
    )
  }
}

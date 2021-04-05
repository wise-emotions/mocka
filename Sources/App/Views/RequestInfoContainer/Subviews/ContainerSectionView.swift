//
//  Mocka
//

import Server
import SwiftUI

extension RequestInfoView {
  /// The scrollable section containing the information about the request/response pair.
  struct ContainerSectionView: View {

    /// The view model of this `ContainerSectionView`.
    let viewModel: RequestInfoViewModel.ContainerSectionViewModel
    
    var body: some View {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 24) {
          SectionView(title: "URL") {
            TextField(viewModel.path, text: .constant(viewModel.path))
              .padding()
              .textFieldStyle(PlainTextFieldStyle())
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
          }

          if viewModel.isQuerySectionVisible {
            SectionView(title: "Query") {
              KeyValueTable(keyValueItems: viewModel.queryParameters)
            }
          }

          if viewModel.isHeadersSectionVisible {
            SectionView(title: "Headers") {
              KeyValueTable(keyValueItems: viewModel.headers)
            }
          }

          SectionView(title: "Body") {
            TextEditor(text: .constant(viewModel.body))
              .padding()
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
          }
        }
        .padding()
      }
    }
  }
}

// MARK: - Preview

struct ScrollableSection_Previews: PreviewProvider {
  static var previews: some View {
    RequestInfoView.ContainerSectionView(
      viewModel: RequestInfoViewModel.ContainerSectionViewModel(
        networkExchange: NetworkExchange.mock,
        kind: .request
      )
    )
  }
}

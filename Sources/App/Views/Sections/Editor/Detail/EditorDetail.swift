//
//  Mocka
//

import SwiftUI

/// A view that displays the details of a request.
struct EditorDetail: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @StateObject var viewModel: EditorDetailViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      if viewModel.shouldShowEmptyState {
        EmptyState(symbol: .document, text: "Select a request to display its details")
      } else {
        ScrollView {
          RoundedTextField(title: "API custom name", text: $viewModel.requestName)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "Parent Folder",
            selection: $viewModel.requestParentFolder,
            items: viewModel.namespaceFolders,
            itemTitleKeyPath: \.name
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedTextField(title: "Path", text: $viewModel.requestPath)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "HTTP Method",
            selection: $viewModel.selectedHTTPMethod,
            items: viewModel.allHTTPMethods,
            itemTitleKeyPath: \.rawValue
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "Response Content-Type",
            selection: $viewModel.selectedContentType,
            items: viewModel.allContentTypes,
            itemTitleKeyPath: \.rawValue
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)
        }
        .padding(.top, 24)
      }
    }
    .frame(minWidth: Size.minimumListWidth)
    .toolbar {
      ToolbarItem {
        HStack {
          Text(viewModel.requestName)
            // The `minWidth: 1` is due to a bug in SwiftUI where not including any minWidth generates a warning.
            .frame(minWidth: 1, maxWidth: .infinity, alignment: .leading)
            .font(.title)
            .foregroundColor(.latte)
        }
      }
    }
  }
}

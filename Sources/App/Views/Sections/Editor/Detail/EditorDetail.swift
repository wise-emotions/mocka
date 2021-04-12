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
          RoundedTextField(title: "API custom name", text: $viewModel.displayedRequestName)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "Parent Folder",
            items: viewModel.namespaceFolders,
            itemTitleKeyPath: \.name,
            selection: $viewModel.selectedRequestParentFolder
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedTextField(title: "Path", text: $viewModel.displayedRequestPath)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "HTTP Method",
            items: viewModel.allHTTPMethods,
            itemTitleKeyPath: \.rawValue,
            selection: $viewModel.selectedHTTPMethod
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedTextField(title: "Response status code", text: $viewModel.displayedStatusCode)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)

          RoundedBorderDropdown(
            title: "Response Content-Type",
            items: viewModel.allContentTypes,
            itemTitleKeyPath: \.rawValue,
            selection: $viewModel.selectedContentType
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
          Text(viewModel.displayedRequestName)
            // The `minWidth` equal to `1` is due to a bug in SwiftUI where not including any minWidth generates a warning.
            .frame(minWidth: 1, maxWidth: 200, alignment: .leading)
            .font(.title)
            .foregroundColor(.latte)
        }
      }
      ToolbarItemGroup {
        Spacer()

        Button("Cancel") {
          viewModel.cancelRequestCreation()
        }
        .frame(height: 25)
        .isHidden(viewModel.shouldShowEmptyState)

        Button(
          action: {
            viewModel.createAndSaveRequest()
          },
          label: {
            Text("Save")
              .frame(width: 80, height: 21)
          }
        )
        .buttonStyle(AccentButtonStyle())
      }
    }
  }
}

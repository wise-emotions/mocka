//
//  Mocka
//

import SwiftUI

/// A view that displays the details of a request.
struct EditorDetail: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @ObservedObject var viewModel: EditorDetailViewModel

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
            .disabled(viewModel.isRequestNameTextFieldEnabled.isFalse)

          RoundedBorderDropdown(
            title: "Parent Folder",
            items: viewModel.namespaceFolders,
            itemTitleKeyPath: \.name,
            selection: $viewModel.selectedRequestParentFolder,
            isEnabled: viewModel.isRequestParentFolderTextFieldEnabled
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedTextField(title: "Path", text: $viewModel.displayedRequestPath)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)
            .disabled(viewModel.isRequestPathTextFieldEnabled.isFalse)

          RoundedBorderDropdown(
            title: "HTTP Method",
            items: viewModel.allHTTPMethods,
            itemTitleKeyPath: \.rawValue,
            selection: $viewModel.selectedHTTPMethod,
            isEnabled: viewModel.isHTTPMethodTextFieldEnabled
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          RoundedTextField(title: "Response status code", text: $viewModel.displayedStatusCode)
            .padding(.horizontal, 26)
            .padding(.vertical, 5)
            .disabled(viewModel.isStatusCodeTextFieldEnabled.isFalse)

          RoundedBorderDropdown(
            title: "Response Content-Type",
            items: viewModel.allContentTypes,
            itemTitleKeyPath: \.rawValue,
            selection: $viewModel.selectedContentType,
            isEnabled: viewModel.isContentTypeTextFieldEnabled
          )
          .padding(.horizontal, 26)
          .padding(.vertical, 5)

          Text("If a Response Content-Type is selected, you need to provide a body. Otherwise, select \"none\".")
            .padding(.horizontal, 26)
            .padding(.top, -5)
            .foregroundColor(.americano)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack(spacing: 0) {
            Text("Response Headers")
              .font(.system(size: 13, weight: .semibold, design: .default))
              .foregroundColor(Color.latte)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(10)

            KeyValueTable(
              viewModel: KeyValueTableViewModel(
                keyValueItems: $viewModel.displayedResponseHeaders,
                mode: viewModel.currentMode == .read ? .read : .write
              )
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 20)

            Editor(viewModel: EditorViewModel(text: $viewModel.displayedResponseBody, mode: viewModel.currentMode == .read ? .read : .write))
              .disabled(viewModel.isResponseHeadersKeyValueTableEnabled.isFalse || viewModel.isResponseBodyEditorEnabled.isFalse)
              .padding(.horizontal, 10)
              .isVisible(viewModel.isEditorDetailResponseBodyVisible, remove: true)
          }
          .background(Color.lungo)
          .cornerRadius(5)
          .padding(24)
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
        .isHidden(viewModel.shouldShowEmptyState || viewModel.currentMode == .read)

        Button(
          action: {
            if viewModel.currentMode.isAny(of: [.edit, .create]) {
              viewModel.createAndSaveRequest()
            } else if viewModel.currentMode == .read {
              viewModel.enableEditMode()
            }
          },
          label: {
            Text(viewModel.currentMode == .read ? "Edit" : "Save")
              .frame(width: 80, height: 27)
          }
        )
        .buttonStyle(AccentButtonStyle(isEnabled: viewModel.isSaveButtonEnabled))
        .isHidden(viewModel.shouldShowEmptyState)
        .enabled(viewModel.isPrimaryButtonEnabled)
      }
    }
  }
}

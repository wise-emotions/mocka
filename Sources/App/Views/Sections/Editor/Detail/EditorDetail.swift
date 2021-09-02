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
    Group {
      if viewModel.shouldShowEmptyState {
        EmptyState(symbol: .document, text: "Select a request to display its details")
      } else {
        ScrollView {
          VStack(spacing: 24) {
            fieldsSection

            headersSection

            Editor(viewModel: EditorViewModel(text: $viewModel.displayedResponseBody, mode: viewModel.currentMode == .read ? .read : .write))
              .disabled(viewModel.isResponseHeadersKeyValueTableEnabled.isFalse || viewModel.isResponseBodyEditorEnabled.isFalse)
              .isVisible(viewModel.isEditorDetailResponseBodyVisible)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 16)
        }
        .padding(.top, 1)
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

  private var fieldsSection: some View {
    VStack(spacing: 12) {
      RoundedTextField(title: "API custom name", text: $viewModel.displayedRequestName)
        .disabled(viewModel.isRequestNameTextFieldEnabled.isFalse)

      RoundedBorderDropdown(
        title: "Parent Folder",
        items: viewModel.namespaceFolders,
        itemTitleKeyPath: \.name,
        selection: $viewModel.selectedRequestParentFolder,
        isEnabled: viewModel.isRequestParentFolderTextFieldEnabled
      )

      RoundedTextField(title: "Path", text: $viewModel.displayedRequestPath)
        .disabled(viewModel.isRequestPathTextFieldEnabled.isFalse)

      RoundedBorderDropdown(
        title: "HTTP Method",
        items: viewModel.allHTTPMethods,
        itemTitleKeyPath: \.rawValue,
        selection: $viewModel.selectedHTTPMethod,
        isEnabled: viewModel.isHTTPMethodTextFieldEnabled
      )

      RoundedTextField(title: "Response status code", text: $viewModel.displayedStatusCode)
        .disabled(viewModel.isStatusCodeTextFieldEnabled.isFalse)

      RoundedBorderDropdown(
        title: "Response Content-Type",
        items: viewModel.allContentTypes,
        itemTitleKeyPath: \.rawValue,
        selection: $viewModel.selectedContentType,
        isEnabled: viewModel.isContentTypeTextFieldEnabled
      )

      Text("If a Response Content-Type is selected, you need to provide a body. Otherwise, select \"none\".")
        .foregroundColor(.americano)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private var headersSection: some View {
    VStack(spacing: 16) {
      Text("Response Headers")
        .font(.system(size: 13, weight: .semibold, design: .default))
        .foregroundColor(Color.latte)
        .frame(maxWidth: .infinity, alignment: .leading)

      KeyValueTable(
        viewModel: KeyValueTableViewModel(
          keyValueItems: $viewModel.displayedResponseHeaders,
          mode: viewModel.currentMode == .read ? .read : .write
        )
      )
    }
  }
}

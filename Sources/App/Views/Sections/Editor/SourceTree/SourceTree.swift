//
//  Mocka
//

import SwiftUI

/// A view that displays the content of directories containing a request/response? pair in the form of a tree.
struct SourceTree: View {

  // MARK: - Stored Properties

  /// The associated ViewModel.
  @StateObject var viewModel: SourceTreeViewModel

  // MARK: - Body

  var body: some View {
    VStack {
      Divider()

      if viewModel.directoryContent.isEmpty {
        EmptyState(symbol: .scroll, text: "Tap the 􀁌 to add an API request")
          .background(
            NavigationLink(
              destination: EditorDetail(viewModel: viewModel.detailViewModel(for: nil)),
              isActive: $viewModel.isShowingCreateRequestDetailView
            ) {}
          )
      } else if viewModel.filteredNodes.isEmpty {
        EmptyState(symbol: .document, text: "Could not find any API requests with this name")
          .background(
            NavigationLink(
              destination: EditorDetail(viewModel: viewModel.detailViewModel(for: nil)),
              isActive: $viewModel.isShowingCreateRequestDetailView
            ) {}
          )
      } else {
        List(viewModel.filteredNodes, children: \.children) { node in
          NavigationLink(destination: EditorDetail(viewModel: viewModel.detailViewModel(for: node))) {
            SourceTreeNode(name: node.name, isFolder: node.isFolder)
          }
          .contextMenu(
            ContextMenu(
              menuItems: {
                Button("Delete", action: {})
                Button("Edit", action: {})
              }
            )
          )
        }
        .listStyle(SidebarListStyle())
        .padding(.top, -8)
        .background(
          NavigationLink(
            destination: EditorDetail(viewModel: viewModel.detailViewModel(for: nil)),
            isActive: $viewModel.isShowingCreateRequestDetailView
          ) {}
        )
      }
    }
    .frame(minWidth: Size.minimumListWidth)
    .toolbar {
      ToolbarItem {
        HStack {
          SidebarButton()

          RoundedTextField(title: "Filter", size: .medium, text: $viewModel.filterText)
            .frame(width: Size.minimumFilterTextFieldWidth)
            .disabled(true)

          SymbolButton(
            symbolName: .refresh,
            action: {
              try? viewModel.refreshContent()
            }
          )

          SymbolButton(
            symbolName: .plusCircle,
            action: {
              viewModel.isShowingCreateRequestDetailView = true
            }
          )
        }
      }
    }
  }
}

// MARK: - Previews

struct SourceTreePreviews: PreviewProvider {
  static var previews: some View {
    SourceTree(viewModel: try! SourceTreeViewModel())
  }
}

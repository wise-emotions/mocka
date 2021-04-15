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
      } else if viewModel.filteredNodes.isEmpty {
        EmptyState(symbol: .document, text: "Could not find any API requests with this name")
      } else {
        List(viewModel.filteredNodes, children: \.children) { node in
          NavigationLink(destination: EditorDetail(viewModel: viewModel.detailViewModel(for: node))) {
            SourceTreeNode(name: node.name, isFolder: node.isFolder)
          }
          .contextMenu(
            ContextMenu(
              menuItems: {
                ForEach(node.availableActions, id: \.self) { action in
                  Button(
                    viewModel.actionName(action: action),
                    action: {
                      viewModel.performAction(action, on: node)
                    }
                  )
                }
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
              viewModel.selectedNode = nil
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

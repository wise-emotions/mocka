//
//  Mocka
//

import SwiftUI

struct NodeList: View {
  var viewModel: NodeListViewModel

  var body: some View {
    ForEach(viewModel.nodes, id: \.id) { node in
      DisclosureGroup(
        isExpanded: Binding<Bool>(
          get: {
            viewModel.listState[node.url, default: false]
          },
          set: {
            viewModel.listState[node.url] = $0
          }
        ),
        content: {
          if let children = node.children {
            NodeList(
              viewModel: NodeListViewModel(
                nodes: children,
                renamingNode: viewModel.renamingNode,
                listState: viewModel.listState,
                detailViewModel: viewModel.detailViewModel,
                renameNode: viewModel.renameNode,
                actionName: viewModel.actionName,
                performAction: viewModel.performAction
              )
            )
          } else {
            NavigationLink(destination: EditorDetail(viewModel: viewModel.detailViewModel(node))) {
              SourceTreeNode(
                name: node.name,
                isFolder: node.isFolder,
                isRenaming: node == viewModel.renamingNode,
                onRenamed: { updatedName in
                  try? viewModel.renameNode(node, updatedName)
                }
              )
            }
            .onTapGesture {
              self.viewModel.listState[node.url, default: false].toggle()
            }
            .contextMenu(
              ContextMenu(
                menuItems: {
                  ForEach(node.availableActions, id: \.self) { action in
                    Button(
                      viewModel.actionName(action),
                      action: {
                        try? viewModel.performAction(action, node)
                      }
                    )
                  }
                }
              )
            )
          }
        },
        label: {
          NavigationLink(destination: EditorDetail(viewModel: viewModel.detailViewModel(node))) {
            SourceTreeNode(
              name: node.name,
              isFolder: node.isFolder,
              isRenaming: node == viewModel.renamingNode,
              onRenamed: { updatedName in
                try? viewModel.renameNode(node, updatedName)
              }
            )
          }
          .onTapGesture {
            self.viewModel.listState[node.url, default: false].toggle()
          }
          .contextMenu(
            ContextMenu(
              menuItems: {
                ForEach(node.availableActions, id: \.self) { action in
                  Button(
                    viewModel.actionName(action),
                    action: {
                      try? viewModel.performAction(action, node)
                    }
                  )
                }
              }
            )
          )
        }
      )
    }
  }
}

//
//  Mocka
//

import Foundation

/// A shared `Environment` object shared by all the `View`s of the editor section.
final class EditorEnvironment: ObservableObject {
  /// The source tree starting with the workspace and containing containing all the content.
  @Published var sourceTree: FileSystemNode = Logic.SourceTree.sourceTree()
}

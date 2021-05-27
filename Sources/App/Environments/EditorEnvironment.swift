//
//  Mocka
//

import Foundation

/// An `Environment` object shared by all the `View`s of the editor section.
final class EditorSectionEnvironment: ObservableObject {
  /// The source tree starting with the workspace and containing all the content.
  @Published var sourceTree: FileSystemNode = Logic.SourceTree.sourceTree()
}

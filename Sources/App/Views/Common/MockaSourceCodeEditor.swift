//
//  Mocka
//

import Foundation
import Sourceful
import SwiftUI

struct MockaSourceCodeTextEditor: NSViewRepresentable {
  @Binding var text: String
  let lexer: SourceCodeRegexLexer
  let theme: SourceCodeTheme
  let isEnabled: Bool

  init(text: Binding<String>, lexer: SourceCodeRegexLexer = JSONLexer(), theme: SourceCodeTheme, isEnabled: Bool = true) {
    self._text = text
    self.lexer = lexer
    self.theme = theme
    self.isEnabled = isEnabled
  }

  func makeNSView(context: Context) -> SyntaxTextView {
    let wrappedView = SyntaxTextView()
    wrappedView.delegate = context.coordinator
    wrappedView.theme = theme

    context.coordinator.wrappedView = wrappedView
    context.coordinator.wrappedView.text = text

    return wrappedView
  }

  func updateNSView(_ view: SyntaxTextView, context: Context) {
    view.text = text
    view.contentTextView.isEditable = isEnabled
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension MockaSourceCodeTextEditor {
  public class Coordinator: SyntaxTextViewDelegate {
    let parent: MockaSourceCodeTextEditor
    var wrappedView: SyntaxTextView!

    init(_ parent: MockaSourceCodeTextEditor) {
      self.parent = parent
    }

    public func lexerForSource(_ source: String) -> Lexer {
      parent.lexer
    }

    public func didChangeText(_ syntaxTextView: SyntaxTextView) {
      guard parent.isEnabled else {
        return
      }

      DispatchQueue.main.async {
        self.parent.text = syntaxTextView.text
      }
    }
  }
}

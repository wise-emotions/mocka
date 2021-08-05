//
//  Mocka
//

import Foundation
import Sourceful
import SwiftUI

/// A source code editor with custom theme.
struct MockaSourceCodeTextEditor: NSViewRepresentable {
  /// The text in the text view.
  @Binding var text: String
  
  /// The lexer used to lex the content of the `SyntaxTextView`.
  let lexer: SourceCodeRegexLexer
  
  /// The theme to apply to the content of the `SyntaxTextView`.
  let theme: SourceCodeTheme
  
  /// Whether the `SyntaxTextView` should be enabled.
  let isEnabled: Bool
  
  // MARK: - Init
  
  init(text: Binding<String>, lexer: SourceCodeRegexLexer = JSONLexer(), theme: SourceCodeTheme, isEnabled: Bool = true) {
    self._text = text
    self.lexer = lexer
    self.theme = theme
    self.isEnabled = isEnabled
  }
  
  // MARK: - Functions
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeNSView(context: Context) -> SyntaxTextView {
    let wrappedView = SyntaxTextView()
    wrappedView.delegate = context.coordinator
    wrappedView.theme = theme
    wrappedView.text = text
        
    return wrappedView
  }
  
  func updateNSView(_ view: SyntaxTextView, context: Context) {
    context.coordinator.parent = self

    view.contentTextView.isEditable = isEnabled
    view.text = text
  }
}

extension MockaSourceCodeTextEditor {
  /// The `Coordinator` object managing the `MockaSourceCodeTextEditor`.
  class Coordinator: SyntaxTextViewDelegate {
    /// The parent `UIViewRepresentable` managed by the `Coordinator.`
    var parent: MockaSourceCodeTextEditor
    
    // MARK: - Init
    
    init(_ parent: MockaSourceCodeTextEditor) {
      self.parent = parent
    }
    
    // MARK: - Functions
    
    public func lexerForSource(_ source: String) -> Lexer {
      parent.lexer
    }
    
    public func didChangeText(_ syntaxTextView: SyntaxTextView) {
      guard parent.isEnabled else {
        return
      }
            
      parent.text = syntaxTextView.text
    }
  }
}

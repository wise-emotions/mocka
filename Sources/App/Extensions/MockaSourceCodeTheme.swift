//
//  Mocka
//

import Sourceful

final class MockaSourceCodeTheme: SourceCodeTheme {

  let gutterStyle = GutterStyle(backgroundColor: Color(.espresso), minimumWidth: 32)

  let font: Font = .monospacedSystemFont(ofSize: 14, weight: .regular)

  let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(
    font: .monospacedSystemFont(ofSize: 14, weight: .regular),
    textColor: Color(.macchiato)
  )

  let backgroundColor = Color(.lungo)

  // MARK: - Functions

  func color(for syntaxColorType: SourceCodeTokenType) -> Color {
    switch syntaxColorType {
    case .plain:
      return Color.labelColor

    case .keyword:
      return Color(named: "Keyword")!

    case .string:
      return Color(named: "String")!

    case .comment:
      return Color.secondaryLabelColor

    case .identifier:
      return Color(named: "Keyword")!

    case .number:
      return Color(named: "Number")!

    case .editorPlaceholder:
      return Color.labelColor
    }
  }
}

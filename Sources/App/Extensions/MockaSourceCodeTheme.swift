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
      return Color.systemPurple

    case .string:
      return Color.systemRed

    case .comment:
      return Color.secondaryLabelColor

    case .identifier:
      return Color.systemPurple

    case .number:
      return Color.yellow

    case .editorPlaceholder:
      return Color.labelColor
    }
  }
}

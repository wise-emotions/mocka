//
//  Mocka
//

import Sourceful

final class JSONLexer: SourceCodeRegexLexer {
  lazy var generators: [TokenGenerator] = {
    [
      keywordGenerator(["true", "false", "null"], tokenType: .keyword),

      regexGenerator("(-?)(0|[1-9][0-9]*)(\\.[0-9]*)?([eE][+\\-]?[0-9]*)?", tokenType: .number),

      regexGenerator("(\"|@\")[^\"\\n]*(@\"|\")", tokenType: .string),
    ]
    .compactMap { $0 }
  }()

  func generators(source: String) -> [TokenGenerator] {
    return generators
  }
}

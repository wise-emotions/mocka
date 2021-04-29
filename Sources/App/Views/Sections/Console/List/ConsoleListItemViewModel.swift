//
//  Mocka
//

import MockaServer
import SwiftUI

/// The ViewModel of the `LogEventListItem`.
struct ConsoleListItemViewModel {

  // MARK: - Stored Properties

  /// The `LogEvent` displayed by the cell.
  let logEvent: LogEvent

  /// Whether the cell is in an odd index position.
  let isOddCell: Bool

  // MARK: - Computed Properties

  /// The background color of the cell.
  var backgroundColor: Color {
    isOddCell ? Color.lungo : Color.clear
  }

  /// The background color of the circle.
  var circleColor: Color {
    switch logEvent.level {
    case .trace, .debug, .info:
      return Color.irish

    case .notice, .warning:
      return Color.cappuccino

    case .error, .critical:
      return Color.redEye
    }
  }
}

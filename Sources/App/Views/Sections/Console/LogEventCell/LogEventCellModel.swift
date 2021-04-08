import Foundation
import MockaServer
import SwiftUI

/// The `ViewModel` of the `LogEventCell`.
struct LogEventCellModel {

  // MARK: - Constants
  
  /// The `DateFormatter` used to format the date of the `LogEvent`.
  private static let dateFormatter: DateFormatter = {
    let logDateFormatter = DateFormatter()
    logDateFormatter.dateFormat = "dd/MM/yy • HH:mm"
    return logDateFormatter
  }()
  
  // MARK: - Stored Properties
  
  /// The `LogEvent` displayed by the cell.
  let logEvent: LogEvent
  
  /// Whether the cell is in an odd index position.
  let isOddCell: Bool
  
  // MARK: - Computed Properties
  
  /// The background color of the cell.
  var backgroundColor: Color {
    isOddCell ? Color(NSColor.alternatingContentBackgroundColors[1]) :
      Color.clear
  }
  
  /// The background color of the circle.
  var circleColor: Color {
    switch logEvent.level {
    case .trace, .debug, .info:
      return Color.green
      
    case .notice, .warning:
      return Color.yellow
    
    case .error, .critical:
      return Color.red
    }
  }
  
  /// The formatted date of the `LogEvent`.
  var formattedDateText: String {
    LogEventCellModel.dateFormatter.string(from: logEvent.date)
  }
}

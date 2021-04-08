import MockaServer
import SwiftUI

/// The view that displays a `LogEvent`.
struct LogEventListItem: View {
  /// The `ViewModel` of the view.
  let viewModel: LogEventCellModel

  var body: some View {
    HStack(alignment: .center) {
      Circle()
        .fill(viewModel.circleColor)
        .frame(width: 10, height: 10)
        .padding(.leading, 10)

      Text(viewModel.logEvent.level.name)
        .font(.system(size: 12, weight: .bold, design: .default))
        .frame(width: 60, alignment: .leading)
        .foregroundColor(Color.latte)
        .padding(.leading, 24)

      Text(viewModel.formattedDateText)
        .font(.system(size: 16, weight: .regular, design: .default))
        .frame(width: 126)
        .padding(.leading, 40)
        .foregroundColor(Color.macchiato)

      Text(viewModel.logEvent.message)
        .font(.system(size: 16, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 32)
    }
    .padding(.vertical, 12)
    .frame(minHeight: 44)
    .background(viewModel.backgroundColor)
    .cornerRadius(4)
    .padding(.horizontal, 16)
  }
}

struct LogEventCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LogEventListItem(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .debug, message: "Server started\n"),
          isOddCell: false
        )
      )

      LogEventListItem(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .warning, message: "Server started"),
          isOddCell: true
        )
      )

      LogEventListItem(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .error, message: "Server started"),
          isOddCell: false
        )
      )
    }
  }
}

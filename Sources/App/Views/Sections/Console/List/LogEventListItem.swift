//
//  Mocka
//

import MockaServer
import SwiftUI

/// The view that displays a `LogEvent`.
struct LogEventListItem: View {
  /// The `ViewModel` of the view.
  let viewModel: LogEventListItemViewModel

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

      Text(viewModel.logEvent.date.timeIntervalSince1970.timestampPrint)
        .font(.system(size: 16, weight: .regular, design: .default))
        .frame(width: 210)
        .padding(.leading, 40)
        .foregroundColor(Color.macchiato)

      Text(viewModel.logEvent.message)
        .font(.system(size: 16, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 32)
    }
    .frame(minHeight: 26)
    .cornerRadius(5)
    .padding(.vertical, 4)
    .padding(.horizontal, 16)
    .background(viewModel.backgroundColor)
  }
}

struct LogEventListItemPreviews: PreviewProvider {
  static var previews: some View {
    Group {
      LogEventListItem(
        viewModel: LogEventListItemViewModel(
          logEvent: LogEvent(level: .debug, message: "Server started\non 2 lines"),
          isOddCell: false
        )
      )

      LogEventListItem(
        viewModel: LogEventListItemViewModel(
          logEvent: LogEvent(level: .warning, message: "Server started"),
          isOddCell: true
        )
      )

      LogEventListItem(
        viewModel: LogEventListItemViewModel(
          logEvent: LogEvent(level: .error, message: "Server started"),
          isOddCell: false
        )
      )
    }
  }
}

import Server
import SwiftUI

/// The view that displays a `LogEvent`.
struct LogEventCell: View {
  /// The `ViewModel` of the view.
  let viewModel: LogEventCellModel
  
  var body: some View {
    HStack(alignment: .top) {
      Circle()
        .fill(viewModel.circleColor)
        .frame(width: 10, height: 10)
        .padding(.top, 5)
      
      Text(viewModel.logEvent.level.name)
        .font(.system(size: 12))
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color.gray)
        .cornerRadius(10)
        .frame(width: 80)
      
      Divider()
      
      Text(viewModel.formattedDateText)
        .padding(.top, 2)
        .frame(width: 120)
      
      Divider()
      
      Text(viewModel.logEvent.message)
        .padding(.top, 2)
        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

      Spacer()
    }
    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    .foregroundColor(Color(NSColor.textColor))
    .padding(8)
    .background(viewModel.backgroundColor)
    .cornerRadius(8)
  }
}

struct LogEventCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LogEventCell(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .debug, message: "Server started\n\n"),
          isOddCell: false
        )
      )

      LogEventCell(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .warning, message: "Server started"),
          isOddCell: false
        )
      )
      
      LogEventCell(
        viewModel: LogEventCellModel(
          logEvent: LogEvent(level: .error, message: "Server started"),
          isOddCell: false
        )
      )
    }
  }
}

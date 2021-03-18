//
//  LogCell.swift
//  Mocka
//
//  Created by Martino Essuman on 18/03/21.
//

import Server
import SwiftUI

struct LogEventCellModel {
  let logEvent: LogEvent
}

struct LogEventCell: View {
  let viewModel: LogEventCellModel
  
  var body: some View {
    HStack(alignment: .top) {
      Text(viewModel.logEvent.date.description)
        .frame(width: 200)
      Divider()
      Text(viewModel.logEvent.level.name)
        .frame(width: 80)
      Divider()
      Text(viewModel.logEvent.message)
      Spacer()
    }
    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    .foregroundColor(Color(NSColor.textColor))
    .padding(8)
  }
}

struct LogEventCell_Previews: PreviewProvider {
  static var previews: some View {
    LogEventCell(viewModel: LogEventCellModel(logEvent: LogEvent(level: .critical, message: "UEUE'")))
  }
}

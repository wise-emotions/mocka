//
//  ConsoleView.swift
//  Mocka
//
//  Created by Martino Essuman on 18/03/21.
//

import AppKit
import Combine
import Server
import SwiftUI

final class LogListViewModel: ObservableObject {
  var subscriptions = Set<AnyCancellable>()
  @Published var logEvents: [LogEvent] = []
  
  init(consoleLogsPublisher: AnyPublisher<LogEvent, Never>) {
    consoleLogsPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        self?.logEvents.append($0)
      }
      .store(in: &subscriptions)
  }
}

struct LogListView: View {
  @ObservedObject var viewModel: LogListViewModel

  var body: some View {
    List {
      ForEach(Array(viewModel.logEvents.enumerated()), id: \.offset) { index, event in
        LogEventCell(viewModel: LogEventCellModel(logEvent: event))
          .background(index.isMultiple(of: 2) ? Color(NSColor.alternatingContentBackgroundColors[0]) : Color(NSColor.alternatingContentBackgroundColors[1]))
          .cornerRadius(4)
      }
      .listRowInsets(EdgeInsets())
    }
  }
}

struct ConsoleView_Previews: PreviewProvider {
  static let subject = PassthroughSubject<LogEvent, Never>()
  
  static let events = [LogEvent](
    repeating: LogEvent(
      level: .critical,
      message: "Hello"),
    count: 10
  )

  static var previews: some View {
    let viewModel = LogListViewModel(
      consoleLogsPublisher: events.publisher.eraseToAnyPublisher()
    )
    return LogListView(viewModel: viewModel)
  }
}

public extension Subject where Output == LogEvent {
  /// A function that can feed delayed values to a subject for testing and simulation purposes
  func feed(with data: [(TimeInterval, LogEvent)]) {
    var lastDelay: TimeInterval = 0
    for entry in data {
      lastDelay = entry.0
      DispatchQueue.main.asyncAfter(deadline: .now() + entry.0) { [unowned self] in
        self.send(entry.1)
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + lastDelay + 1.5) { [unowned self] in
      self.send(completion: .finished)
    }
  }
}

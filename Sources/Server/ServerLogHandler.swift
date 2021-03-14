import Combine
import Foundation
import Vapor

/// A concrete implementation of `LogHandler` to direct the `Logger` output to a `PassthroughSubject` of `LogEvent`.
internal struct ServerLogHander: LogHandler {

  // MARK: - Properties
  
  /// The `Subject` to which `LogEvent`s are sent.
  internal let subject: PassthroughSubject<LogEvent, Never>

  /// The `logLevel` is set to `.trace` to track all events.
  internal var logLevel: Logger.Level = .trace
  
  internal var metadata: Logger.Metadata = [:]

  // MARK: - Functions
  
  internal subscript(metadataKey key: String) -> Logger.Metadata.Value? {
    get {
      metadata[key]
    }
    
    set {
      metadata[key] = newValue
    }
  }
  
  internal func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
    subject.send(LogEvent(level: LogEvent.Level(vaporLoggerLevel: level), message: message.description))
  }
}

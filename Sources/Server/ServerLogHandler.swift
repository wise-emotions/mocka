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
  
  /// The dictionary of metadata that are relevant to all logs.
  /// - Note: These metadata should be merged to the ones related to the single log.
  internal var metadata: Logger.Metadata = [:]

  // MARK: - Functions
  
  /// This method is called when a `LogHandler` must emit a log message. There is no need for the `LogHandler` to
  /// check if the `level` is above or below the configured `logLevel` as `Logger` already performed this check and
  /// determined that a message should be logged.
  /// - parameters:
  ///     - level: The log level the message was logged at.
  ///     - message: The message to log. To obtain a `String` representation call `message.description`.
  ///     - metadata: The metadata associated to this log message.
  ///     - source: The source where the log message originated, for example the logging module.
  ///     - file: The file the log message was emitted from.
  ///     - function: The function the log line was emitted from.
  ///     - line: The line the log message was emitted from.
  internal func log(
    level: Logger.Level,
    message: Logger.Message,
    metadata: Logger.Metadata?,
    source: String,
    file: String,
    function: String,
    line: UInt
  ) {
    subject.send(LogEvent(level: LogEvent.Level(vaporLoggerLevel: level), message: message.description))
  }
}

extension ServerLogHander {
  /// Accesses the `metadata` dictionary using a key.
  /// This subscript is required to conform to `LogHandler` protocol.
  internal subscript(metadataKey key: String) -> Logger.Metadata.Value? {
    get {
      metadata[key]
    }

    set {
      metadata[key] = newValue
    }
  }
}

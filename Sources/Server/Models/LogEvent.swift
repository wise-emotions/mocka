import Foundation
import Vapor

/// An object that represents a log event.
public struct LogEvent {
  /// The level of the log event.
  public let level: Level

  /// The message describing the log event.
  public let message: String

  /// The date when the event occurred.
  public let date: Date

  /// Creates an instance of `LogEvent`.
  /// - Parameters:
  ///   - level: The level of the log.
  ///   - message: The message of the log.
  public init(level: LogEvent.Level, message: String) {
    self.level = level
    self.message = message
    self.date = Date()
  }
}

public extension LogEvent {
  /// The log level.
  enum Level {
    /// Appropriate for messages that contain information normally of use only when tracing the execution of a program.
    case trace

    /// Appropriate for messages that contain information normally of use only when debugging a program.
    case debug

    /// Appropriate for informational messages.
    case info

    /// Appropriate for conditions that are not error conditions, but that may require special handling.
    case notice

    /// Appropriate for messages that are not error conditions, but more severe than `.notice`.
    case warning

    /// Appropriate for error conditions.
    case error

    /// Appropriate for critical error conditions that usually require immediate attention.
    case critical

    /// The name of the level.
    var name: String {
      switch self {
      case .trace:
        return "TRACE"

      case .debug:
        return "DEBUG"

      case .info:
        return "INFO"

      case .notice:
        return "NOTICE"

      case .warning:
        return "WARNING"

      case .error:
        return "ERROR"

      case .critical:
        return "CRITICAL"
      }
    }

    /// Initializes the level using the Vapor's `Logger.Level`.
    /// - Parameter loggerLevel: The logger level returned by Vapor.
    internal init(loggerLevel: Logger.Level) {
      switch loggerLevel {
      case .trace:
        self = .trace

      case .debug:
        self = .debug

      case .info:
        self = .info

      case .notice:
        self = .notice

      case .warning:
        self = .warning

      case .error:
        self = .error

      case .critical:
        self = .critical
      }
    }
  }
}

import Foundation
import Vapor

/// An object that represents a log event.
public struct LogEvent {
  /// The log level.
  public enum Level {
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
    
    /// Initializes the level using the Vapor's `Logger.Level`.
    /// - Parameter vaporLoggerLevel: The logger level returned by Vapor.
    init(vaporLoggerLevel: Logger.Level) {
      switch vaporLoggerLevel {
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
  
  /// The level of the log event.
  public let level: Level
  
  /// The message describing the log event.
  public let message: String
}

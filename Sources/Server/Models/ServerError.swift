import Foundation

/// A list of custom errors that the `AppServer` can throw.
public enum ServerError: Error {
  /// A server instance is already running while trying to start a new one.
  case instanceAlreadyRunning

  /// An error thrown by `Vapor`.
  case vapor(error: Error)
}

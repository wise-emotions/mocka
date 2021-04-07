import Combine
import Foundation

/// This `Subject` allows to buffer sent values.
/// Buffered values are sent when a subscriber subscribes to it.
/// Then it behaves like a normal `PassthroughSubject`, broadcasting elements to downstream subscribers.
public class BufferedSubject<Output, Failure: Error> {

  // MARK: - Stored Properties

  /// The `PassthroughSubject` that backs up the `BufferedSubject`.
  private let passthroughSubject = PassthroughSubject<Output, Failure>()

  /// The buffer containing sent values.
  private var buffer: [Output]

  /// The max size of the buffer.
  /// This dictates the maximum number of elements to include in the buffer.
  private let bufferSize: Int

  // MARK: - Init

  /// Creates an instance of `BufferedSubject`.
  /// - Parameter bufferSize: The buffer size. Defaults to `.max`.
  /// - Note: A huge buffer size could
  public init(bufferSize: Int = .max) {
    self.bufferSize = bufferSize
    self.buffer = []
  }

  // MARK: - Functions

  /// Clears the buffer.
  public func clearBuffer() {
    buffer.removeAll()
  }
}

extension BufferedSubject: Subject {
  /// Attaches the specified subscriber to this publisher.
  /// - Parameter subscriber: The subscriber to attach to this `Subject`, after which it can receive values.
  public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    passthroughSubject.subscribe(subscriber)
    buffer.forEach {
      _ = subscriber.receive($0)
    }
  }

  /// Sends a value to the subscriber.
  /// - Parameter value: The value to send.
  public func send(_ value: Output) {
    if buffer.count > bufferSize - 1 {
      buffer.remove(at: 0)
    }

    buffer.append(value)
    passthroughSubject.send(value)
  }

  /// Sends a completion signal to the subscriber.
  /// - Parameter completion: A Completion instance which indicates whether publishing has finished normally or failed with an error.
  public func send(completion: Subscribers.Completion<Failure>) {
    passthroughSubject.send(completion: completion)
  }

  /// Sends a subscription to the subscriber.
  /// - Parameter subscription: The subscription instance through which the subscriber can request elements.
  public func send(subscription: Subscription) {
    passthroughSubject.send(subscription: subscription)
  }
}

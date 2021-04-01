import Combine
import Foundation

/// This `Subject` allows to buffer sent values.
/// Buffered values are sent when a subscriber subscribes to it.
class BufferedSubject<Output, Failure: Error>: Subject {
  let passthroughSubject = PassthroughSubject<Output, Failure>()
  
  var buffer: [Output]
  
  let bufferSize: Int
  
  init(bufferSize: Int = .max) {
    self.bufferSize = bufferSize
    self.buffer = []
  }
  
  func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
    passthroughSubject.subscribe(subscriber)
    buffer.forEach {
      _ = subscriber.receive($0)
    }
  }
  
  func send(_ value: Output) {
    if buffer.count > bufferSize {
      buffer.remove(at: 0)
    }
    buffer.append(value)
    passthroughSubject.send(value)
  }
  
  func send(completion: Subscribers.Completion<Failure>) {
    passthroughSubject.send(completion: completion)
  }
  
  func send(subscription: Subscription) {
    passthroughSubject.send(subscription: subscription)
  }
}

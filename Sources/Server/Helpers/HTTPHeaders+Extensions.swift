import Foundation

internal extension HTTPHeaders {
  /// Adds or replaces a value to the `HTTPHeaders`.
  /// - Parameters:
  ///   - name: The header field name.
  ///   - value: The header field value to add for the given name.
  /// - Returns: The same `HTTPHeaders` after replacing or adding the passed values.
  func replacingOrAdding(name: String, value: String) -> HTTPHeaders {
    var headers = self
    headers.replaceOrAdd(name: name, value: value)
    return headers
  }

  /// Removes a value to the `HTTPHeaders`.
  /// - Parameter name: The header name field to remove.
  /// - Returns: The same `HTTPHeaders` after removing the value associated with the passed name.
  func removing(name: String) -> HTTPHeaders {
    var headers = self
    headers.remove(name: name)
    return headers
  }
}

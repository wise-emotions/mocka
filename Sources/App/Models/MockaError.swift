//
//  Mocka
//

import Foundation

/// A list of errors that can be thrown inside of `Mocka` app.
enum MockaError: Error {
  /// The root path value is missing when it's expected to be populated.
  case missingRootPathValue

  /// The root path does not exist.
  case rootPathDoesNotExist

  /// The root path does not point to a folder.
  case rootPathNotFolder

  /// The root path does not contain scheme.
  case rootPathMissingScheme

  /// An error occurred when trying to encode a file.
  case failedToEncode
}

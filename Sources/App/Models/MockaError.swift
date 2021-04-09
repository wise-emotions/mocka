//
//  Mocka
//

import Foundation

/// A list of errors that can be thrown inside of `Mocka` app.
enum MockaError: Error {
  /// The workspace path value is missing when it's expected to be populated.
  case missingWorkspacePathValue

  /// The workspace path does not exist.
  case workspacePathDoesNotExist

  /// The workspace path does not point to a folder.
  case workspacePathNotFolder

  /// The workspace path does not contain scheme.
  case workspacePathMissingScheme

  /// An error occurred when trying to encode a file.
  case failedToEncode
}

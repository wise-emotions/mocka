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

  /// Could not create directory at request path.
  /// The path is passed included with the error.
  case failedToCreateDirectory(path: String)

  /// Could not delete directory at request path.
  /// The path is passed included with the error.
  case failedToDeleteDirectory(path: String)

  /// Failed to write a string at a path.
  /// The content and the path are included with the error.
  case failedToWriteToFile(content: String, path: String)

  /// Failed to rename a directory.
  /// The path and the name are included with the error.
  case failedToRenameDirectory(path: String, name: String)
}

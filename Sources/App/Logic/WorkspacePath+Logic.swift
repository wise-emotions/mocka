//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to the workspace path where all the requests and responses live.
  enum WorkspacePath {}
}

extension Logic.WorkspacePath {
  /// Checks if a folder exists in the given `url`.
  /// Creates the folder if it does not exist.
  /// - Parameter url: The new `URL` of the workspace path.
  ///                  The `URL` should contain a scheme.
  ///                  It is recommended to instantiate the `URL` using `URL(fileURLWithPath:)`.
  /// - Throws: `MockaError.failedToUnwrapURL`,
  ///           `MockaError.workspacePathMissingScheme`,
  ///           `MockaError.failedToCreateDirectory(path:)`,
  ///           `MockaError.workspacePathNotFolder`,
  static func checkURLAndCreateFolderIfNeeded(at url: URL?) throws {
    guard let unwrappedURL = url else {
      throw MockaError.failedToUnwrapURL
    }

    guard unwrappedURL.scheme != nil else {
      throw MockaError.workspacePathMissingScheme
    }

    if Self.resourceExists(at: unwrappedURL).isFalse {
      // Try to create the folder if it does not exist.
      do {
        try Self.createFolder(at: unwrappedURL.path)
      } catch {
        throw MockaError.failedToCreateDirectory(path: unwrappedURL.path)
      }
    }

    guard Self.uniformType(of: unwrappedURL) == UTType.folder else {
      throw MockaError.workspacePathNotFolder
    }
  }
}

private extension Logic.WorkspacePath {
  /// Create a folder in the given path.
  /// - Parameter path: The path in wich we want the folder.
  /// - Throws: `MockaError.failedToCreateDirectory(path:)`.
  static func createFolder(at path: String) throws {
    do {
      try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    } catch {
      throw MockaError.failedToCreateDirectory(path: path)
    }
  }

  /// Checks if a resource exists at a given `URL`'s path.
  /// - Parameter url: The `URL` of the resource.
  /// - Returns: Returns `true` if the resource is a folder, otherwise `false`.
  static func resourceExists(at url: URL) -> Bool {
    FileManager.default.fileExists(atPath: url.path)
  }

  /// Fetches the `UTType` of the passed `URL`.
  /// - Parameter path: The `URL` of the resource.
  /// - Returns: Returns the `UTType` of the given resource if available, otherwise `nil`.
  private static func uniformType(of url: URL) -> UTType? {
    try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
  }
}

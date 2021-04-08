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
  /// Check if the `url` exists.
  /// - Parameter url: The new `URL` of the workspace path.
  ///                  The `URL` should contain a scheme.
  ///                  It is recommended to instantiate the `URL` using `URL(fileURLWithPath:)`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`,
  ///           `MockaError.workspacePathNotFolder`,
  ///           `MockaError.workspacePathMissingScheme`,
  ///           `MockaError.failedToEncode`.
  static func isFolder(_ url: URL?) throws {
    guard let unwrappedURL = url else {
      throw MockaError.workspacePathDoesNotExist
    }

    guard unwrappedURL.scheme != nil else {
      throw MockaError.workspacePathMissingScheme
    }

    guard Self.resourceExists(at: unwrappedURL) else {
      throw MockaError.workspacePathDoesNotExist
    }

    guard Self.uniformType(of: unwrappedURL) == UTType.folder else {
      throw MockaError.workspacePathNotFolder
    }
  }
}

private extension Logic.WorkspacePath {
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

//
//  Mocka
//

import Foundation
import MockaServer
import SwiftUI
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to the root path where all the requests and responses live.
  enum RootPath {}
}

extension Logic.RootPath {
  /// The name of the file containing the server's configuration.
  private static let serverConfigurationFileName = "serverConfiguration.json"

  /// The `UTType` of a folder.
  private static let folderUniformTypeIdentifier = UTType("public.folder")

  /// The `UTType` of a json file.
  private static let JSONUniformTypeIdentifier = UTType("public.json")

  /// The value of the root path.
  /// When this value is updated, the value in the user defaults is updated as well.
  /// To update this value use `set(_ url:)`.
  @AppStorage(UserDefaultKey.rootPath) private(set) static var value: URL?

  /// Checks if the root path is set in the `UserDefaults`.
  static var isRootPathSet: Bool {
    value != nil
  }

  /// Sets the `value` for the `RootPath`.
  /// - Parameter url: The new `URL` of the root path.
  /// - Throws: `MockaError.rootPathDoesNotExist`,
  ///           `MockaError.rootPathNotFolder`,
  ///           `MockaError.rootPathMissingScheme`,
  ///           `MockaError.failedToEncode`.
  ///
  /// The `URL` should contain a scheme. It is recommended to instantiate the `URL` using `URL(fileURLWithPath:)`.
  static func set(_ url: URL?) throws {
    guard let unwrappedURL = url else {
      Self.value = nil
      return
    }

    guard unwrappedURL.scheme != nil else {
      throw MockaError.rootPathMissingScheme
    }

    guard Self.resourceExists(at: unwrappedURL) else {
      throw MockaError.rootPathDoesNotExist
    }

    guard Self.isFolder(at: unwrappedURL) else {
      throw MockaError.rootPathNotFolder
    }

    guard Self.serverConfigurationFileExists(at: unwrappedURL) else {
      try Self.addDefaultServerConfigurationFile(at: unwrappedURL)
      return
    }
  }
}

private extension Logic.RootPath {
  /// Checks if a resource exists at a given `URL`'s path.
  /// - Parameter url: The `URL` of the resource.
  /// - Returns: Returns `true` if the resource is a folder, otherwise `false`.
  static func resourceExists(at url: URL) -> Bool {
    FileManager.default.fileExists(atPath: url.path)
  }

  /// Checks if the passed `URL` belongs to a resource of `UTType` `public.folder`
  /// - Parameter url: The `URL` of the resource.
  /// - Returns: Returns `true` if the resource is a folder, otherwise `false`.
  static func isFolder(at url: URL) -> Bool {
    Self.uniformType(of: url) == Self.folderUniformTypeIdentifier
  }

  /// Checks if the passed path includes a server configuration file.
  /// - Parameter path: The `URL` where the configuration file is present.
  /// - Returns: Returns `true` if the server configuration file exist, otherwise `false`.
  static func serverConfigurationFileExists(at url: URL) -> Bool {
    let fullPath = url.appendingPathComponent(Self.serverConfigurationFileName, isDirectory: false)
    return FileManager.default.fileExists(atPath: fullPath.path) && Self.uniformType(of: fullPath) == Self.JSONUniformTypeIdentifier
  }

  /// Adds a `serverConfiguration.json` file to the url passed with the encoded content of `ServerConnectionConfiguration`.
  /// - Parameter url: The `URL` of the directory where to include the server configuration file.
  /// - Throws: `MockaError.failedToEncode`
  static func addDefaultServerConfigurationFile(at url: URL) throws {
    let configuration = ServerConnectionConfiguration()

    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(configuration)

      guard let string = String(data: data, encoding: .utf8) else {
        throw MockaError.failedToEncode
      }

      let filePath = url.appendingPathComponent(Self.serverConfigurationFileName, isDirectory: false)
      try string.write(toFile: filePath.path, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      throw MockaError.failedToEncode
    }
  }

  /// Fetches the `UTType` of the passed `URL`.
  /// - Parameter path: The `URL` of the resource.
  /// - Returns: Returns the `UTType` of the given resource if available, otherwise `nil`.
  private static func uniformType(of url: URL) -> UTType? {
    try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
  }
}

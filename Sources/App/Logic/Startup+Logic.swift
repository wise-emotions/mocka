//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to startup of the app.
  enum Startup {}
}

extension Logic.Startup {
  /// The name of the file containing the server's configuration.
  private static let serverConfigurationFileName = "serverConfiguration.json"

  /// The `UTType` of a json file.
  private static let JSONUniformTypeIdentifier = UTType("public.json")

  static func createConfiguration(for url: URL?) throws {
    guard let unwrappedURL = url else {
      throw MockaError.workspacePathDoesNotExist
    }

    guard Self.serverConfigurationFileExists(at: unwrappedURL) else {
      try Self.addDefaultServerConfigurationFile(at: unwrappedURL)
      return
    }
  }
}

private extension Logic.Startup {
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

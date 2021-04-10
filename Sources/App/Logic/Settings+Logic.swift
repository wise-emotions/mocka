//
//  Mocka
//

import Foundation
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to settings of the app.
  enum Settings {
    /// The name of the file containing the server's configuration.
    static let serverConfigurationFileName = "serverConfiguration.json"

    /// Checks if the workspace `URL` saved in the `UserDefaults` is valid.
    /// That is, it is not nil, it exists, and it contains the `serverConfiguration.json` file.
    static var isWorkspaceURLValid: Bool {
      guard let savedWorkspaceURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) else {
        return false
      }

      return
        FileManager.default.fileExists(atPath: savedWorkspaceURL.path)
        && uniformType(of: savedWorkspaceURL) == UTType.folder
        && serverConfigurationFileExists(at: savedWorkspaceURL)
    }

    /// The server configuration.
    ///
    /// This variable extracts the hostname and port of the server from the `serverConfigurationFileName`.
    /// In addition, it tries to fetch all the requests from the workspace path.
    /// Should either of the two steps fail, it returns nil.
    static var serverConfiguration: ServerConfiguration? {
      guard
        let workspaceURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL),
        let settingsFileData = FileManager.default.contents(
          atPath: workspaceURL.appendingPathComponent(serverConfigurationFileName, isDirectory: false).path
        ),
        let serverConfiguration = try? JSONDecoder().decode(ServerConnectionConfiguration.self, from: settingsFileData),
        let requests = try? Logic.SourceTree.requests()
      else {
        return nil
      }

      return ServerConfiguration(hostname: serverConfiguration.hostname, port: serverConfiguration.port, requests: requests)
    }
  }
}

extension Logic.Settings {

  /// Updates the server configuration file or creates it at the workspace root folder.
  /// - Throws: `MockaError.workspacePathDoesNotExist`,
  ///           `MockaError.failedToEncode`.
  /// - Parameter configuration: The `ServerConnectionConfiguration` value to write to the file.
  static func updateServerConfigurationFile(_ configuration: ServerConnectionConfiguration) throws {
    guard let unwrappedURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) else {
      throw MockaError.workspacePathDoesNotExist
    }

    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(configuration)

      guard let string = String(data: data, encoding: .utf8) else {
        throw MockaError.failedToEncode
      }

      let filePath = unwrappedURL.appendingPathComponent(serverConfigurationFileName, isDirectory: false)
      try string.write(toFile: filePath.path, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      throw MockaError.failedToEncode
    }
  }

  /// Handle the folder selection by using the `fileImporter`.
  /// - Parameter result: The `URL` selected by the `fileImporter`.
  /// - Returns: Returns the selected path as `String`.
  static func selectFolder(from result: Result<[URL], Error>) -> String? {
    guard
      let selectedFolder = try? result.get().first,
      selectedFolder.startAccessingSecurityScopedResource()
    else {
      return nil
    }

    selectedFolder.stopAccessingSecurityScopedResource()
    return selectedFolder.path
  }
}

private extension Logic.Settings {
  /// Checks if the passed path includes a server configuration file.
  /// - Parameter path: The `URL` where the configuration file is present.
  /// - Returns: Returns `true` if the server configuration file exist, otherwise `false`.
  static func serverConfigurationFileExists(at url: URL) -> Bool {
    let fullPath = url.appendingPathComponent(serverConfigurationFileName, isDirectory: false)
    return FileManager.default.fileExists(atPath: fullPath.path) && uniformType(of: fullPath) == UTType.json
  }

  /// Fetches the `UTType` of the passed `URL`.
  /// - Parameter path: The `URL` of the resource.
  /// - Returns: Returns the `UTType` of the given resource if available, otherwise `nil`.
  static func uniformType(of url: URL) -> UTType? {
    try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
  }
}

//
//  Mocka
//

import Foundation
import MockaServer
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to the source tree starting at the root path and containing all the requests and responses.
  enum SourceTree {
    /// The resource keys for the infos to extract from a `URL`.
    /// `.nameKey` returns the name of the file.
    /// `.contentTypeKey` returns the type of the file. Example "public.json".
    private static let resourceKeys: Set<URLResourceKey> = [.nameKey, .contentTypeKey]

    /// The allowed name for a file containing a request.
    private static let allowedRequestFileName = "request.json"

    /// The regex the name of the folder should match to be allowed in the tree.
    private static var folderNameRegex: String {
      let allSupportedMethods = HTTPMethod.allCases
        .map {
          $0.rawValue
        }
        .joined(separator: "|")

      return "(\(allSupportedMethods)) - .*"
    }

    /// The  root file system node.
    static var rootFileSystemNode: FileSystemNode {
      let workspaceURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL)!
      let allSubNodes = contents(of: workspaceURL)

      return FileSystemNode(name: "Workspace Root", url: workspaceURL, kind: .folder(children: allSubNodes, isRequestFolder: false))
    }
  }
}

// MARK: - Functions

extension Logic.SourceTree {
  /// - Returns: The source tree starting with the workspace root containing all sub-nodes.
  static func sourceTree() -> FileSystemNode {
    let workspaceURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL)!
    let allSubNodes = contents(of: workspaceURL)

    return FileSystemNode(name: "Workspace Root", url: workspaceURL, kind: .folder(children: allSubNodes, isRequestFolder: false))
  }

  /// Fetches all the requests under the root workspace `URL`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`
  /// - Returns: A `Set` containing all the found requests.
  static func requests() throws -> Set<MockaServer.Request> {
    guard let rootPath = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) else {
      throw MockaError.workspacePathDoesNotExist
    }

    return contents(of: rootPath)
      .reduce(into: Set<MockaServer.Request>()) { result, node in
        allRequests(in: node)
          .map {
            $0.request.mockaRequest(withResponseAt: $0.request.hasResponseBody ? $0.location : nil)
          }
          .forEach {
            result.insert($0)
          }
      }
  }

  /// The list of all folders used as a namespace in all of the workspace.
  static func namespaceFolders(in parent: FileSystemNode) -> [FileSystemNode] {
    parent
      .children?
      .reduce(into: namespaceFolders(node: parent)) { result, node in
        namespaceFolders(node: node)
          .forEach {
            guard result.contains($0).isFalse else {
              return
            }

            result.append($0)
          }
      }
    ?? [parent]
  }

  /// Adds a directory while creating intermediate directories.
  /// - Throws: `MockaError.failedToCreateDirectory`
  /// - Parameters:
  ///   - url: The `URL` of the hosting directory.
  ///   - named: The name of the new directory.
  static func addDirectory(at url: URL, named: String) throws {
    do {
      try FileManager.default.createDirectory(atPath: url.appendingPathComponent(named).path, withIntermediateDirectories: false, attributes: nil)
    } catch {
      throw MockaError.failedToCreateDirectory(path: url.appendingPathComponent(named).path)
    }
  }

  /// Adds a directory while creating intermediate directories.
  /// - Parameter path: The path where to create that directory.
  /// - Throws: `MockaError.failedToDeleteDirectory`
  static func deleteDirectory(at path: String) throws {
    do {
      try FileManager.default.removeItem(atPath: path)
    } catch {
      throw MockaError.failedToDeleteDirectory(path: path)
    }
  }

  /// Encodes the request and pretty prints it to a `request.json` file at a give url.
  /// - Parameters:
  ///   - request: The request to encode.
  ///   - url: The `URL` where to save the file.
  /// - Throws: `MockaError.failedToEncode` and `MockaError.failedToWriteToFile`.
  static func addRequest(_ request: Request, to url: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    var content: String!

    do {
      let data = try encoder.encode(request)
      content = String(data: data, encoding: .utf8)
    } catch {
      throw MockaError.failedToEncode
    }

    do {
      try content.write(to: url.appendingPathComponent("request.json"), atomically: false, encoding: .utf8)
    } catch {
      throw MockaError.failedToWriteToFile(content: content, path: url.appendingPathComponent("request.json").path)
    }
  }

  /// Writes the response to a file with the proper extension to a url.
  /// - Parameters:
  ///   - response: The string of the response.
  ///   - extension: The extension with which to save the response file.
  ///   - url: the `URL` where to save the file.
  /// - Throws: `MockaError.failedToWriteToFile`.
  static func addResponse(_ response: String, ofType extension: String, to url: URL) throws {
    do {
      try response.write(to: url.appendingPathComponent("response.\(`extension`)"), atomically: false, encoding: .utf8)
    } catch {
      throw MockaError.failedToWriteToFile(content: response, path: url.appendingPathComponent("response.\(`extension`)").path)
    }
  }

  /// Extracts the content of a file at a given `URL`.
  /// Should the extraction encounter any problem, `nil` is returned.
  /// - Parameter url: The `URL` of the file.
  /// - Returns: The content of the file as a `.utf8` `String` if found, otherwise `nil`.
  static func content(of url: URL) -> String? {
    guard let data = FileManager.default.contents(atPath: url.path) else {
      return nil
    }

    return String(data: data, encoding: .utf8)
  }

  /// Enumerates the contents of a directory.
  /// - Parameter url: The `URL` of the directory to scan.
  /// - Returns: An array of `FileSystemNode` containing all sub-nodes of the directory.
  private static func contents(of url: URL) -> [FileSystemNode] {
    guard
      let directoryEnumerator = FileManager.default.enumerator(
        at: url,
        includingPropertiesForKeys: Array(resourceKeys),
        options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
      )
    else {
      return []
    }

    return directoryEnumerator.reduce(into: [FileSystemNode]()) {
      guard let url = $1 as? URL, let node = node(at: url) else {
        return
      }

      $0.append(node)
    }
  }

  /// The list of all folders used as a namespace inside a specific node.
  /// - Parameter node: The node to look up its content.
  /// - Returns: An array of all found nodes.
  private static func namespaceFolders(node: FileSystemNode) -> [FileSystemNode] {
    var folders: [FileSystemNode] = []

    switch node.kind {
    case let .folder(children, isRequestFolder):
      if isRequestFolder {
        break
      }

      folders.append(node)

      children.forEach {
        folders.append(contentsOf: namespaceFolders(in: $0))
      }

    case .requestFile:
      break
    }

    return folders
  }

  /// Recursively looks up all the `Request`s in a `FileSystemNode` and its children.
  /// - Parameter node: The root `FileSystemNode`.
  /// - Returns: An array containing all the found requests.
  private static func allRequests(in node: FileSystemNode) -> [(request: Request, location: URL)] {
    var requests: [(request: Request, location: URL)] = []

    switch node.kind {
    case let .folder(children, _):
      children.forEach {
        requests.append(contentsOf: allRequests(in: $0))
      }

    case let .requestFile(request):
      requests.append((request, node.url.deletingLastPathComponent()))
    }

    return requests
  }

  /// Gets the filesystem node at the specified `URL`.
  /// - Parameter url: The `URL` of the node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`.
  private static func node(at url: URL) -> FileSystemNode? {
    guard let (name, contentType) = resourceValues(for: url) else {
      return nil
    }

    if contentType == .folder {
      return folderNode(for: url)
    } else if let request = requestFile(at: url) {
      return FileSystemNode(name: name, url: url, kind: .requestFile(request))
    } else {
      return nil
    }
  }

  /// Creates the node for a folder, provided that the `URL` points to a valid folder.
  /// - Parameter url: The `URL` of the folder node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`.
  ///            `nil` if the `URL` doesn't point to a folder or the folder is not valid.
  private static func folderNode(for url: URL) -> FileSystemNode? {
    guard let (name, contentType) = resourceValues(for: url), contentType == .folder else {
      return nil
    }

    let children = contents(of: url)

    // If the folder contains other folder, return the node.
    if children.contains(where: { $0.isFolder }) {
      return FileSystemNode(name: name, url: url, kind: .folder(children: children, isRequestFolder: false))
    } else {
      // Check if the folder name is sound. If not, return nil.
      // Check if the folder contains at least a request. If not, return nil.
      // Some folders can contain no response.
      if name.matchesRegex(folderNameRegex) {
        guard let request = children.first(where: { $0.name == allowedRequestFileName }) else {
          return nil
        }

        return FileSystemNode(name: name, url: url, kind: .folder(children: [request], isRequestFolder: true))
      } else {
        return FileSystemNode(name: name, url: url, kind: .folder(children: [], isRequestFolder: false))
      }
    }
  }

  /// Returns informations about the specified `URL`.
  /// - Parameter url: The `URL` to retrieve information from.
  /// - Returns: A tuple containing the name of the directory or file and the `UTType` of the file or folder.
  private static func resourceValues(for url: URL) -> (name: String, contentType: UTType)? {
    guard
      let resourceValues = try? url.resourceValues(forKeys: resourceKeys),
      let name = resourceValues.name,
      let contentType = resourceValues.contentType
    else {
      return nil
    }

    return (name, contentType)
  }

  /// Decodes the contents of the file at the specified `URL` as a `MockaApp.Request`, and validates it.
  /// If the content of the file at the specified `URL` fails to decode, or does not pass validity checks,
  /// the function will return nil.
  /// - Parameter url: The `url` from which to extract the path.
  /// - Returns: A `MockaApp.Request` if found and is valid, otherwise nil.
  private static func requestFile(at url: URL) -> Request? {
    // Extract the data of the file.
    guard
      let data = FileManager.default.contents(atPath: url.path),
      let request = try? JSONDecoder().decode(Request.self, from: data)
    else {
      return nil
    }

    if HTTPResponseStatus(statusCode: request.expectedResponse.statusCode).mayHaveResponseBody == false {
      // If the status code does not support a body, there should be no file associated with the request.
      // Otherwise we consider the request corrupt.
      guard request.expectedResponse.contentType == .none, request.expectedResponse.fileName == nil else {
        return nil
      }
    }

    // If the content type has an expected file extension, that is, is associated to a body content,
    // we make sure that the response file with the correct extension exists.
    if let fileExtension = request.expectedResponse.contentType.expectedFileExtension {
      let responseFileName = "response.\(fileExtension)"

      guard
        request.expectedResponse.fileName == responseFileName,
        FileManager.default.fileExists(atPath: url.deletingLastPathComponent().appendingPathComponent(responseFileName).path)
      else {
        return nil
      }
    }

    return request
  }
}

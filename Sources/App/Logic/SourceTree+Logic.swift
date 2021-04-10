//
//  Mocka
//

import Foundation
import MockaServer
import UniformTypeIdentifiers

extension Logic {
  /// The logic related to the source tree starting at the root path and containing all the requests and responses.
  struct SourceTree {
    /// The resource keys for the infos to extract from a `URL`.
    /// `.nameKey` returns the name of the file.
    /// `.contentTypeKey` returns the type of the file. Example "public.json".
    private let resourceKeys: Set<URLResourceKey> = [.nameKey, .contentTypeKey]

    /// The allowed name for a file containing a request.
    private let allowedRequestFileName = "request.json"

    /// The regex the name of the folder should match to be allowed in the tree.
    private var folderNameRegex: String {
      let allSupportedMethods = HTTPMethod.allCases
        .map {
          $0.rawValue
        }
        .joined(separator: "|")

      return "(\(allSupportedMethods)) - .*"
    }
  }
}

// MARK: - Functions

extension Logic.SourceTree {
  /// Enumerates the contents of a directory.
  /// - Parameter url: The `URL` of the directory to scan.
  /// - Returns: An array of `FileSystemNode` containing all sub-nodes of the directory.
  func contents(of url: URL) -> [FileSystemNode] {
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

  /// Fetches all the requests under the root workspace `URL`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`
  /// - Returns: A `Set` containing all the found requests.
  func requests() throws -> Set<MockaServer.Request> {
    guard let rootPath = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL) else {
      throw MockaError.workspacePathDoesNotExist
    }

    return contents(of: rootPath)
      .reduce(into: Set<MockaServer.Request>()) { result, node in
        allRequests(in: node)
          .map {
            $0.mockaRequest(withResponseAt: node.url)
          }
          .forEach {
            result.insert($0)
          }
      }
  }

  /// Recursively looks up all the `Request`s in a `FileSystemNode` and its children.
  /// - Parameter node: The root `FileSystemNode`.
  /// - Returns: An array containing all the found requests.
  private func allRequests(in node: FileSystemNode) -> [Request] {
    var requests: [Request] = []

    switch node.kind {
    case let .folder(children):
      for child in children {
        requests.append(contentsOf: allRequests(in: child))
      }

    case let .requestFile(request):
      requests.append(request)
    }

    return requests
  }

  /// Gets the filesystem node at the specified `URL`.
  /// - Parameter url: The `URL` of the node to retrieve.
  /// - Returns: A `FileSystemNode` representing the node at the specified `URL`.
  private func node(at url: URL) -> FileSystemNode? {
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
  private func folderNode(for url: URL) -> FileSystemNode? {
    guard let (name, contentType) = resourceValues(for: url), contentType == .folder else {
      return nil
    }

    let children = contents(of: url)

    // If the folder contains other folder, return the node.
    if children.contains(where: { $0.isFolder }) {
      return FileSystemNode(name: name, url: url, kind: .folder(children: children))
    } else {
      // Check if the folder name is sound. If not, return nil.
      // Check if the folder contains at least a request. If not, return nil.
      // Some folders can contain no response.
      guard
        name.matchesRegex(folderNameRegex),
        let request = children.first(where: { $0.name == allowedRequestFileName })
      else {
        return nil
      }

      return FileSystemNode(name: name, url: url, kind: .folder(children: [request]))
    }
  }

  /// Returns informations about the specified `URL`.
  /// - Parameter url: The `URL` to retrieve information from.
  /// - Returns: A tuple containing the name of the directory or file and the `UTType` of the file or folder.
  private func resourceValues(for url: URL) -> (name: String, contentType: UTType)? {
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
  private func requestFile(at url: URL) -> Request? {
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
      guard request.expectedResponse.contentType.isAny(of: [.custom, .none]), request.expectedResponse.fileName == nil else {
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

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
    
    /// The allowed name for a file containing a response.
    private static let allowedResponseFileName = "response.json"

    /// The regex the name of the folder should match to be allowed in the tree.
    private static var folderNameRegex: String {
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
  /// Computes the source tree starting with the workspace root containing all sub-nodes.
  /// - Returns: The source tree starting with the workspace root containing all sub-nodes.
  static func sourceTree() -> Node.NamespaceFolder {
    let workspaceURL = UserDefaults.standard.url(forKey: UserDefaultKey.workspaceURL)!
    let children = nodes(at: workspaceURL)

    return Node.NamespaceFolder(
      name: "Workspace Root",
      url: workspaceURL,
      namespaces: children.filter { $0.kind == .folder } as? [Node.NamespaceFolder] ?? [],
      requests: children.filter { $0.kind == .requestFolder } as? [Node.RequestFolder] ?? []
    )
  }
  
  /// The list of all the nodes at a given address.
  /// - Parameter url: The address to explore.
  /// - Returns: The array of all the found nodes.
  static func nodes(at url: URL) -> [FileSystemNode] {
    guard let enumeratedContent = Self.enumerateDirectory(at: url) else {
      return []
    }
    
    return enumeratedContent.reduce(into: [FileSystemNode]()) {
      guard let url = $1 as? URL, let node = node(at: url) else {
        return
      }

      $0.append(node)
    }
  }
  
  /// Returns the `Node` equivalent of an object at a given `URL`.
  /// - Parameter url: The URL of the object.
  /// - Returns: A `FileSystemNode` is the object is valid, otherwise `nil`.
  private static func node(at url: URL) -> FileSystemNode? {
    guard let kind = nodeKind(at: url) else {
      return nil
    }
    
    switch kind {
    case .folder:
      return createFolderNode(at: url)
      
    case .requestFolder:
      return createRequestFolderNode(at: url)
    
    case .requestFile:
      return createRequestFileNode(at: url)
    }
  }
  
  /// Fetches all the requests under the root workspace `URL`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`
  /// - Returns: A `Set` containing all the found requests.
  static func requests() throws -> Set<MockaServer.Request> {
    requests(in: sourceTree())
  }
  
  /// Fetches all the `Node.NamespaceFolder` under the root workspace `URL`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`
  /// - Returns: A `Set` containing all the found folders.
  static func namespaceFolders() throws -> [Node.NamespaceFolder] {
    namespaceFolders(in: sourceTree())
  }
  
  /// Fetches all the `Node.RequestFolders` under the root workspace `URL`.
  /// - Throws: `MockaError.workspacePathDoesNotExist`
  /// - Returns: A `Set` containing all the found request folders.
  static func requestFolders() throws -> [Node.RequestFolder] {
    requestFolders(in: sourceTree())
  }
  
  /// Extracts the content of a file at a given `URL`.
  /// Should the extraction encounter any problem, `nil` is returned.
  /// - Parameter url: The `URL` of the file.
  /// - Returns: The content of the file as a `.utf8` `String` if found, otherwise `nil`.
  static func json(at url: URL) -> String? {
    guard let data = FileManager.default.contents(atPath: url.path) else {
      return nil
    }

    return String(data: data, encoding: .utf8)
  }
  
  /// Adds a directory of type `Node.NamespaceFolder` while creating intermediate directories.
  /// - Throws: `MockaError.failedToCreateDirectory` if the directory cannot be created.
  /// - Parameters:
  ///   - url: The `URL` of the hosting directory.
  ///   - named: The name of the new directory.
  /// - Returns: The created `Node.NamespaceFolder`.
  @discardableResult
  static func addNamespaceFolder(at url: URL, named: String) throws -> Node.NamespaceFolder {
    do {
      try FileManager
        .default
        .createDirectory(atPath: url.appendingPathComponent(named).path, withIntermediateDirectories: true, attributes: nil)
      return Node.NamespaceFolder(name: named, url: url, namespaces: [], requests: [])
    } catch {
      throw MockaError.failedToCreateDirectory(path: url.appendingPathComponent(named).path)
    }
  }

  /// Renames a FolderNode.
  /// - Parameters:
  ///   - node: The `FolderNode` to rename.
  ///   - name: The updated name.
  /// - Throws: `MockaError.failedToRenameDirectory` if the directory cannot be renamed.
  /// - Returns: The updated `FolderNode`.
  @discardableResult
  static func rename<T: FolderNode>(folder: T, to name: String) throws -> T? {
    let currentURL = folder.url
    let renamedURL = currentURL.deletingLastPathComponent().appendingPathComponent(name)

    do {
      try FileManager.default.moveItem(atPath: currentURL.path, toPath: renamedURL.path)
      
      if let namespaceFolder = folder as? Node.NamespaceFolder {
        return Node.NamespaceFolder(
          name: name,
          url: renamedURL,
          namespaces: namespaceFolder.namespaces,
          requests: namespaceFolder.requests
        ) as? T
      }
      
      if let requestFolder = folder as? Node.RequestFolder {
        return Node.RequestFolder(
          name: name,
          url: renamedURL,
          requestFile: requestFolder.requestFile
        ) as? T
      }
      
      throw MockaError.failedToRenameDirectory(path: renamedURL.path, name: name)
    } catch {
      throw MockaError.failedToRenameDirectory(path: currentURL.path, name: name)
    }
  }

  /// Deletes a folder node.
  /// - Parameter folder: The folder to delete.
  /// - Throws: `MockaError.failedToDeleteDirectory`
  static func delete(folder: FolderNode) throws {
    do {
      try FileManager.default.removeItem(atPath: folder.url.path)
    } catch {
      throw MockaError.failedToDeleteDirectory(path: folder.url.path)
    }
  }
  
  /// Encodes the request and pretty prints it to a `request.json` file at a given url.
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
      try content.write(to: url.appendingPathComponent(Self.allowedRequestFileName), atomically: false, encoding: .utf8)
    } catch {
      throw MockaError.failedToWriteToFile(content: content, path: url.appendingPathComponent(Self.allowedRequestFileName).path)
    }
  }
  
  /// Writes the response to a file with the proper extension to a url.
  /// - Parameters:
  ///   - response: The string of the response.
  ///   - named: The name of the response file. Defaults to response.
  ///   - extension: The extension with which to save the response file.
  ///   - url: the `URL` where to save the file.
  /// - Throws: `MockaError.failedToWriteToFile`.
  static func addResponse(
    _ response: String,
    named: String = "response",
    ofType extension: String,
    to url: URL
  ) throws {
    do {
      try response.write(to: url.appendingPathComponent("\(named).\(`extension`)"), atomically: false, encoding: .utf8)
    } catch {
      throw MockaError.failedToWriteToFile(content: response, path: url.appendingPathComponent("\(named).\(`extension`)").path)
    }
  }
  
  // MARK: Helpers
  
  /// Fetches all the requests starting from a certain node.
  /// - Parameter node: The root node in which to lookup.
  /// - Returns: A set containing all the found requests as `MockaServer.Request`.
  private static func requests(in node: Node.NamespaceFolder) -> Set<MockaServer.Request> {
    var requestsFound = node.requests.reduce(into: Set<MockaServer.Request>()) { result, node in
      result.insert(node.requestFile.request.mockaRequest(withResponseAt: node.url))
    }
    
    node.namespaces.forEach { namesapce in
      requestsFound = requestsFound.union(requests(in: namesapce))
    }
    
    return requestsFound
  }
  
  /// Fetches all the `Node.NamespaceFolder` starting from a certain node.
  /// - Parameter node: The root node in which to lookup.
  /// - Returns: A set containing all the found `Node.NamespaceFolder` nodes.
  private static func namespaceFolders(in node: Node.NamespaceFolder) -> [Node.NamespaceFolder] {
    var foldersFound = node.namespaces.reduce(into: [Node.NamespaceFolder]()) { result, node in
      result.append(node)
    }
    
    node.namespaces.forEach { namesapce in
      foldersFound.append(contentsOf: namespaceFolders(in: namesapce))
    }
    
    return foldersFound
  }
  
  /// Fetches all the `Node.RequestFolder` starting from a certain node.
  /// - Parameter node: The root node in which to lookup.
  /// - Returns: A set containing all the found `Node.RequestFolder` nodes.
  private static func requestFolders(in node: Node.NamespaceFolder) -> [Node.RequestFolder] {
    var foldersFound = node.requests.reduce(into: [Node.RequestFolder]()) { result, node in
      result.append(node)
    }
    
    node.namespaces.forEach { namesapce in
      foldersFound.append(contentsOf: requestFolders(in: namesapce))
    }
    
    return foldersFound
  }
  
  /// Transforms the object at a given URL to a `FileSystemNode` of type `.folder`.
  /// - Parameter url: The URL where the object lives.
  /// - Returns: A `Node.NamespaceFolder` object.
  private static func createFolderNode(at url: URL) -> Node.NamespaceFolder {
    let folderContent = nodes(at: url)
    
    return Node.NamespaceFolder(
      name: url.lastPathComponent,
      url: url,
      namespaces: folderContent.filter { $0.kind == .folder } as? [Node.NamespaceFolder] ?? [],
      requests: folderContent.filter { $0.kind == .requestFolder } as? [Node.RequestFolder] ?? []
    )
  }
  
  /// Transforms the object at a given URL to a `FileSystemNode` of type `.requestFolder`.
  /// - Parameter url: The URL where the object lives.
  /// - Returns: A `Node.RequestFolder` object.
  private static func createRequestFolderNode(at url: URL) -> Node.RequestFolder? {
    guard let requestNode = Self.createRequestFileNode(at: url.appendingPathComponent(Self.allowedRequestFileName)) else {
      return nil
    }
    
    return Node.RequestFolder(
      name: url.lastPathComponent,
      url: url,
      requestFile: requestNode
    )
  }
  
  /// Transforms the object at a given URL to a `FileSystemNode` of type `.request`.
  /// - Parameter url: The URL where the object lives.
  /// - Returns: A `Node.RequestFile` object.
  private static func createRequestFileNode(at url: URL) -> Node.RequestFile? {
    guard let request = Self.request(at: url) else {
      return nil
    }
    
    return Node.RequestFile(name: Self.allowedRequestFileName, url: url, request: request)
  }
  
  /// Explores the kind of the node.
  /// If the content type of the object at the given URL is `.json` and its content is a valid request, then the node is a `requestFile`.
  /// If the content type is `.folder`, we check the content of that folder to determine if it's a normal folder or a `requestFolder`.
  /// If the content type is not supported, `nil` is returned.
  /// - Parameter url: The `URL` of the node.
  /// - Returns: The `Node.Kind` value if supported, otherwise nil.
  private static func nodeKind(at url: URL) -> Node.Kind? {
    guard let (name, contentType) = Self.resourceInformation(at: url) else {
      return nil
    }
    
    if contentType == .json, name == Self.allowedRequestFileName {
      return .requestFile
    }
    
    if contentType == .folder {
      switch Self.isValidRequestFolder(at: url, name: name) {
      case true:
        return .requestFolder
      case false:
        return .folder
      }
    }
    
    return nil
  }
  
  /// Fetches the content type of all the children at a given directory.
  /// - Parameter url: The URL of the directory.
  /// - Returns: the content type of all the children.
  private static func childrenContentType(at url: URL) -> [UTType] {
    guard let enumeratedContent = Self.enumerateDirectory(at: url) else {
      return []
    }
    
    return enumeratedContent.reduce(into: [UTType]()) {
      guard
        let url = $1 as? URL,
        let (_, contentType) = Self.resourceInformation(at: url)
      else {
        return
      }
      
      $0.append(contentType)
    }
  }
  
  /// Returns informations about the specified `URL`.
  /// - Parameter url: The `URL` to retrieve information from.
  /// - Returns: A tuple containing the name of the directory or file and the `UTType` of the file or folder.
  private static func resourceInformation(at url: URL) -> (name: String, contentType: UTType)? {
    guard
      let resourceValues = try? url.resourceValues(forKeys: resourceKeys),
      let name = resourceValues.name,
      let contentType = resourceValues.contentType
    else {
      return nil
    }

    return (name, contentType)
  }
  
  /// Enumerate the content of a URL address.
  /// - Parameter url: The address to enumerate its content.
  /// - Returns: Directory enumerator object that can be used to perform a deep enumeration of the directory at the specified URL.
  private static func enumerateDirectory(at url: URL) -> FileManager.DirectoryEnumerator? {
    FileManager.default.enumerator(
      at: url,
      includingPropertiesForKeys: Array(resourceKeys),
      options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
    )
  }
  
  /// Decodes the contents of the file at the specified `URL` as a `MockaApp.Request`, and validates it.
  /// If the content of the file at the specified `URL` fails to decode, or does not pass validity checks,
  /// the function will return nil.
  /// - Parameter url: The `url` from which to extract the path.
  /// - Returns: A `MockaApp.Request` if found and is valid, otherwise nil.
  private static func request(at url: URL) -> Request? {
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
  
  /// Checks if an object at a `URL` represents a valid `Node.RequestFolder`.
  /// It does so by checking if it contains a valid request, and if its name is properly formatted.
  /// - Parameters:
  ///   - url: The `URL` where the object lives.
  ///   - name: The name of the folder
  /// - Returns: `true` if valid, `false` otherwise.
  private static func isValidRequestFolder(at url: URL, name: String) -> Bool {
    name.matchesRegex(Self.folderNameRegex) && Self.request(at: url.appendingPathComponent(Self.allowedRequestFileName)) != nil
  }
}

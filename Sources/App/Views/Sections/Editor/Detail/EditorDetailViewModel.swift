//
//  Mocka
//

import MockaServer
import SwiftUI

/// The ViewModel of the `EditorDetail` view.
final class EditorDetailViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The selected `MockaApp.Request`.
  let currentRequest: Request?

  /// The folder containing the `request.json`.
  let currentRequestFolder: FileSystemNode?

  /// The parent folder where to put the request.
  /// This is not the `METHOD - name of request folder` but rather the parent of that latter.
  let currentRequestParentFolder: FileSystemNode?

  /// The current response of the currently displayed request.
  let currentResponseBody: String?

  /// The list of all the namespace folders available.
  let namespaceFolders: [FileSystemNode] = Logic.SourceTree.namespaceFolders()

  /// The list of all the supported HTTP Methods.
  let allHTTPMethods: [HTTPMethod] = HTTPMethod.allCases

  /// The list of all the supported response body content type.
  let allContentTypes: [ResponseBody.ContentType] = ResponseBody.ContentType.allCases

  // MARK: Content displayed on the UI

  /// The custom name of the request.
  @Published var displayedRequestName: String = ""

  /// The path of the request as a `String`.
  @Published var displayedRequestPath: String = ""

  /// The status code of the response a `String`.
  @Published var displayedStatusCode: String = ""

  /// The text body of the response, if any.
  @Published var displayedResponseBody: String = ""

  /// The parent folder where to put the request.
  /// This is not the `METHOD - name of request folder` but rather the parent of that latter.
  @Published var selectedRequestParentFolder: FileSystemNode?

  /// The `HTTPMethod` of the request.
  @Published var selectedHTTPMethod: HTTPMethod?

  /// The desired content type of the response.
  @Published var selectedContentType: ResponseBody.ContentType? {
    didSet {
      // Remove existing value, if any.
      displayedResponseHeaders.removeAll { $0.key == "Content-Type" }

      guard let contentType = selectedContentType, contentType.isNone(of: [.none, .custom]) else {
        return
      }

      displayedResponseHeaders.append(HTTPHeader(key: "Content-Type", value: contentType.rawValue))
    }
  }

  /// The desired headers of the response.
  @Published var displayedResponseHeaders: [HTTPHeader] = []

  /// If true, the `UI` should display the empty state `UI`.
  @Published var shouldShowEmptyState: Bool = true

  // MARK: - Computed Properties

  /// If `true` the response body block should be displayed.
  var shouldDisplayBodyBlock: Bool {
    selectedContentType?.isNone(of: [.none, .custom]) ?? false
  }

  // MARK: - Interaction

  /// The user finished editing.
  var userDoneEditing: Interaction?

  // MARK - Init

  /// Creates an instance of `EditorDetailViewModel`.
  /// - Parameters:
  ///   - requestFile: The request file we want to display its details.
  ///   - requestFolder: The folder containing the request.
  ///   - requestParentFolder: The parent folder holding the folder of the request.
  ///                          Defaults to `nil`. Should not be `nil` if `selectedRequest` isn't.
  init(
    requestFile: FileSystemNode? = nil,
    requestFolder: FileSystemNode? = nil,
    requestParentFolder: FileSystemNode? = nil,
    completion: Interaction? = nil
  ) {
    userDoneEditing = completion

    guard case let .requestFile(request) = requestFile?.kind, let requestFolder = requestFolder, let requestParentFolder = requestParentFolder else {
      currentRequest = nil
      currentRequestFolder = nil
      currentRequestParentFolder = nil
      currentResponseBody = nil
      return
    }

    shouldShowEmptyState = false

    currentRequest = request
    currentRequestFolder = requestFolder
    selectedRequestParentFolder = requestParentFolder

    displayedRequestName = Self.requestName(request, requestFolderNode: requestFolder)
    displayedRequestPath = request.path.joined(separator: "/")
    currentRequestParentFolder = requestParentFolder
    selectedHTTPMethod = request.method
    selectedContentType = request.expectedResponse.contentType
    displayedResponseHeaders = request.expectedResponse.headers
    displayedStatusCode = String(request.expectedResponse.statusCode)

    if let responseFileName = request.expectedResponse.fileName {
      currentResponseBody = Logic.SourceTree.content(of: requestFolder.url.appendingPathComponent(responseFileName))
      displayedResponseBody = currentResponseBody ?? ""
    } else {
      currentResponseBody = nil
      displayedResponseBody = ""
    }
  }

  // MARK: - Functions

  /// Generates the request name from its method and containing folder.
  /// - Parameters:
  ///   - request: The request we want to generate the name for.
  ///   - requestFolderNode: The folder the request is in.
  /// - Returns: A `String` representing the name of the request.
  static func requestName(_ request: Request, requestFolderNode: FileSystemNode) -> String {
    let requestNameTrimmingLowerBound =
      requestFolderNode.name.range(
        of: "\(request.method.rawValue) - "
      )?
      .upperBound ?? requestFolderNode.name.endIndex

    return String(requestFolderNode.name[requestNameTrimmingLowerBound..<requestFolderNode.name.endIndex])
  }

  /// Generates the name of the request folder.
  /// - Parameters:
  ///   - request: The request we want to save.
  ///   - requestName: The custom name of the request.
  /// - Returns: The name of the request folder.
  static func requestFolderName(_ request: Request, requestName: String) -> String {
    "\(request.method.rawValue) - \(requestName)"
  }

  /// The user tapped the `Cancel` button.
  func cancelRequestCreation() {
    // Case when cancel is tapped during request creation.
    guard let request = currentRequest, let selectedRequestFolder = currentRequestFolder else {
      emptyStateContent()
      shouldShowEmptyState = true
      return
    }

    // Case when a request already exists.
    displayedRequestName = Self.requestName(request, requestFolderNode: selectedRequestFolder)
    selectedRequestParentFolder = currentRequestParentFolder
    displayedRequestPath = request.path.joined(separator: "/")
    selectedHTTPMethod = request.method
    selectedContentType = request.expectedResponse.contentType
  }

  /// The user tapped the save button.
  func createAndSaveRequest() {
    let request = Request(
      path: displayedRequestName.split(separator: "/").map { String($0) },
      method: selectedHTTPMethod!,
      expectedResponse: Response(
        statusCode: Int(displayedStatusCode)!,
        contentType: selectedContentType!,
        headers: displayedResponseHeaders
      )
    )

    let requestFolderName = Self.requestFolderName(request, requestName: displayedRequestName)

    // Create new request folder.
    try? Logic.SourceTree.addDirectory(at: selectedRequestParentFolder!.url, named: requestFolderName)

    // Add response, if needed.
    if displayedResponseBody.isNotEmpty,
      let expectedFileExtension = selectedContentType?.expectedFileExtension,
      let statusCode = Int(displayedStatusCode),
      HTTPResponseStatus(statusCode: statusCode).mayHaveResponseBody
    {
      try? Logic.SourceTree.addResponse(
        displayedResponseBody,
        type: expectedFileExtension,
        to: selectedRequestParentFolder!.url.appendingPathComponent(requestFolderName)
      )
    }

    // Add request.
    try? Logic.SourceTree.addRequest(request, to: selectedRequestParentFolder!.url.appendingPathComponent(requestFolderName))

    // Delete old request
    try? Logic.SourceTree.deleteDirectory(at: currentRequestFolder!.url.path)

    userDoneEditing?()
    shouldShowEmptyState = true
  }

  /// Resets the values of all the displayed content to empty.
  private func emptyStateContent() {
    displayedRequestName = ""
    displayedRequestPath = ""
    selectedRequestParentFolder = nil
    selectedHTTPMethod = nil
    selectedContentType = nil
    displayedResponseHeaders = []
  }
}

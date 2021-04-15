//
//  Mocka
//

import MockaServer
import SwiftUI

/// The ViewModel of the `EditorDetail` view.
final class EditorDetailViewModel: ObservableObject {

  // MARK: - Data Structure

  /// The mode in which the `EditorDetail` should be presented.
  enum Mode {
    /// A new request needs to be created.
    case create

    /// An existing request needs to be edited.
    case edit

    /// A request needs to be read.
    case read
  }

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

  /// The mode in which view should be displayed.
  @Published var currentMode: Mode {
    didSet {
      if currentMode.isAny(of: [.create, .edit]) {
        enableAllTextFields()
      } else {
        disableAllTextFields()
      }
    }
  }

  // MARK: Content displayed on the UI

  /// The custom name of the request.
  @Published var displayedRequestName: String = ""

  /// The path of the request as a `String`.
  @Published var displayedRequestPath: String = ""

  /// The status code of the response a `String`.
  @Published var displayedStatusCode: String = ""

  /// The desired headers of the response.
  @Published var displayedResponseHeaders: [HTTPHeader] = []

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

      guard let contentType = selectedContentType, contentType != .none else {
        return
      }

      displayedResponseHeaders.append(HTTPHeader(key: "Content-Type", value: contentType.rawValue))
    }
  }

  /// If `true` the `TextField` for `RequestName` will be enabled. Otherwise, disabled.
  @Published var isRequestNameTextFieldEnabled: Bool

  /// If `true` the `TextField` for `RequestPath` will be enabled. Otherwise, disabled.
  @Published var isRequestPathTextFieldEnabled: Bool

  /// If `true` the `TextField` for `RequestParentFolder` will be enabled. Otherwise, disabled.
  @Published var isRequestParentFolderTextFieldEnabled: Bool

  /// If `true` the `TextField` for `HTTPMethod` will be enabled. Otherwise, disabled.
  @Published var isHTTPMethodTextFieldEnabled: Bool

  /// If `true` the `TextField` for `StatusCode` will be enabled. Otherwise, disabled.
  @Published var isStatusCodeTextFieldEnabled: Bool

  /// If `true` the `TextField` for `ContentType` will be enabled. Otherwise, disabled.
  @Published var isContentTypeTextFieldEnabled: Bool

  /// If `true` the `TextField` for `ResponseHeaders` will be enabled. Otherwise, disabled.
  @Published var isResponseHeadersTextFieldEnabled: Bool

  /// If `true` the `TextField` for `ResponseBody` will be enabled. Otherwise, disabled.
  @Published var isResponseBodyTextFieldEnabled: Bool

  /// If true, the `UI` should display the empty state `UI`.
  @Published var shouldShowEmptyState: Bool

  // MARK: - Computed Properties

  /// If `true` the response body block should be displayed.
  var shouldDisplayBodyBlock: Bool {
    guard let contentType = selectedContentType else {
      return false
    }

    return contentType != .none
  }

  /// Controls all necessary fields are properly filled, if so, returns `true`.
  var isSaveButtonEnabled: Bool {
    guard
      displayedRequestName.isNotEmpty,
      displayedRequestPath.isNotEmpty,
      displayedStatusCode.isNotEmpty,
      selectedRequestParentFolder != nil,
      selectedHTTPMethod != nil,
      let contentType = selectedContentType
    else {
      return false
    }

    if contentType == .none {
      return true
    }

    guard displayedResponseHeaders.isNotEmpty, displayedResponseBody.isNotEmpty else {
      return false
    }

    return true
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
  ///   - mode: The mode in which view should be displayed.
  ///   - completion: A closure to invoke when the user taps the `Save` button.
  init(
    requestFile: FileSystemNode? = nil,
    requestFolder: FileSystemNode? = nil,
    requestParentFolder: FileSystemNode? = nil,
    mode: Mode = .read,
    onSave completion: Interaction? = nil
  ) {
    userDoneEditing = completion
    currentMode = mode

    if mode.isAny(of: [.create, .edit]) {
      isRequestNameTextFieldEnabled = true
      isRequestPathTextFieldEnabled = true
      isRequestParentFolderTextFieldEnabled = true
      isHTTPMethodTextFieldEnabled = true
      isStatusCodeTextFieldEnabled = true
      isContentTypeTextFieldEnabled = true
      isResponseHeadersTextFieldEnabled = true
      isResponseBodyTextFieldEnabled = true
    } else {
      isRequestNameTextFieldEnabled = false
      isRequestPathTextFieldEnabled = false
      isRequestParentFolderTextFieldEnabled = false
      isHTTPMethodTextFieldEnabled = false
      isStatusCodeTextFieldEnabled = false
      isContentTypeTextFieldEnabled = false
      isResponseHeadersTextFieldEnabled = false
      isResponseBodyTextFieldEnabled = false
    }

    guard case let .requestFile(request) = requestFile?.kind, let requestFolder = requestFolder, let requestParentFolder = requestParentFolder else {
      currentRequest = nil
      currentRequestFolder = nil
      currentRequestParentFolder = nil
      currentResponseBody = nil
      shouldShowEmptyState = mode != .create
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

  /// Sets the `currentMode` from `.read` to `.edit`.
  func enableEditMode() {
    guard currentMode == .read else {
      return
    }

    currentMode = .edit
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
    // The new created request.
    let request = Request(
      path: displayedRequestName.split(separator: "/").map { String($0) },
      method: selectedHTTPMethod!,
      expectedResponse: Response(
        statusCode: Int(displayedStatusCode)!,
        contentType: selectedContentType!,
        headers: displayedResponseHeaders
      )
    )

    let newRequestFolderName = Self.requestFolderName(request, requestName: displayedRequestName)

    guard
      currentRequest != nil,
      let currentRequestFolder = currentRequestFolder,
      let currentRequestParentFolder = currentRequestParentFolder
    else {
      // We are in create mode.
      // Create new request folder.
      try? Logic.SourceTree.addDirectory(at: selectedRequestParentFolder!.url, named: newRequestFolderName)

      // Add response, if any.
      #warning("Add implementation")

      // Add request.
      try? Logic.SourceTree.addRequest(request, to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName))

      // End editing mode.
      currentMode = .read
      userDoneEditing?()

      return
    }

    // If we changed the method, custom name, or parent folder, we create a new request folder at a new path.
    let hasNewPath = newRequestFolderName != currentRequestFolder.name || currentRequestParentFolder != selectedRequestParentFolder

    if hasNewPath {
      // Create new request folder.
      try? Logic.SourceTree.addDirectory(at: selectedRequestParentFolder!.url, named: newRequestFolderName)
      // Delete old request folder.
      try? Logic.SourceTree.deleteDirectory(at: currentRequestFolder.url.path)
    }

    // Add response, if needed.
    if displayedResponseBody.isNotEmpty,
      let expectedFileExtension = selectedContentType?.expectedFileExtension,
      let statusCode = Int(displayedStatusCode),
      HTTPResponseStatus(statusCode: statusCode).mayHaveResponseBody
    {
      try? Logic.SourceTree.addResponse(
        displayedResponseBody,
        type: expectedFileExtension,
        to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName)
      )
    }

    // Add request.
    try? Logic.SourceTree.addRequest(request, to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName))

    // End editing mode.
    currentMode = .read
    userDoneEditing?()
  }

  /// Resets the values of all the displayed content to empty.
  private func emptyStateContent() {
    displayedRequestName = ""
    displayedRequestPath = ""
    selectedRequestParentFolder = nil
    selectedHTTPMethod = nil
    selectedContentType = nil
    displayedResponseHeaders = []
    displayedResponseBody = ""
  }

  /// Sets all control variables to `false` (disabled).
  private func disableAllTextFields() {
    isRequestNameTextFieldEnabled = false
    isRequestPathTextFieldEnabled = false
    isRequestParentFolderTextFieldEnabled = false
    isHTTPMethodTextFieldEnabled = false
    isStatusCodeTextFieldEnabled = false
    isContentTypeTextFieldEnabled = false
    isResponseHeadersTextFieldEnabled = false
    isResponseBodyTextFieldEnabled = false
  }

  /// Sets all control variables to `true` (enabled).
  private func enableAllTextFields() {
    isRequestNameTextFieldEnabled = true
    isRequestPathTextFieldEnabled = true
    isRequestParentFolderTextFieldEnabled = true
    isHTTPMethodTextFieldEnabled = true
    isStatusCodeTextFieldEnabled = true
    isContentTypeTextFieldEnabled = true
    isResponseHeadersTextFieldEnabled = true
    isResponseBodyTextFieldEnabled = true
  }
}

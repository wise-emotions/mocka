//
//  Mocka
//

import MockaServer
import SwiftUI

/// The ViewModel of the `EditorDetail` view.
final class EditorDetailViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The selected `MockaApp.Request`.
  let selectedRequest: Request?

  /// The list of all the namespace folders available.
  let namespaceFolders: [FileSystemNode] = Logic.SourceTree.namespaceFolders()

  /// The list of all the supported HTTP Methods.
  let allHTTPMethods: [HTTPMethod] = HTTPMethod.allCases

  /// The list of all the supported response body content type.
  let allContentTypes: [ResponseBody.ContentType] = ResponseBody.ContentType.allCases

  /// The custom name of the request.
  @Published var requestName: String = ""

  /// The custom name of the request.
  @Published var requestPath: String = ""

  /// The parent folder where to put the request.
  @Published var requestParentFolder: FileSystemNode?

  /// The `HTTPMethod` of the request.
  @Published var selectedHTTPMethod: HTTPMethod?

  /// The desired content type of the response.
  @Published var selectedContentType: ResponseBody.ContentType?

  // MARK: - Computed Properties

  /// If true, the `UI` should display the empty state `UI`.
  var shouldShowEmptyState: Bool {
    selectedRequest == nil
  }


  /// Creates an instance of `EditorDetailViewModel`.
  /// - Parameters:
  ///   - selectedRequest: The `MockaApp.Request` we want to display its details. Defaults to `nil`.
  ///   - requestName: The custom name of the request. Defaults to empty string.
  ///   - requestParentFolder: The parent folder holding the folder of the request. Defaults to `nil`. Should not be `nil` if `selectedRequest` isn't.
  init(
    selectedRequest: Request? = nil,
    requestName: String = "",
    requestParentFolder: FileSystemNode? = nil
  ) {
    guard let request = selectedRequest else {
      self.selectedRequest = nil
      return
    }
    self.selectedRequest = request
    self.requestPath = request.path.joined(separator: "/")
    self.requestName = requestName
    self.requestParentFolder = requestParentFolder
    self.selectedHTTPMethod = request.method
    self.selectedContentType = request.expectedResponse.contentType
  }
}

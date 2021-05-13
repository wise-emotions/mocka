//
//  Mocka
//

import Combine
import Foundation
import MockaServer

/// The ViewModel of the `AppSection`.
final class AppSectionViewModel: ObservableObject {

  // MARK: - Stored Properties

  /// The `Set` containing the list of subscriptions.
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Init

  /// Creates a new instance with a `Publisher` of `NetworkExchange`s for the record mode.
  /// - Parameter recordModeNetworkExchangesPublisher: The publisher of `NetworkExchange`s for the record mode.
  init(recordModeNetworkExchangesPublisher: AnyPublisher<NetworkExchange, Never>) {
    recordModeNetworkExchangesPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        
      }
      .store(in: &subscriptions)
  }
  
  /// The user tapped the save button.
  func createAndSaveRequest(from networkExchange: NetworkExchange) {
    // The new created request.
    let request = Request(
      path: networkExchange.request.uri.path.components(separatedBy: "/"),
      method: HTTPMethod(rawValue: networkExchange.request.httpMethod.rawValue)!,
      expectedResponse: Response(
        statusCode: Int(networkExchange.response.status.code),
        contentType: networkExchange.response.headers.contentType!,
        headers: networkExchange.response.headers.map { HTTPHeader(key: $0.name, value: $0.value) }
      )
    )

    let newRequestFolderName = Self.requestFolderName(request, requestName: networkExchange.request.uri.path)

    guard
      currentRequest != nil,
      let currentRequestFolder = currentRequestFolder,
      let currentRequestParentFolder = currentRequestParentFolder
    else {
      // We are in create mode.
      // Create new request folder.
      try? Logic.SourceTree.addDirectory(at: selectedRequestParentFolder!.url, named: newRequestFolderName)

      // Add response, if any.
      if displayedResponseBody.isNotEmpty, let expectedFileExtension = selectedContentType?.expectedFileExtension {
        try? Logic.SourceTree.addResponse(
          displayedResponseBody,
          ofType: expectedFileExtension,
          to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName)
        )
      }

      // Add request.
      try? Logic.SourceTree.addRequest(request, to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName))

      return
    }

      try? Logic.SourceTree.addDirectory(at: selectedRequestParentFolder!.url, named: newRequestFolderName)
      // Delete old request folder.
      try? Logic.SourceTree.deleteDirectory(at: currentRequestFolder.url.path)

    // Add response, if needed.
    if displayedResponseBody.isNotEmpty,
      let expectedFileExtension = selectedContentType?.expectedFileExtension,
      let statusCode = Int(displayedStatusCode),
      HTTPResponseStatus(statusCode: statusCode).mayHaveResponseBody
    {
      try? Logic.SourceTree.addResponse(
        displayedResponseBody,
        ofType: expectedFileExtension,
        to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName)
      )
    }

    // Add request.
    try? Logic.SourceTree.addRequest(request, to: selectedRequestParentFolder!.url.appendingPathComponent(newRequestFolderName))
  }
  
  /// Generates the name of the request folder.
  /// - Parameters:
  ///   - request: The request we want to save.
  ///   - requestName: The custom name of the request.
  /// - Returns: The name of the request folder.
  static func requestFolderName(_ request: Request, requestName: String) -> String {
    "\(request.method.rawValue) - \(requestName)"
  }
}

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
      .sink { [weak self] networkExchange in
        #warning("Add proper values")
        self?.createAndSaveRequest(
          from: networkExchange,
          to: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0],
          shouldOverwriteResponse: true
        )
      }
      .store(in: &subscriptions)
  }
  
  /// The user tapped the save button.
  func createAndSaveRequest(from networkExchange: NetworkExchange, to directory: URL, shouldOverwriteResponse: Bool) {
    // The newly created request.
    let request = Request(
      path: networkExchange.request.uri.path.components(separatedBy: "/"),
      method: HTTPMethod(rawValue: networkExchange.request.httpMethod.rawValue)!,
      expectedResponse: Response(
        statusCode: Int(networkExchange.response.status.code),
        contentType: networkExchange.response.headers.contentType ?? .applicationJSON,
        headers: networkExchange.response.headers.map { HTTPHeader(key: $0.name, value: $0.value) }
      )
    )
    
    if Logic.SourceTree.contents(of: directory).isNotEmpty, shouldOverwriteResponse {
      try? Logic.SourceTree.deleteDirectory(at: directory.absoluteString)
    } else {
      return
    }
    
    try? Logic.SourceTree.addDirectory(at: directory, named: Self.requestFolderName(request))

    // Add response, if any.
    if
      let responseBodyData = networkExchange.response.body,
      let responseBody = String(data: responseBodyData, encoding: .utf8),
      let expectedFileExtension = request.expectedResponse.contentType.expectedFileExtension
    {
      try? Logic.SourceTree.addResponse(
        responseBody,
        ofType: expectedFileExtension,
        to: directory.appendingPathComponent(Self.requestFolderName(request))
      )
    }

    // Add request.
    try? Logic.SourceTree.addRequest(request, to: directory.appendingPathComponent(Self.requestFolderName(request)))
  }
  
  /// Generates the name of the request folder.
  /// - Parameter request: The request we want to save.
  /// - Returns: The name of the request folder.
  static func requestFolderName(_ request: Request) -> String {
    "\(request.method.rawValue) - \(request.path)"
  }
}

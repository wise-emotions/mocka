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
  
  var appEnvironment: AppEnvironment
  
  /// The path for the request and response to save in the record mode.
  var recordingPath: URL? {
    appEnvironment.selectedRecordingPath
  }

  // MARK: - Init

  /// Creates a new instance with a `Publisher` of `NetworkExchange`s for the record mode.
  /// - Parameter recordModeNetworkExchangesPublisher: The publisher of `NetworkExchange`s for the record mode.
  init(recordModeNetworkExchangesPublisher: AnyPublisher<NetworkExchange, Never>, appEnvironment: AppEnvironment) {
    self.appEnvironment = appEnvironment
    
    recordModeNetworkExchangesPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] networkExchange in
        guard let recordingPath = self?.recordingPath else {
          print("ops")
          return
        }
        
        #warning("Add proper values")
        self?.createAndSaveRequest(
          from: networkExchange,
          to: recordingPath,
          shouldOverwriteResponse: true
        )
      }
      .store(in: &subscriptions)
  }
  
  /// Creates a request from the received `NetworkExchange` and saves it to the provided folder.
  /// If the response is already present, it is overwritten or not based on the `shouldOverwriteResponse` parameter.
  /// - Parameters:
  ///   - networkExchange: The received `NetworkExchange` object, that contains the request/response pair.
  ///   - directory: The directory where to save the request and response.
  ///   - shouldOverwriteResponse: Whether or not the request and response should be overwritten if already present.
  func createAndSaveRequest(from networkExchange: NetworkExchange, to directory: URL, shouldOverwriteResponse: Bool) {
    let request = Request(from: networkExchange)
    let requestDirectoryName = Self.requestDirectoryName(request)
    let requestDirectory = directory.appendingPathComponent(requestDirectoryName)
    
    if Logic.SourceTree.contents(of: requestDirectory).isNotEmpty {
      if shouldOverwriteResponse {
        try? Logic.SourceTree.deleteDirectory(at: requestDirectoryName)
      } else {
        return
      }
    }
    
    try? Logic.SourceTree.addDirectory(at: directory, named: requestDirectoryName)

    // Add response, if any.
    if
      let responseBodyData = networkExchange.response.body,
      let responseBody = String(data: responseBodyData, encoding: .utf8),
      let expectedFileExtension = request.expectedResponse.contentType.expectedFileExtension
    {
      try? Logic.SourceTree.addResponse(
        responseBody,
        ofType: expectedFileExtension,
        to: directory.appendingPathComponent(requestDirectoryName)
      )
    }

    // Add request.
    try? Logic.SourceTree.addRequest(request, to: requestDirectory)
  }
  
  /// Generates the name of the request folder.
  /// - Parameter request: The request we want to save.
  /// - Returns: The name of the request folder.
  static private func requestDirectoryName(_ request: Request) -> String {
    "\(request.method.rawValue) - \(request.path)"
  }
}

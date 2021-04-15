//
//  Mocka
//

import SwiftUI

final class EditorDetailResponseInformationViewModel: ObservableObject {
  /// The desired headers of the response.
  @Published var headers: [HTTPHeader] = []

  /// The text body of the response, if any.
  @Published var body: String = ""

  /// The table mode.
  @Published var mode: KeyValueTableViewModel.Mode

  /// The list of the key value items.
  @Published var keyValueHeaders: [KeyValueItem] = []

  /// Create a new `EditorDetailResponseInformationViewModel`.
  /// - Parameters:
  ///   - headers: The headers `Array`.
  ///   - body: The body `String`.
  ///   - mode: The editing mode.
  init(headers: [HTTPHeader], body: String, mode: KeyValueTableViewModel.Mode) {
    self.headers = headers
    self.body = body
    self.mode = mode
    keyValueHeaders = headers.map { KeyValueItem(key: $0.key, value: $0.value) }
  }
}

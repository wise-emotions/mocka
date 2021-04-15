//
//  Mocka
//

import SwiftUI

final class EditorDetailHeadersBodyViewModel: ObservableObject {
  /// The desired headers of the response.
  @Published var headers: [HTTPHeader] = []

  /// The text body of the response, if any.
  @Published var body: Binding<String>

  @Published var mode: KeyValueTableViewModel.Mode

  @Published var keyValueHeaders: [KeyValueItem] = []

  init(headers: [HTTPHeader], body: Binding<String>, mode: KeyValueTableViewModel.Mode) {
    self.headers = headers
    self.body = body
    self.mode = mode
    keyValueHeaders = headers.map { KeyValueItem(key: $0.key, value: $0.value) }
  }
}

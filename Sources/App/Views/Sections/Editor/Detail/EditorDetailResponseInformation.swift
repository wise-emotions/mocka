//
//  Mocka
//

import SwiftUI

struct EditorDetailResponseInformation: View {

  /// The associated ViewModel.
  @ObservedObject var viewModel: EditorDetailResponseInformationViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Response Headers")
        .font(.system(size: 13, weight: .semibold, design: .default))
        .foregroundColor(Color.latte)

      KeyValueTable(viewModel: KeyValueTableViewModel(keyValueItems: viewModel.keyValueHeaders, mode: viewModel.mode))
        .padding(.bottom, 16)

      Editor(viewModel: EditorViewModel(text: viewModel.body, mode: viewModel.mode == .read ? .read : .write))
    }
    .padding(20)
    .background(Color.lungo)
    .padding(20)
  }
}

// MARK: - Preview

struct EditorDetailResponseInformationPreviews: PreviewProvider {
  static var previews: some View {
    EditorDetailResponseInformation(
      viewModel: EditorDetailResponseInformationViewModel(
        headers: [HTTPHeader(key: "Test", value: "Test")],
        body: "{\"test\":\"test\"}",
        mode: .write
      )
    )
  }
}

import Server
import SwiftUI

struct RequestInfoContainerView: View {

  @StateObject var viewModel: RequestInfoContainerViewModel

  var body: some View {
    ZStack(alignment: .top) {
      ScrollView {
        VStack(alignment: .leading) {
          SectionView(title: "URL") {
            TextField(viewModel.path, text: .constant(viewModel.path))
              .padding()
              .textFieldStyle(PlainTextFieldStyle())
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
          }

          SectionView(title: "Query") {
            KeyValueTable(keyValueItems: viewModel.queryParameters)
          }
          .isHidden(viewModel.kind.isResponse, remove: true)

          SectionView(title: "Headers") {
            KeyValueTable(keyValueItems: viewModel.headers)
          }

          SectionView(title: "Body") {
            TextEditor(text: .constant(viewModel.body))
              .padding()
              .font(.system(size: 13, weight: .regular, design: .default))
              .foregroundColor(Color.latte)
          }
        }
        .padding()
      }
      .padding(.top, 50)

      Picker(selection: $viewModel.kind, label: Text("")) {
        ForEach(RequestInfoContainerViewModel.Kind.allCases, id: \.self) { kind in
          Text(kind.rawValue).tag(kind)
            .font(.system(size: 13, weight: .regular, design: .default))
            .foregroundColor(Color.latte)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .frame(width: 160)
    }
  }
}

// MARK: - Preview

struct RequestInfoContainerView_Previews: PreviewProvider {
  static var previews: some View {
    RequestInfoContainerView(
      viewModel: RequestInfoContainerViewModel(
        networkExchange: NetworkExchange.mock,
        kind: .request
      )
    )
  }
}

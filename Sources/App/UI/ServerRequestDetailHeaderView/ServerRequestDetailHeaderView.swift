import Server
import SwiftUI


/// The header of the `ServerRequestDetailView`.
struct ServerRequestDetailHeaderView: View {

  // MARK: - Stored Properties

  /// The `HTTPMethod` of the request.
  let httpMethod: HTTPMethod

  /// The `HTTPStatus` of the response`
  let httpStatus: Int

  /// The meaning of the respective status code.
  let httpStatusMeaning: String

  /// The timestamp of the response.
  let timestamp: String

  /// The path of the request.
  let path: String

  // MARK: - Computed Properties

  /// The color of the circle, based on the HTTPStatus.
  var httpStatusColor: Color {
    switch httpStatus {
    case 200...299:
      return .green

    case 300...399:
      return .yellow

    case 400...599:
      return .red

    default:
      return .clear
    }
  }

  // MARK: - Body

  var body: some View {
    VStack(alignment: .leading, spacing: 16){
      HStack(alignment: .top, spacing: 8) {
        TextPillView(text: httpMethod.rawValue)
        Text(path)
          .font(.system(size: 13))
          .fixedSize(horizontal: false, vertical: true)
      }
      HStack {
        Circle()
          .frame(width: 10, height: 10)
          .foregroundColor(httpStatusColor)
        Text("\(httpStatus) \(httpStatusMeaning)")
          .font(.system(size: 13))
          .foregroundColor(.secondary)
        Spacer()
        Text(timestamp)
          .font(.system(size: 13))
          .foregroundColor(.secondary)
      }
    }
    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 24))
  }
}

struct ServerRequestDetailHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ServerRequestDetailHeaderView(
      httpMethod: .delete,
      httpStatus: 431,
      httpStatusMeaning: "Request headers too large",
      timestamp: "13:04:32:999",
      path: "/api/v1/transactions?id=1243&user=wiseman128134752387423848923489238942384189234891234891348912343242345"
    )
    .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity)
  }
}

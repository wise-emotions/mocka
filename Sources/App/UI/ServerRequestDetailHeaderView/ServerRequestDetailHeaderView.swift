import SwiftUI

struct ServerRequestDetailHeaderView: View {

  let requestTypeText: String
  let requestURLText: String
  let circleColor: Color
  let statusText: String
  let timeStampText: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16){
      HStack(alignment: .top, spacing: 8) {
        TextPillView(text: requestTypeText)
        Text(requestURLText)
          .font(.system(size: 13))
          .fixedSize(horizontal: false, vertical: true)
      }
      HStack {
        Circle()
          .frame(width: 10, height: 10)
          .foregroundColor(circleColor)
        Text(statusText)
          .font(.system(size: 13))
          .foregroundColor(.secondary)
        Spacer()
        Text(timeStampText)
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
      requestTypeText: "DELETE",
      requestURLText: "/api/v1/transactions?id=1243&user=wiseman128134752387423848923489238942384189234891234891348912343242345",
      circleColor: .red,
      statusText: "431 Request headers too large",
      timeStampText: "13:04:32:999"
    )
    .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity)
  }
}

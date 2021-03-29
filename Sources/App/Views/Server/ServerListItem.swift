import Foundation
import Server
import SwiftUI

extension ServerList {
  struct Item: View {
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

    var body: some View {
      HStack {
        HTTPStatusCodeEllipse(httpStatus: httpStatus)
          .padding(.leading, 8)

        VStack(alignment: .leading, spacing: 10) {
          HStack {
            Text(httpMethod.rawValue)
              .font(.system(size: 12, weight: .bold))
              .padding(8)
              .frame(height: 20)
              .background(Color.gray)
              .cornerRadius(100)
              .foregroundColor(Color.white)
              .frame(width: 63, alignment: .leading)
            Text(path)
              .font(.system(size: 12))
              .foregroundColor(Color.white)
              .padding(.trailing, 8)
          }
          HStack(spacing: 4) {
            Text(String(httpStatus))
              .font(.system(size: 11, weight: .bold))
              .foregroundColor(Color.gray)
            Text(httpStatusMeaning)
              .font(.system(size: 11))
              .foregroundColor(Color.gray)
            Spacer()
            Text(timestamp)
              .font(.system(size: 11))
              .foregroundColor(Color.gray)
              .padding(.trailing, 4)
          }
        }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 8))
      }
      .background(Color("SecondaryColor"))
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }

  struct ItemPreviews: PreviewProvider {
    static var previews: some View {
      Item(httpMethod: .get, httpStatus: 200, httpStatusMeaning: "Ok", timestamp: "09:41:00.000", path: "/api/v1/list")
    }
  }

  struct ItemLibraryContent: LibraryContentProvider {
    let httpMethod: HTTPMethod = .get
    let httpStatus = 200
    let httpStatusMeaning = "Ok"
    let timestamp = "09:41:00.000"
    let path = "/api/v1/list"

    @LibraryContentBuilder
    var views: [LibraryItem] {
      LibraryItem(
        Item(
          httpMethod: httpMethod,
          httpStatus: httpStatus,
          httpStatusMeaning: httpStatusMeaning,
          timestamp: timestamp,
          path: path
        )
      )
    }
  }
}

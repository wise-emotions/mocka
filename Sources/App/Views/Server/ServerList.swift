import Foundation
import SwiftUI

struct ServerList: View {
  /// The list of all the server calls.
  @Binding var serverCalls: [ServerCall]

  /// The window manager environment object.
  @EnvironmentObject var windowManager: WindowManager

  var body: some View {
    VStack {
      ServerToolbar(isServerRunning: .constant(false))
        .padding(.leading, 16)
        .padding(.trailing, 24)

      List(serverCalls) { item in
        NavigationLink(destination: Text(item.path)) {
          Item(httpMethod: item.httpMethod, httpStatus: item.httpStatus, httpStatusMeaning: item.httpStatusMeaning, timestamp: item.timestamp, path: item.path)
        }
      }
      .background(Color("PrimaryColor"))
    }
    .background(Color("PrimaryColor"))
    .padding(.top, windowManager.titleBarHeight(to: .remove))
    .frame(minWidth: Constants.listWidth)
  }
}

struct ServerListPreviews: PreviewProvider {
  static let serverCalls = [
    ServerCall(httpMethod: .delete, httpStatus: 204, httpStatusMeaning: "No Content", timestamp: "09:41:00.000", path: "/api/v1/delete"),
    ServerCall(httpMethod: .get, httpStatus: 200, httpStatusMeaning: "Ok", timestamp: "09:41:00.000", path: "/api/v1/users"),
    ServerCall(httpMethod: .get, httpStatus: 301, httpStatusMeaning: "Moved Permanently", timestamp: "09:41:00.000", path: "/api/v1/vehicles"),
    ServerCall(httpMethod: .patch, httpStatus: 404, httpStatusMeaning: "Not Found", timestamp: "09:41:00.000", path: "/api/v1/user/1")
  ]

  static var previews: some View {
    ServerList(serverCalls: .constant(serverCalls))
      .environmentObject(WindowManager.shared)
  }
}

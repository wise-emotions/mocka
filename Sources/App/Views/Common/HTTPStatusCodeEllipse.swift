import SwiftUI

struct HTTPStatusCodeEllipse: View {
  /// The `HTTPStatus` of the response`
  let httpStatus: Int

  /// The color of the ellipse, based on the HTTPStatus.
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

  var body: some View {
    Ellipse()
      .fill(httpStatusColor)
      .frame(width: 10, height: 10)
  }
}

struct HTTPStatusCodeEllipsePreviews: PreviewProvider {
  static var previews: some View {
    HTTPStatusCodeEllipse(httpStatus: 200)
  }
}

struct HTTPStatusCodeEllipseLibraryContent: LibraryContentProvider {
  let statusCode: Int = 200

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(HTTPStatusCodeEllipse(httpStatus: statusCode))
  }
}

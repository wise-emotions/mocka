//
//  Mocka
//

import SwiftUI

/// The HTTP status code ellipse view.
/// it automatically set the color based on the HTTP status.
struct HTTPStatusCodeEllipse: View {

  // MARK: - Stored Properties

  /// The `HTTPStatus` of the response`
  let httpStatus: UInt

  // MARK: - Computed Properties

  /// The color of the ellipse, based on the HTTPStatus.
  var httpStatusColor: Color {
    switch httpStatus {
    case 200...299:
      return Color.irish

    case 300...399:
      return Color.cappuccino

    case 400...599:
      return Color.redEye

    default:
      return Color.ristretto
    }
  }

  // MARK: - Body

  var body: some View {
    Ellipse()
      .fill(httpStatusColor)
      .frame(width: 10, height: 10)
  }
}

// MARK: - Previews

struct HTTPStatusCodeEllipsePreviews: PreviewProvider {
  static var previews: some View {
    HTTPStatusCodeEllipse(httpStatus: 200)
  }
}

// MARK: - Library

struct HTTPStatusCodeEllipseLibraryContent: LibraryContentProvider {
  let statusCode: UInt = 200

  @LibraryContentBuilder
  var views: [LibraryItem] {
    LibraryItem(HTTPStatusCodeEllipse(httpStatus: statusCode))
  }
}

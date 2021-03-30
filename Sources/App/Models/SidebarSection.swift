import Foundation

/// All the app sections to display in a sidebar.
enum SidebarSection: String, CaseIterable {
  /// The server section of the app.
  case server

  /// The editor section of the app.
  case editor

  /// The console section of the app.
  case console

  /// The title of the section.
  var title: String {
    rawValue.capitalized
  }

  /// The SF Symbol representing the section.
  var symbolName: String {
    switch self {
    case .server:
      return "server.rack"

    case .editor:
      return "pencil.circle"

    case .console:
      return "chevron.left.slash.chevron.right"
    }
  }
}

//
//  Mocka
//

import Foundation

/// App constants enum.
enum Size {
  /// Minimum Sidebar width.
  static let minimumSidebarWidth: CGFloat = 140

  /// Fixed Sidebar height.
  static let fixedSidebarHeight: CGFloat = 88

  /// Minimum App height.
  static let minimumAppHeight: CGFloat = 600

  /// Minimum List width.
  static let minimumListWidth: CGFloat = 370

  /// Minimum Detail width.
  static let minimumDetailWidth: CGFloat = 400

  /// Minimum Filter text field width.
  static var minimumFilterTextFieldWidth: CGFloat {
    minimumListWidth - 140
  }

  /// Minimum App section width.
  static var minimumAppSectionWidth: CGFloat {
    minimumListWidth + minimumDetailWidth
  }
}

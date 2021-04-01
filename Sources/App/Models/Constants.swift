import Foundation

/// App constants enum.
enum Constants {
  /// Fixed Sidebar width.
  static let fixedSidebarWidth: CGFloat = 88

  /// Minimum App height.
  static let minimumAppHeight: CGFloat = 600

  /// Minimum List width.
  static let minimumListWidth: CGFloat = 368

  /// Minimum Detail width.
  static let minimumDetailWidth: CGFloat = 400

  /// Minimum App section width.
  static var minimumAppSectionWidth: CGFloat {
    minimumListWidth + minimumDetailWidth
  }
}

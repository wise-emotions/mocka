import Foundation

/// Window manager class.
class WindowManager: ObservableObject {
  /// Title bar height mode.
  /// Used to add or subtract the titleBar points.
  enum TitleBarHeightMode {
    /// Add case.
    case add
    /// Remove case.
    case remove
  }

  /// A shared `WindowManager`.
  static let shared = WindowManager()

  /// The published `isFullScreen` property.
  /// Used to know if the app is currently in full-screen mode.
  @Published var isFullScreen: Bool = false

  /// Adds or removes the `titleBar` points to the view.
  /// - Parameter titleBarHeightMode: TitleBar height mode. Add or remove.
  /// - Returns: Returns the points to be added or removed by using `.padding()` or `.frame()`.
  func titleBarHeight(to titleBarHeightMode: TitleBarHeightMode) -> CGFloat {
    let titleBarHeight: CGFloat = 28

    switch titleBarHeightMode {
      case .add:
        return self.isFullScreen ? 0 : titleBarHeight
      case .remove:
        return self.isFullScreen ? 0 : -titleBarHeight
    }
  }
}

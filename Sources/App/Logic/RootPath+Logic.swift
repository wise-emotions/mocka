//
//  Mocka
//

import Foundation
import SwiftUI

extension Logic {
  /// The logic related to the root path where all the requests and responses live.
  enum RootPath {}
}

extension Logic.RootPath {
  /// The value of the root path.
  /// When this value is updated, the value in the user defaults is updated as well.
  @AppStorage(userDefaultKey.rootPath)
  static var value: URL?

  /// Checks if the root path is set in the `UserDefaults`.
  static var isRootPathSet: Bool {
    value != nil
  }
}

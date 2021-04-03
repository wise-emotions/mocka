//
//  Mocka
//

import Foundation

/// A list of errors that can be thrown inside of `Mocka` app.
enum MockaError: Error {
  /// The root path value is missing when it's expected to be populated.
  case missingRootPathValue
}

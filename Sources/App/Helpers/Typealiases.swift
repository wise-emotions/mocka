//
//  Mocka
//

import Foundation

/// An `API` path.
typealias Path = [String]

/// A closure with no parameters, and no output.
typealias Interaction = () -> Void

/// A closure for reacting to a permission authorization request.
typealias AuthorizationRequestCompletion = (Bool, Error?) -> Void

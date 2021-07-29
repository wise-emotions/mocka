//
//  Mocka
//

import Foundation

/// A closure for reacting to a permission authorization request.
typealias AuthorizationRequestCompletion = (Bool, Error?) -> Void

/// A closure block with a parameter.
typealias CustomInteraction<T> = (T) -> Void

/// A closure with no parameters, and no output.
typealias Interaction = () -> Void

/// An `API` path.
typealias Path = [String]

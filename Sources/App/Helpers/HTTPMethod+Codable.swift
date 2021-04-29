//
//  Mocka
//

import MockaServer

// This is needed to encode and decode the `Content-Type` parameter in the request and response files.
extension HTTPMethod: Codable {}

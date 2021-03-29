import NIOHTTP1
import Vapor

/// An array of string that forms a path.
public typealias Path = [String]

/// A HTTP response status code.
public typealias HTTPResponseStatus = NIOHTTP1.HTTPResponseStatus

/// A representation of a block of HTTP header fields.
///
/// HTTP header fields are a complex data structure. The most natural representation
/// for these is a sequence of two-tuples of field name and field value, both as
/// strings. This structure preserves that representation, but provides a number of
/// convenience features in addition to it.
///
/// For example, this structure enables access to header fields based on the
/// case-insensitive form of the field name, but preserves the original case of the
/// field when needed. It also supports recomposing headers to a maximally joined
/// or split representation, such that header fields that are able to be repeated
/// can be represented appropriately.
public typealias HTTPHeaders = NIOHTTP1.HTTPHeaders

/// A Uniform Resource Identifier.
public typealias URI = Vapor.URI

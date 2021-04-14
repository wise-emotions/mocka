import Foundation

/// An object containing the `Content-Type` and the file path for the body of the response.
public struct ResponseBody {
  /// The kind of the content of the response.
  public let contentType: ContentType

  /// The url of the file holding the content.
  public let pathToFile: String

  /// Creates a `ResponseBody` object.
  /// - Parameters:
  ///   - contentType: The kind of the content of the response.
  ///   - pathToFile: The path to the file holding the content.
  public init(contentType: ResponseBody.ContentType, pathToFile: String) {
    self.contentType = contentType
    self.pathToFile = pathToFile
  }
}

// MARK: - Public `ResponseBody` Extension

public extension ResponseBody {
  /// The `Content-Type` of the response body.
  enum ContentType: String, CaseIterable {

    // MARK: Application

    /// `Content-Type: application/json`.
    case applicationJSON = "application/json"

    // MARK: Text

    /// `Content-Type: text/csv`.
    case textCSS = "text/css"

    /// `Content-Type: text/css`.
    case textCSV = "text/csv"

    /// `Content-Type: text/html`.
    case textHTML = "text/html"

    /// `Content-Type: text/plain`.
    case textPlain = "text/txt"

    /// `Content-Type: text/xml`.
    case textXML = "text/xml"

    // MARK: Custom

    /// No content in the body.
    ///
    /// Example: HTTP Status 204.
    case none = "none"
  }
}

// MARK: - Internal `ResponseBody` Extension

internal extension ResponseBody {
  /// Checks if the actual file extension in the `URL` matches the expected one for the body type.
  func isValidFileFormat() -> Bool {
    // When the `ContentType` is `.none`,
    // we do not check the validity of the format, and return `true`.
    guard contentType != .none else {
      return true
    }

    guard let fileExtension = pathToFile.split(separator: ".").last else {
      return false
    }

    // We can force unwrap because the only value that returns `nil` is `.none` which we guard already that `contentType != .none`.
    return fileExtension == contentType.expectedFileExtension!
  }
}

// MARK: - Public `ResponseBody.ContentType` Extension

public extension ResponseBody.ContentType {
  /// The file extension associated with each `Content-Type`.
  var expectedFileExtension: String? {
    switch self {
    case .applicationJSON:
      return "json"

    case .textCSS:
      return "css"

    case .textCSV:
      return "csv"

    case .textHTML:
      return "html"

    case .textPlain:
      return "txt"

    case .textXML:
      return "xml"

    case .none:
      return nil
    }
  }
}

// MARK: - Internal `ResponseBody.ContentType` Extension

internal extension ResponseBody.ContentType {
  /// The value associated to `Content-Type` in the response header.
  var contentTypeHeader: String? {
    guard self != .none else {
      return nil
    }

    return rawValue
  }
}

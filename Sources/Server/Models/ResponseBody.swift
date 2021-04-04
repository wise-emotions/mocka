import Foundation

/// An object containing the `Content-Type` and the file path for the body of the response.
public struct ResponseBody {
  /// The kind of the content of the response.
  public let contentType: ContentType
  
  /// The url of the file holding the content.
  public let fileLocation: URL

  /// Creates and returns a `ResponseBody` object.
  /// - Parameters:
  ///   - contentType: The kind of the content of the response.
  ///   - fileLocation: The url of the file holding the content.
  public init(contentType: ResponseBody.ContentType, fileLocation: URL) {
    self.contentType = contentType
    self.fileLocation = fileLocation
  }
}

// MARK: - Public `ResponseBody` Extension

public extension ResponseBody {
  /// The `Content-Type` of the response body.
  enum ContentType: CaseIterable {

    // MARK: Application

    /// `Content-Type: application/json`.
    case applicationJSON

    // MARK: Text

    /// `Content-Type: text/csv`.
    case textCSS

    /// `Content-Type: text/css`.
    case textCSV

    /// `Content-Type: text/html`.
    case textHTML

    /// `Content-Type: text/plain`.
    case textPlain

    /// `Content-Type: text/xml`.
    case textXML

    // MARK: Custom

    /// No preset configuration.
    /// This preset does not provide any validation.
    case custom
  }
}

// MARK: - Internal `ResponseBody` Extension

internal extension ResponseBody {
  /// Checks if the actual file extension in the `URL` matches the expected one for the body type.
  func isValidFileFormat() -> Bool {
    // When the `ContentType` is `.custom`, we do not check the validity of the format, and return true.
    guard contentType != .custom else {
      return true
    }

    guard let fileExtension = fileLocation.absoluteString.split(separator: ".").last else {
      return false
    }

    // We can force unwrap because the only value that returns `nil` is `.custom` which we guard already that `kind != .custom`.
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

    case .custom:
      return nil
    }
  }
}

// MARK: - Internal `ResponseBody.ContentType` Extension

internal extension ResponseBody.ContentType {
  /// The value to associated to `Content-Type` in the response header.
  var contentTypeHeader: String? {
    switch self {
    case .applicationJSON:
      return "application/json"

    case .textCSS:
      return "text/css"

    case .textCSV:
      return "text/csv"

    case .textHTML:
      return "text/html"

    case .textPlain:
      return "text/txt"

    case .textXML:
      return "text/xml"

    case .custom:
      return nil
    }
  }
}

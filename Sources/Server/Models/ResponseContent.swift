import Foundation

/// A custom file extension that allows bypassing validation.
fileprivate let passpartout = "*"

/// The list of supported content type inside the response body.
public enum ResponseContent {

  // MARK: APPLICATION

  /// `content-type: application/json`.
  case applicationJSON(url: URL)

  // MARK: TEXT

  /// `content-type: text/csv`.
  case textCSS(url: URL)

  /// `content-type: text/css`.
  case textCSV(url: URL)

  /// `content-type: text/html`.
  case textHTML(url: URL)

  /// `content-type: text/plain`.
  case textPlain(url: URL)

  /// `content-type: text/xml`.
  case textXML(url: URL)

  // MARK: GENERIC

  /// No preset configuration.
  case custom(url: URL)
}

internal extension ResponseContent {
  /// The file extension associated with each type.
  var expectedFileExtension: String {
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
      return passpartout
    }
  }

  /// The `URL` of where the file associated with the response is located.
  var fileLocation: URL {
    switch self {
    case .applicationJSON(let url):
      return url

    case .custom(let url):
      return url

    case .textCSS(let url):
      return url

    case .textCSV(let url):
      return url

    case .textHTML(let url):
      return url

    case .textPlain(let url):
      return url

    case .textXML(let url):
      return url
    }
  }

  /// Checks if the actual file extension in the `URL` matches the expected one for the content type.
  func isValidFileFormat() -> Bool {
    if expectedFileExtension == passpartout {
      return true
    }

    guard let fileExtension = fileLocation.absoluteString.split(separator: ".").last else {
      return false
    }

    return fileExtension == expectedFileExtension
  }
}

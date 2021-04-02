import Foundation

public extension Models {
  /// The list of supported content type inside the response body.
  enum ResponseContent {
    
    // MARK: Application
    
    /// `Content-Type: application/json`.
    case applicationJSON(url: URL)
    
    // MARK: Text
    
    /// `Content-Type: text/csv`.
    case textCSS(url: URL)
    
    /// `Content-Type: text/css`.
    case textCSV(url: URL)
    
    /// `Content-Type: text/html`.
    case textHTML(url: URL)
    
    /// `Content-Type: text/plain`.
    case textPlain(url: URL)
    
    /// `Content-Type: text/xml`.
    case textXML(url: URL)
    
    // MARK: Custom
    
    /// No preset configuration.
    /// This preset does not provide any validation.
    case custom(url: URL)
  }
}

internal extension Models.ResponseContent {
  /// The file extension associated with each type.
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
  
  /// The `URL` of where the file associated with the response is located.
  var fileLocation: URL {
    switch self {
    case .applicationJSON(let url),
         .textCSS(let url),
         .textCSV(let url),
         .textHTML(let url),
         .textPlain(let url),
         .textXML(let url),
         .custom(let url):
      return url
    }
  }
  
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
  
  /// Checks if the actual file extension in the `URL` matches the expected one for the content type.
  func isValidFileFormat() -> Bool {
    // This is nil only for `ResponseContent.custom`, in which case we do not check the validity of the format, and return true.
    guard let expectedFileExtension = self.expectedFileExtension else {
      return true
    }
    
    guard let fileExtension = fileLocation.absoluteString.split(separator: ".").last else {
      return false
    }
    
    return fileExtension == expectedFileExtension
  }
}

//
//  Mocka
//

import Foundation
import SwiftUI

struct AppSection: View {
  /// The app environment object.
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    switch appEnvironment.selectedSection {
    case .server:
      ServerSection()
      
    case .editor:
      ServerSection()
      
    case .console:
      ServerSection()
    }
  }
}

struct AppSectionPreview: PreviewProvider {
  static var previews: some View {
    AppSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(AppEnvironment())
  }
}

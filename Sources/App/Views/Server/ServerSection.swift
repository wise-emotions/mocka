import Foundation
import SwiftUI

struct ServerSection: View {
  var body: some View {
    HStack(spacing: 0) {
      NavigationView {
        ServerList(serverCalls: .constant([]))
        ServerDetail()
      }
      .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
  }
}

struct ServerSectionPreview: PreviewProvider {
  static var previews: some View {
    ServerSection()
      .previewLayout(.fixed(width: 1024, height: 600))
      .environmentObject(WindowManager.shared)
  }
}

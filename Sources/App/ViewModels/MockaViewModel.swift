import Foundation

final class MockaViewModel: ObservableObject {
  /// The selected app section, selected by using the app's Sidebar.
  @Published var selectedSection: SidebarSection = .server

  /// Whether the server is currently running.
  @Published var isServerRunning: Bool = false
}

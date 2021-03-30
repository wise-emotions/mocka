import SwiftUI

extension Sidebar {
  /// A button displaying a section of the app.
  struct Item: View {
    /// The selected section.
    @Binding var selectedSection: SidebarSection

    /// The section of the app to bind to the button.
    let section: SidebarSection

    /// Whether the button should be displayed as selected.
    private var isSelected: Bool { selectedSection == section }

    var body: some View {
      Button(action: {
        selectedSection = section
      }, label: {
        VStack(alignment: .center, spacing: 8) {
          Image(systemName: section.symbolName)
            .font(.system(size: 21))

          Text(section.title)
            .font(.system(size: 12))
        }
        .foregroundColor(isSelected ? Color.latte : Color.macchiato)
        .frame(width: 88, height: 88, alignment: .center)
        .background(isSelected ? Color(.controlAccentColor) : Color.clear)
        .contentShape(Rectangle())
      })
      .buttonStyle(PlainButtonStyle())
    }
  }
}

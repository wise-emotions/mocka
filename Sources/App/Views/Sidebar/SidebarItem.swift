//
//  Mocka
//

import SwiftUI

/// A button displaying a section of the app.
struct SidebarItem: View {

  // MARK: - Stored Properties

  /// The selected section.
  @Binding var selectedSection: SidebarSection

  /// The section of the app to bind to the button.
  let section: SidebarSection

  // MARK: - Computed Properties

  /// Whether the button should be displayed as selected.
  private var isSelected: Bool {
    selectedSection == section
  }

  // MARK: - Body

  var body: some View {
    Button(
      action: {
        selectedSection = section
      },
      label: {
        VStack(alignment: .center, spacing: 8) {
          Image(systemName: section.symbolName)
            .font(.system(size: 21))

          Text(section.title)
            .font(.system(size: 12))
        }
        .foregroundColor(isSelected ? Color.latte : Color.macchiato)
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: Size.fixedSidebarHeight,
          maxHeight: Size.fixedSidebarHeight,
          alignment: .center
        )
        .background(isSelected ? Color(.controlAccentColor) : Color.clear)
        .contentShape(Rectangle())
      }
    )
    .buttonStyle(PlainButtonStyle())
  }
}

// MARK: - Previews

struct SidebarItemPreviews: PreviewProvider {
  static var previews: some View {
    SidebarItem(selectedSection: .constant(.server), section: .server)
  }
}

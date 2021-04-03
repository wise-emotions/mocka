//
//  Mocka
//

import SwiftUI

struct WiseSegmentedControl<Item: Equatable>: View {
  @Binding var selection: Item
  let items: [Item]
  let itemTitles: [String]

  private var selectionIndex: Int {
    return items.firstIndex(where: { $0 == selection }) ?? 0
  }

  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      ForEach(0..<self.items.count, id: \.self) { index in
        Button(
          action: {
            selection = items[index]
          },
          label: {
            Text(self.itemTitles[index])
              .lineLimit(1)
              .font(.system(size: 13, weight: .regular, design: .default))
              .frame(minWidth: 74, minHeight: 22)
              .foregroundColor(index == selectionIndex ? Color.latte : Color.macchiato)
              .background(index == selectionIndex ? Color(.controlAccentColor) : Color.clear)
              .cornerRadius(5.0)
          }
        )
        .buttonStyle(PlainButtonStyle())
        .padding(1.0)
      }
    }
    .background(Color.espresso)
    .cornerRadius(6.0)
  }
}


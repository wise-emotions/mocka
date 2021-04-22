//
//  Mocka
//

import Cocoa
import MockaServer
import SwiftUI

/// A dropdown with rounded border.
struct RoundedBorderDropdown<Item: Hashable>: NSViewRepresentable {
  /// The coordinator object of the view.
  final class Coordinator {
    /// The selected item.
    private var selection: Binding<Item?>

    /// The list of item displayed in the menu.
    private let items: [Item]

    init(_ selection: Binding<Item?>, items: [Item]) {
      self.selection = selection
      self.items = items
    }

    @objc
    func changedSelection(_ sender: NSPopUpButton) {
      let selectedIndex = sender.indexOfSelectedItem

      guard selectedIndex >= 0 && selectedIndex < items.count else {
        return
      }

      selection.wrappedValue = items[selectedIndex]
    }
  }

  // MARK: - Stored Properties

  /// The title of the dropdown.
  let title: String

  /// A list of item to display in the menu.
  let items: [Item]

  /// The `KeyPath` leading to a `String` describing the item.
  let itemTitleKeyPath: KeyPath<Item, String>

  /// The selected item.
  @Binding var selection: Item?

  /// Whether the control is enabled or not.
  let isEnabled: Bool

  // MARK: - Functions

  func makeNSView(context: Context) -> NSRoundedBorderDropdown {
    let button = NSRoundedBorderDropdown(frame: .zero, pullsDown: false)
    button.isEnabled = isEnabled
    button.addItems(withTitles: items.map { $0[keyPath: itemTitleKeyPath] })
    // Remove selection for initial state, if no selection is already made.
    let selectionIndex = selection.flatMap { items.firstIndex(of: $0) }
    button.selectItem(at: selectionIndex ?? -1)
    button.setTitle(selection?[keyPath: itemTitleKeyPath] ?? title)
    button.target = context.coordinator
    button.action = #selector(context.coordinator.changedSelection)
    // Layout
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 36).isActive = true
    return button
  }

  func updateNSView(_ nsView: NSRoundedBorderDropdown, context: Context) {
    nsView.setTitle(selection?[keyPath: itemTitleKeyPath] ?? title)
    nsView.isEnabled = isEnabled
  }

  func makeCoordinator() -> Coordinator {
    Coordinator($selection, items: items)
  }
}

/// A subclass of `NSPopUpButton` with rounded border.
final class NSRoundedBorderDropdown: NSPopUpButton {

  // MARK: - UI Elements

  /// A `NSTextField` that displays text and does not support editing.
  private let titleLabel = NSTextField(labelWithString: "")

  /// A `NSImageView` that displays a chevron.
  private let disclosureImage = NSImageView()

  // MARK: - Computed Properties

  override var isEnabled: Bool {
    didSet {
      style()
    }
  }

  override init(frame buttonFrame: NSRect, pullsDown flag: Bool) {
    super.init(frame: buttonFrame, pullsDown: flag)

    setup()
    style()
  }

  required init?(coder: NSCoder) {
    return nil
  }

  override func draw(_ dirtyRect: NSRect) {
    let lineWidth: CGFloat = 1

    let path = NSBezierPath(
      roundedRect: dirtyRect.insetBy(dx: lineWidth, dy: lineWidth),
      xRadius: 6,
      yRadius: 6
    )
    path.lineWidth = lineWidth

    NSColor(.americano).setStroke()
    path.stroke()
  }

  override func drawFocusRingMask() {}

  private func setup() {
    addSubview(titleLabel)
    addSubview(disclosureImage)
  }

  private func style() {
    Self.styleTitleLabel(titleLabel, isEnabled: isEnabled)
    Self.styleDisclosureImage(disclosureImage, isEnabled: isEnabled)
  }

  override func layout() {
    super.layout()

    disclosureImage.frame.origin.x = bounds.maxX - bounds.height
    disclosureImage.frame.size = CGSize(width: bounds.height, height: bounds.height)

    titleLabel.frame.size.width = bounds.width - disclosureImage.frame.width
    titleLabel.frame.size.height = titleLabel.intrinsicContentSize.height
    titleLabel.frame.origin.x = 12
    titleLabel.frame.origin.y = (bounds.height - titleLabel.intrinsicContentSize.height) / 2
  }

  override func setTitle(_ string: String) {
    titleLabel.stringValue = string
  }
}

// MARK: - Styling Functions

private extension NSRoundedBorderDropdown {
  static func styleTitleLabel(_ label: NSTextField, isEnabled: Bool) {
    label.font = .systemFont(ofSize: 12)
    label.textColor = isEnabled ? NSColor(.latte) : NSColor(.americano)
  }

  static func styleDisclosureImage(_ imageView: NSImageView, isEnabled: Bool) {
    imageView.image = NSImage(systemSymbolName: "chevron.down", accessibilityDescription: "Dropdown disclosure")
    imageView.contentTintColor = isEnabled ? NSColor(.latte) : NSColor(.americano)
  }
}

// MARK: - Previews

struct RoundedBorderDropdownPreview: PreviewProvider {
  static var previews: some View {
    RoundedBorderDropdown(
      title: "Method",
      items: HTTPMethod.allCases,
      itemTitleKeyPath: \.rawValue,
      selection: .constant(HTTPMethod.get),
      isEnabled: true
    )
    .previewLayout(.fixed(width: 160, height: 64))
  }
}

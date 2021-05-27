//
//  Mocka
//

import Cocoa

/// A subclass of `NSPopUpButton` with rounded border.
final class NSRoundedBorderDropdown: NSPopUpButton {

  // MARK: - UI Elements

  /// A `NSTextField` that displays text and does not support editing.
  private let titleLabel = NSTextField(labelWithString: "")

  /// A `NSImageView` that displays a chevron.
  private let disclosureImage = NSImageView()

  // MARK: - Computed Properties

  override var alignmentRectInsets: NSEdgeInsets {
    // `NSPopUpButton` has alignment insets by default, which can cause issues when drawing and laying out the view.
    // Set to `.zero` since we don't need them.
    NSEdgeInsets()
  }

  override var isEnabled: Bool {
    didSet {
      style()
    }
  }

  override var isFlipped: Bool {
    true
  }

  // MARK: - Init

  override init(frame buttonFrame: NSRect, pullsDown flag: Bool) {
    super.init(frame: buttonFrame, pullsDown: flag)

    setup()
    style()
  }

  required init?(coder: NSCoder) {
    return nil
  }

  // MARK: - Functions

  override func draw(_ dirtyRect: NSRect) {
    let lineWidth: CGFloat = 1

    let path = NSBezierPath(
      roundedRect: dirtyRect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
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
    Self.styleTitleLabel(titleLabel, isEnabled: isEnabled, hasSelection: selectedItem != nil)
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
  static func styleTitleLabel(_ label: NSTextField, isEnabled: Bool, hasSelection: Bool) {
    label.font = .systemFont(ofSize: 12)
    label.textColor = isEnabled && hasSelection ? NSColor(.latte) : NSColor(.americano)
  }

  static func styleDisclosureImage(_ imageView: NSImageView, isEnabled: Bool) {
    imageView.image = NSImage(systemSymbolName: "chevron.down", accessibilityDescription: "Dropdown disclosure")
    imageView.contentTintColor = isEnabled ? NSColor(.latte) : NSColor(.americano)
  }
}

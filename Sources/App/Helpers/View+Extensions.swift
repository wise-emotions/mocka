//
//  Mocka
//

import SwiftUI

extension View {
  /// Whether or not the dark mode is enabled.
  var isDarkModeEnabled: Bool {
    Environment(\.colorScheme).wrappedValue == .dark
  }

  /// Hide or show the view based on a boolean value.
  ///
  /// Example for visibility:
  ///
  ///     Text("Label")
  ///         .isHidden(true)
  ///
  /// Example for complete removal:
  ///
  ///     Text("Label")
  ///         .isHidden(true, remove: true)
  ///
  /// - Author: [George-J-E/HidingViews](https://github.com/George-J-E/HidingViews)
  ///
  /// - Parameters:
  ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
  ///   - remove: Boolean value indicating whether or not to remove the view.
  /// - Returns: Returns the `View` with the applied modifier.
  @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
    if hidden {
      if remove.isFalse {
        self.hidden()
      }
    } else {
      self
    }
  }

  /// Hide or show the view based on a boolean value.
  ///
  /// Example for visibility:
  ///
  ///     Text("Label")
  ///         .isVisible(true)
  ///
  /// - Parameters:
  ///   - visible: Set to `true` to show the view. Set to `false` to hide the view.
  /// - Returns: Returns the `View` with the applied modifier.
  @ViewBuilder func isVisible(_ visible: Bool) -> some View {
    isHidden(visible.inverted())
  }

  /// Adds a condition that controls whether users can interact with this view.
  ///
  /// The higher views in a view hierarchy can override the value you set on this view.
  /// In the following example, the button isn’t interactive because the outer enabled(_:) modifier overrides the inner one:
  /// ```swift
  /// HStack {
  ///   Button(Text("Press")) {}
  ///     .enabled(true)
  /// }
  /// .enabled(false)
  /// ```
  /// - Parameter enabled: A Boolean value that determines whether users can interact with this view.
  @ViewBuilder func enabled(_ enabled: Bool) -> some View {
    disabled(enabled.inverted())
  }

  /// Conditionally composites this view’s contents into an offscreen image before final display.
  ///
  /// Example for drawing:
  ///
  ///     List(elements) { element in
  ///       Text(element)
  ///     }
  ///     .drawingGroup(mode == .read)
  ///
  /// - Parameters:
  ///   - active: Set to `true` to activate the `.drawingGroup` `View` modifier, otherwise set it to `false`.
  ///   - opaque: A Boolean value that indicates whether the image is opaque.
  ///             If set to `true`, the alpha channel of the image must be `1`.
  ///             The default is `false`.
  ///   - colorMode: One of the working color space and storage formats defined in `ColorRenderingMode`.
  ///                The default is `.nonLinear`.
  /// - Returns: If `active` is `true` returns a view that composites this view’s contents into an offscreen image before display.
  @ViewBuilder func drawingGroup(
    on active: Bool,
    opaque: Bool = false,
    colorMode: ColorRenderingMode = .nonLinear
  ) -> some View {
    if active {
      self.drawingGroup()
    } else {
      self
    }
  }

  /// Creates a `Copy Value` context menu.
  ///
  /// Example of usage:
  ///
  ///     Text(text)
  ///       .contextMenuCopy(text)
  ///
  /// - Parameters:
  ///   - text: The context menu text. Default is `Copy Value`.
  ///   - string: The `String` to be copied into the pasteboard.
  /// - Returns: Returns the `View` with the applied modifier.
  @ViewBuilder func contextMenuCopy(text: String = "Copy Value", _ string: String) -> some View {
    self.contextMenu {
      Button(
        action: {
          NSPasteboard.general.clearContents()
          NSPasteboard.general.setString(string, forType: .string)
        }
      ) {
        Text(text)
      }
    }
  }
}

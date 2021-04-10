//
//  Mocka
//

import SwiftUI

extension View {
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
      if !remove {
        self.hidden()
      }
    } else {
      self
    }
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
  /// - Parameter string: The `String` to be copied into the pasteboard.
  /// - Returns: Returns the `View` with the applied modifier.
  @ViewBuilder func contextMenuCopy(_ string: String) -> some View {
    self.contextMenu {
      Button(action: {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
      }) {
        Text("Copy Value")
      }
    }
  }
}

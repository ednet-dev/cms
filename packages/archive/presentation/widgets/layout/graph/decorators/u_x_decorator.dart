import 'dart:ui';

/// A decorator for enhancing the user experience of visualization elements.
///
/// Decorators can add visual effects, animations, or other enhancements to
/// visualization elements without changing their core behavior.
abstract class UXDecorator {
  /// Applies the decorator to a specific position on the canvas.
  ///
  /// This method is called for targeted decorations at specific points.
  ///
  /// Parameters:
  /// - canvas: The canvas to draw on
  /// - position: The position to apply the decoration
  /// - scale: The current zoom scale
  void apply(Canvas canvas, Offset position, double scale);

  /// Renders the decorator on the entire canvas.
  ///
  /// This method is called to render decorations that affect the entire view.
  /// It can be called in pre-render (before elements) or post-render (after elements) phase.
  ///
  /// Parameters:
  /// - canvas: The canvas to draw on
  /// - size: The size of the canvas
  void render(Canvas canvas, Size size);
}

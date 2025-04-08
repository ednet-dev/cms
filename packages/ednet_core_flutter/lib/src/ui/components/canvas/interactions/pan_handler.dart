part of ednet_core_flutter;

/// A handler for pan gestures on the canvas.
///
/// This class encapsulates the logic for handling pan gestures,
/// updating the transformation matrix accordingly.
///
/// This component is part of the EDNet Shell Architecture's visualization system
/// for domain model canvases.
class PanHandler {
  final TransformationController transformationController;
  bool _isDragging = false;

  /// Optional callback for when dragging state changes
  final ValueChanged<bool>? onDraggingChanged;

  /// Constructor for PanHandler
  PanHandler({
    required this.transformationController,
    this.onDraggingChanged,
  });

  /// Called when a drag/pan interaction starts
  void onPanStart(ScaleStartDetails details) {
    _isDragging = true;
    if (onDraggingChanged != null) {
      onDraggingChanged!(true);
    }
  }

  /// Called when a drag/pan interaction ends
  void onPanEnd(ScaleEndDetails details) {
    _isDragging = false;
    if (onDraggingChanged != null) {
      onDraggingChanged!(false);
    }
  }

  /// Updates the transformation based on the focal point delta
  void onPanUpdate(ScaleUpdateDetails details) {
    // Skip if this is a scale/zoom operation rather than a pan
    if (details.scale != 1.0) return;

    // Update the transformation to translate by the focal point delta
    transformationController.value = transformationController.value
      ..translate(details.focalPointDelta.dx, details.focalPointDelta.dy);
  }

  /// Returns whether a drag is currently in progress
  bool get isDragging => _isDragging;
}

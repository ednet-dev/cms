import 'package:flutter/material.dart';

/// A handler for pan gestures on the canvas.
///
/// This class encapsulates the logic for handling pan gestures,
/// updating the transformation matrix accordingly.
class PanHandler {
  final TransformationController transformationController;
  bool _isDragging = false;

  PanHandler({required this.transformationController});

  /// Called when a drag/pan interaction starts
  void onPanStart(ScaleStartDetails details) {
    _isDragging = true;
  }

  /// Called when a drag/pan interaction ends
  void onPanEnd(ScaleEndDetails details) {
    _isDragging = false;
  }

  /// Updates the transformation based on the focal point delta
  void onPanUpdate(ScaleUpdateDetails details) {
    // Update the transformation to translate by the focal point delta
    transformationController.value =
        transformationController.value
          ..translate(details.focalPointDelta.dx, details.focalPointDelta.dy);
  }

  /// Returns whether a drag is currently in progress
  bool get isDragging => _isDragging;
}

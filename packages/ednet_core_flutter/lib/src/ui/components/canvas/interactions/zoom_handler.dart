part of ednet_core_flutter;

/// A handler for zoom gestures on the canvas.
///
/// This class encapsulates the logic for handling zoom gestures,
/// updating the transformation matrix and tracking the zoom level.
///
/// This component is part of the EDNet Shell Architecture's visualization system
/// for domain model canvases.
class ZoomHandler {
  final TransformationController transformationController;
  double _zoomLevel = 1.0;
  final double minZoom;
  final double maxZoom;
  final ValueChanged<double>? onZoomLevelChanged;

  /// Optional callback for after zooming is complete
  final VoidCallback? onZoomComplete;

  /// Constructor for ZoomHandler
  ZoomHandler({
    required this.transformationController,
    this.minZoom = 0.1,
    this.maxZoom = 5.0,
    this.onZoomLevelChanged,
    this.onZoomComplete,
  });

  /// Zooms by the specified scale factor
  void zoom(double scaleFactor, {Offset? focalPoint}) {
    final newZoomLevel = (_zoomLevel * scaleFactor).clamp(minZoom, maxZoom);

    // Only update if the zoom level actually changed
    if (newZoomLevel != _zoomLevel) {
      final oldZoomLevel = _zoomLevel;
      _zoomLevel = newZoomLevel;

      // If focal point is provided, zoom around that point
      if (focalPoint != null) {
        final focalPointScene = transformationController.toScene(focalPoint);

        // Apply new scale but maintain focal point position
        transformationController.value = Matrix4.identity()
          ..translate(
            focalPointScene.dx -
                (focalPointScene.dx * newZoomLevel / oldZoomLevel),
            focalPointScene.dy -
                (focalPointScene.dy * newZoomLevel / oldZoomLevel),
          )
          ..scale(_zoomLevel);
      } else {
        // Simple scaling from the origin if no focal point
        transformationController.value = Matrix4.identity()..scale(_zoomLevel);
      }

      if (onZoomLevelChanged != null) {
        onZoomLevelChanged!(_zoomLevel);
      }

      if (onZoomComplete != null) {
        onZoomComplete!();
      }
    }
  }

  /// Updates zoom based on scale gesture
  void onZoomUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      zoom(
        details.scale,
        focalPoint: details.localFocalPoint,
      );
    }
  }

  /// Centers the view and applies an appropriate zoom level to fit the content
  void centerAndZoom(Size canvasSize, Map<String, Offset> layoutPositions) {
    if (layoutPositions.isEmpty) return;

    final double minX = layoutPositions.values
        .map((offset) => offset.dx)
        .reduce((a, b) => a < b ? a : b);
    final double maxX = layoutPositions.values
        .map((offset) => offset.dx)
        .reduce((a, b) => a > b ? a : b);
    final double minY = layoutPositions.values
        .map((offset) => offset.dy)
        .reduce((a, b) => a < b ? a : b);
    final double maxY = layoutPositions.values
        .map((offset) => offset.dy)
        .reduce((a, b) => a > b ? a : b);

    final double graphWidth = maxX - minX;
    final double graphHeight = maxY - minY;

    // Apply some padding
    final double paddingFactor = 400;
    final double scaleX = canvasSize.width / (graphWidth + 2 * paddingFactor);
    final double scaleY = canvasSize.height / (graphHeight + 2 * paddingFactor);
    final double scale = (scaleX < scaleY ? scaleX : scaleY).clamp(
      minZoom,
      maxZoom,
    );

    final double offsetX =
        (canvasSize.width - graphWidth * scale) / 2 - minX * scale;
    final double offsetY =
        (canvasSize.height - graphHeight * scale) / 2 - minY * scale;

    transformationController.value = Matrix4.identity()
      ..translate(offsetX, offsetY)
      ..scale(scale);

    _zoomLevel = scale;

    if (onZoomLevelChanged != null) {
      onZoomLevelChanged!(_zoomLevel);
    }

    if (onZoomComplete != null) {
      onZoomComplete!();
    }
  }

  /// Gets the current zoom level
  double get zoomLevel => _zoomLevel;

  /// Sets the zoom level directly
  set zoomLevel(double value) {
    _zoomLevel = value.clamp(minZoom, maxZoom);
    if (onZoomLevelChanged != null) {
      onZoomLevelChanged!(_zoomLevel);
    }
  }
}

import 'dart:math' as math;
import 'dart:ui';

/// Represents a rectangle in 2D space that can contain packed items.
class Bin {
  final Rect rect;
  bool used = false;
  Bin? right;
  Bin? down;

  Bin(this.rect);
}

/// A bin packing algorithm for optimal label placement in visualizations.
///
/// This implementation optimizes the placement of labels or other UI elements
/// to avoid overlaps in dense visualizations.
class BinPacking {
  /// Find an optimal position for a new item within the available space.
  ///
  /// Returns the top-left position for the item, or null if no space is available.
  static Offset? findPosition(
    List<Rect> existingItems,
    Size containerSize,
    Size itemSize,
  ) {
    // Create initial bin representing the entire container
    final root = Bin(
      Rect.fromLTWH(0, 0, containerSize.width, containerSize.height),
    );

    // Add existing items to mark space as used
    for (final item in existingItems) {
      _placeRect(root, item);
    }

    // Find space for the new item
    final target = _findBin(root, itemSize.width, itemSize.height);
    if (target != null) {
      _splitBin(target, itemSize.width, itemSize.height);
      return target.rect.topLeft;
    }

    return null;
  }

  /// Find positions for multiple items of the same size.
  ///
  /// Returns a list of positions, with null values for items that couldn't be placed.
  static List<Offset?> findPositionsForMany(
    List<Rect> existingItems,
    Size containerSize,
    List<Size> itemSizes,
  ) {
    // Create initial bin representing the entire container
    final root = Bin(
      Rect.fromLTWH(0, 0, containerSize.width, containerSize.height),
    );

    // Add existing items to mark space as used
    for (final item in existingItems) {
      _placeRect(root, item);
    }

    // Find space for each new item
    final results = <Offset?>[];
    for (final size in itemSizes) {
      final target = _findBin(root, size.width, size.height);
      if (target != null) {
        _splitBin(target, size.width, size.height);
        results.add(target.rect.topLeft);
      } else {
        results.add(null);
      }
    }

    return results;
  }

  /// Optimize placement of labels around their anchor points.
  ///
  /// This is useful for placing labels near nodes in a graph visualization.
  /// Returns the optimal positions for each label.
  static List<Offset> optimizeLabelPlacements(
    List<LabelPlacementRequest> requests,
    Size containerSize,
  ) {
    // Sort requests by priority (if specified) to place important labels first
    requests.sort((a, b) => b.priority.compareTo(a.priority));

    final placedLabels = <Rect>[];
    final results = List<Offset>.filled(requests.length, Offset.zero);

    // Process each request in priority order
    for (int i = 0; i < requests.length; i++) {
      final request = requests[i];
      final labelSize = request.size;

      // Try each of the 8 possible positions around the anchor point
      final candidatePositions = _getCandidatePositions(
        request.anchorPoint,
        labelSize,
        containerSize,
      );

      // Find the best position (closest to anchor with no overlaps)
      Offset bestPosition = request.anchorPoint;
      double bestScore = double.infinity;

      for (final position in candidatePositions) {
        final labelRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          labelSize.width,
          labelSize.height,
        );

        // Skip if outside container bounds
        if (!Rect.fromLTWH(
          0,
          0,
          containerSize.width,
          containerSize.height,
        ).contains(position)) {
          continue;
        }

        // Skip if overlapping any existing labels
        if (placedLabels.any((placed) => placed.overlaps(labelRect))) {
          continue;
        }

        // Calculate score based on distance from anchor point
        final score = (position - request.anchorPoint).distance;
        if (score < bestScore) {
          bestScore = score;
          bestPosition = position;
        }
      }

      // Use the best position found
      results[i] = bestPosition;

      // Add this label to the placed list to avoid future overlaps
      placedLabels.add(
        Rect.fromLTWH(
          bestPosition.dx,
          bestPosition.dy,
          labelSize.width,
          labelSize.height,
        ),
      );
    }

    return results;
  }

  /// Recursive function to find an appropriate bin for the new item.
  static Bin? _findBin(Bin root, double width, double height) {
    // Try to find a space in existing bins
    if (root.used) {
      final rightBin =
          root.right != null ? _findBin(root.right!, width, height) : null;
      return rightBin ??
          (root.down != null ? _findBin(root.down!, width, height) : null);
    }

    // Check if this bin is large enough
    if (width <= root.rect.width && height <= root.rect.height) {
      return root;
    }

    return null;
  }

  /// Split a bin into used and free areas after placing an item.
  static void _splitBin(Bin bin, double width, double height) {
    bin.used = true;

    // Create right bin (remaining horizontal space)
    bin.right = Bin(
      Rect.fromLTWH(
        bin.rect.left + width,
        bin.rect.top,
        bin.rect.width - width,
        height,
      ),
    );

    // Create down bin (remaining vertical space)
    bin.down = Bin(
      Rect.fromLTWH(
        bin.rect.left,
        bin.rect.top + height,
        bin.rect.width,
        bin.rect.height - height,
      ),
    );
  }

  /// Place an existing rectangle in the bin tree.
  static void _placeRect(Bin root, Rect rect) {
    // Find bin that can contain this rect
    final target = _findBin(root, rect.width, rect.height);

    // Mark the space as used
    if (target != null) {
      _splitBin(target, rect.width, rect.height);
    }
  }

  /// Get candidate positions around an anchor point for label placement.
  static List<Offset> _getCandidatePositions(
    Offset anchor,
    Size labelSize,
    Size containerSize,
  ) {
    final halfWidth = labelSize.width / 2;
    final halfHeight = labelSize.height / 2;

    return [
      // 8 positions around the anchor point
      Offset(
        anchor.dx - labelSize.width,
        anchor.dy - labelSize.height,
      ), // Top-left
      Offset(anchor.dx - halfWidth, anchor.dy - labelSize.height), // Top-center
      Offset(anchor.dx, anchor.dy - labelSize.height), // Top-right
      Offset(
        anchor.dx - labelSize.width,
        anchor.dy - halfHeight,
      ), // Middle-left
      Offset(anchor.dx, anchor.dy - halfHeight), // Middle-right
      Offset(anchor.dx - labelSize.width, anchor.dy), // Bottom-left
      Offset(anchor.dx - halfWidth, anchor.dy), // Bottom-center
      Offset(anchor.dx, anchor.dy), // Bottom-right
    ];
  }
}

/// A request for label placement optimization.
class LabelPlacementRequest {
  /// The anchor point to which the label should be attached
  final Offset anchorPoint;

  /// The size of the label
  final Size size;

  /// Priority of this label (higher values are placed first)
  final double priority;

  LabelPlacementRequest({
    required this.anchorPoint,
    required this.size,
    this.priority = 1.0,
  });
}

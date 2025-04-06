import 'dart:math';
import 'dart:ui';

/// An enhanced quadtree for spatial indexing with advanced query capabilities.
///
/// This implementation extends the basic quadtree with nearest-neighbor search,
/// range queries, and other optimizations for visualization performance.
class EnhancedQuadtree<T> {
  final Rect bounds;
  final int capacity;
  final List<QuadPoint<T>> points;
  EnhancedQuadtree<T>? northwest, northeast, southwest, southeast;
  bool divided = false;

  /// Creates a new quadtree with the specified bounds and capacity.
  ///
  /// The capacity determines how many points can be stored in a single node
  /// before it subdivides.
  EnhancedQuadtree({required this.bounds, this.capacity = 4}) : points = [];

  /// Inserts a point with associated data into the quadtree.
  ///
  /// Returns true if the point was successfully inserted, false otherwise.
  bool insert(T data, Offset point) {
    if (!bounds.contains(point)) {
      return false;
    }

    if (points.length < capacity) {
      points.add(QuadPoint(data: data, position: point));
      return true;
    }

    if (!divided) {
      subdivide();
    }

    if (northwest!.insert(data, point)) return true;
    if (northeast!.insert(data, point)) return true;
    if (southwest!.insert(data, point)) return true;
    if (southeast!.insert(data, point)) return true;

    return false;
  }

  /// Subdivides this node into four quadrants.
  void subdivide() {
    final halfWidth = bounds.width / 2;
    final halfHeight = bounds.height / 2;
    final centerX = bounds.left + halfWidth;
    final centerY = bounds.top + halfHeight;

    northwest = EnhancedQuadtree<T>(
      bounds: Rect.fromLTWH(bounds.left, bounds.top, halfWidth, halfHeight),
      capacity: capacity,
    );

    northeast = EnhancedQuadtree<T>(
      bounds: Rect.fromLTWH(centerX, bounds.top, halfWidth, halfHeight),
      capacity: capacity,
    );

    southwest = EnhancedQuadtree<T>(
      bounds: Rect.fromLTWH(bounds.left, centerY, halfWidth, halfHeight),
      capacity: capacity,
    );

    southeast = EnhancedQuadtree<T>(
      bounds: Rect.fromLTWH(centerX, centerY, halfWidth, halfHeight),
      capacity: capacity,
    );

    divided = true;
  }

  /// Finds the nearest neighbor to the query point.
  ///
  /// Returns the data and position of the nearest point, or null if the tree is empty.
  /// The maxDistance parameter can be used to limit the search radius.
  QuadPoint<T>? findNearestNeighbor(
    Offset queryPoint, {
    double maxDistance = double.infinity,
  }) {
    _BestMatch<T> best = _BestMatch<T>(maxDistance: maxDistance);
    _findNearest(queryPoint, best);
    return best.bestMatch;
  }

  /// Internal method to recursively find the nearest point.
  void _findNearest(Offset queryPoint, _BestMatch<T> best) {
    if (!bounds.inflate(best.distance).contains(queryPoint)) {
      return;
    }

    // Check points at this level
    for (var point in points) {
      final distance = (point.position - queryPoint).distance;
      if (distance < best.distance) {
        best.distance = distance;
        best.bestMatch = point;
      }
    }

    // Early return if this node has no children
    if (!divided) return;

    // Determine which quadrant the query point is in to check it first
    // This optimization helps find a good match early
    final centerX = bounds.left + bounds.width / 2;
    final centerY = bounds.top + bounds.height / 2;

    final northwestDist = _minDistToRect(queryPoint, northwest!.bounds);
    final northeastDist = _minDistToRect(queryPoint, northeast!.bounds);
    final southwestDist = _minDistToRect(queryPoint, southwest!.bounds);
    final southeastDist = _minDistToRect(queryPoint, southeast!.bounds);

    // Create a list of quadrants sorted by distance to query point
    final quadrants = [
      (northwest!, northwestDist),
      (northeast!, northeastDist),
      (southwest!, southwestDist),
      (southeast!, southeastDist),
    ]..sort((a, b) => a.$2.compareTo(b.$2));

    // Check each quadrant in order of increasing distance
    for (var quadrant in quadrants) {
      if (quadrant.$2 < best.distance) {
        quadrant.$1._findNearest(queryPoint, best);
      }
    }
  }

  /// Calculates the minimum distance from a point to a rectangle.
  double _minDistToRect(Offset point, Rect rect) {
    final dx = _maxOfThree(rect.left - point.dx, 0, point.dx - rect.right);
    final dy = _maxOfThree(rect.top - point.dy, 0, point.dy - rect.bottom);
    return sqrt(dx * dx + dy * dy);
  }

  /// Helper function to get the maximum of three values.
  double _maxOfThree(double a, double b, double c) {
    return max(max(a, b), c);
  }

  /// Queries all points within a range of the query point.
  ///
  /// The range is specified as a radius around the query point.
  /// Results are added to the provided list.
  void queryRange(Offset queryPoint, double radius, List<QuadPoint<T>> result) {
    if (!bounds.inflate(radius).contains(queryPoint)) {
      return;
    }

    for (var point in points) {
      if ((point.position - queryPoint).distance <= radius) {
        result.add(point);
      }
    }

    if (!divided) return;

    northwest!.queryRange(queryPoint, radius, result);
    northeast!.queryRange(queryPoint, radius, result);
    southwest!.queryRange(queryPoint, radius, result);
    southeast!.queryRange(queryPoint, radius, result);
  }

  /// Queries all points contained within a rectangle.
  ///
  /// Results are added to the provided list.
  void queryRect(Rect queryRect, List<QuadPoint<T>> result) {
    if (!bounds.overlaps(queryRect)) {
      return;
    }

    for (var point in points) {
      if (queryRect.contains(point.position)) {
        result.add(point);
      }
    }

    if (!divided) return;

    northwest!.queryRect(queryRect, result);
    northeast!.queryRect(queryRect, result);
    southwest!.queryRect(queryRect, result);
    southeast!.queryRect(queryRect, result);
  }

  /// Returns true if the quadtree is empty.
  bool get isEmpty => points.isEmpty && !divided;

  /// Returns the total number of points in the quadtree.
  int count() {
    int total = points.length;
    if (divided) {
      total += northwest!.count();
      total += northeast!.count();
      total += southwest!.count();
      total += southeast!.count();
    }
    return total;
  }

  /// Clears all points from the quadtree.
  void clear() {
    points.clear();
    if (divided) {
      northwest!.clear();
      northeast!.clear();
      southwest!.clear();
      southeast!.clear();
      divided = false;
      northwest = null;
      northeast = null;
      southwest = null;
      southeast = null;
    }
  }

  /// Visualizes the quadtree structure by drawing its boundaries.
  ///
  /// This is useful for debugging and visualization purposes.
  void visualize(Canvas canvas, Paint paint) {
    // Draw this node's boundary
    canvas.drawRect(bounds, paint);

    // Recursively draw children
    if (divided) {
      northwest!.visualize(canvas, paint);
      northeast!.visualize(canvas, paint);
      southwest!.visualize(canvas, paint);
      southeast!.visualize(canvas, paint);
    }
  }
}

/// A point stored in the quadtree with associated data.
class QuadPoint<T> {
  final T data;
  final Offset position;

  QuadPoint({required this.data, required this.position});
}

/// Helper class for nearest neighbor search.
class _BestMatch<T> {
  double distance;
  QuadPoint<T>? bestMatch;

  _BestMatch({required double maxDistance}) : distance = maxDistance;
}

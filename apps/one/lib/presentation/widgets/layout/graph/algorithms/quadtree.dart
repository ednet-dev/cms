import 'dart:ui';

class Quadtree {
  final Rect bounds;
  final int capacity;
  final List<MapEntry<String, Offset>> points;
  Quadtree? northwest, northeast, southwest, southeast;
  bool divided = false;

  Quadtree({required this.bounds, this.capacity = 4}) : points = [];

  bool insert(String key, Offset point) {
    if (!bounds.contains(point)) {
      return false;
    }

    if (points.length < capacity) {
      points.add(MapEntry(key, point));
      return true;
    }

    if (!divided) {
      subdivide();
    }

    if (northwest!.insert(key, point)) return true;
    if (northeast!.insert(key, point)) return true;
    if (southwest!.insert(key, point)) return true;
    if (southeast!.insert(key, point)) return true;

    return false;
  }

  void subdivide() {
    final halfWidth = bounds.width / 2;
    final halfHeight = bounds.height / 2;
    final centerX = bounds.left + halfWidth;
    final centerY = bounds.top + halfHeight;

    northwest = Quadtree(
        bounds: Rect.fromLTWH(bounds.left, bounds.top, halfWidth, halfHeight));
    northeast = Quadtree(
        bounds: Rect.fromLTWH(centerX, bounds.top, halfWidth, halfHeight));
    southwest = Quadtree(
        bounds: Rect.fromLTWH(bounds.left, centerY, halfWidth, halfHeight));
    southeast = Quadtree(
        bounds: Rect.fromLTWH(centerX, centerY, halfWidth, halfHeight));

    divided = true;
  }

  void query(Offset point, Function(String, Offset) callback) {
    if (!bounds.contains(point)) {
      return;
    }

    for (var entry in points) {
      callback(entry.key, entry.value);
    }

    if (divided) {
      northwest!.query(point, callback);
      northeast!.query(point, callback);
      southwest!.query(point, callback);
      southeast!.query(point, callback);
    }
  }
}

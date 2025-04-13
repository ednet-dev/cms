// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





class Point {
  /// The x-coordinate.
  final double x;

  /// The y-coordinate.
  final double y;

  /// Creates a new point.
  const Point(this.x, this.y);

  /// Creates a Point from a JSON map.
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point((json['x'] as num).toDouble(), (json['y'] as num).toDouble());
  }

  /// Converts this Point to a JSON map.
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Point($x, $y)';
}

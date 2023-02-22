import 'package:flutter/material.dart';

class Node {
  final String id;
  final String label;
  final double size;
  final Paint paint;
  final TextStyle textStyle;
  final double angle;

  const Node({
    required this.id,
    required this.label,
    required this.size,
    required this.paint,
    required this.textStyle,
    required this.angle,
  });

  @override
  String toString() {
    return 'Node{id: $id, label: $label, size: $size, paint: $paint, textStyle: $textStyle, angle: $angle}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          size == other.size &&
          paint == other.paint &&
          textStyle == other.textStyle &&
          angle == other.angle;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      size.hashCode ^
      paint.hashCode ^
      textStyle.hashCode ^
      angle.hashCode;

  Node copyWith({
    String? id,
    String? label,
    double? size,
    Paint? paint,
    TextStyle? textStyle,
    double? angle,
  }) {
    return Node(
      id: id ?? this.id,
      label: label ?? this.label,
      size: size ?? this.size,
      paint: paint ?? this.paint,
      textStyle: textStyle ?? this.textStyle,
      angle: angle ?? this.angle,
    );
  }
}

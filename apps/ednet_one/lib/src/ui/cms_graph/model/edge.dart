import 'package:flutter/material.dart';

import 'node.dart';

class Edge {
  final Node source;
  final Node target;
  final String label;
  final Paint paint;
  final TextStyle textStyle;

  Edge({
    required this.source,
    required this.target,
    required this.label,
    required this.paint,
    required this.textStyle,
  });

  @override
  String toString() {
    return 'Edge{source: $source, target: $target, label: $label, paint: $paint, textStyle: $textStyle}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edge &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          target == other.target &&
          label == other.label &&
          paint == other.paint &&
          textStyle == other.textStyle;

  @override
  int get hashCode =>
      source.hashCode ^
      target.hashCode ^
      label.hashCode ^
      paint.hashCode ^
      textStyle.hashCode;

  Edge copyWith({
    Node? source,
    Node? target,
    String? label,
    Paint? paint,
    TextStyle? textStyle,
  }) {
    return Edge(
      source: source ?? this.source,
      target: target ?? this.target,
      label: label ?? this.label,
      paint: paint ?? this.paint,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

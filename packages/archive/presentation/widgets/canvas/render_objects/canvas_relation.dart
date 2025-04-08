import 'package:flutter/material.dart';

/// Represents a relationship between entities on the canvas.
///
/// This class encapsulates all the data needed for rendering a relationship,
/// including its source and destination points, labels, and visual properties.
class CanvasRelation {
  final String id;
  final String sourceId;
  final String destinationId;
  final Offset startPoint;
  final Offset endPoint;
  final String fromToLabel;
  final String toFromLabel;
  final Color color;
  final double strokeWidth;
  final bool isSelected;
  final RelationType type;
  final bool isDashed;

  /// Creates a new canvas relation with the given properties
  const CanvasRelation({
    required this.id,
    required this.sourceId,
    required this.destinationId,
    required this.startPoint,
    required this.endPoint,
    this.fromToLabel = '',
    this.toFromLabel = '',
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.isSelected = false,
    this.type = RelationType.normal,
    this.isDashed = false,
  });

  /// The path that represents this relation
  Path get path {
    final Path path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);
    return path;
  }

  /// Gets the midpoint of this relation
  Offset get midPoint {
    return Offset(
      (startPoint.dx + endPoint.dx) / 2,
      (startPoint.dy + endPoint.dy) / 2,
    );
  }

  /// Creates a copy of this relation with the given properties changed
  CanvasRelation copyWith({
    String? id,
    String? sourceId,
    String? destinationId,
    Offset? startPoint,
    Offset? endPoint,
    String? fromToLabel,
    String? toFromLabel,
    Color? color,
    double? strokeWidth,
    bool? isSelected,
    RelationType? type,
    bool? isDashed,
  }) {
    return CanvasRelation(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      destinationId: destinationId ?? this.destinationId,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      fromToLabel: fromToLabel ?? this.fromToLabel,
      toFromLabel: toFromLabel ?? this.toFromLabel,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isSelected: isSelected ?? this.isSelected,
      type: type ?? this.type,
      isDashed: isDashed ?? this.isDashed,
    );
  }
}

/// The type of relationship being rendered
enum RelationType { normal, inheritance, composition, aggregation, association }

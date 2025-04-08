import 'package:flutter/material.dart';

/// Represents an entity to be rendered on the canvas.
///
/// This class encapsulates all the data needed for rendering an entity,
/// including its position, color, and other visual properties.
class CanvasEntity {
  final String id;
  final String label;
  final Offset position;
  final Color color;
  final bool isSelected;
  final EntityType type;
  final Map<String, dynamic> metadata;

  /// The width of the entity box
  final double width;

  /// The height of the entity box
  final double height;

  /// Creates a new canvas entity with the given properties
  const CanvasEntity({
    required this.id,
    required this.label,
    required this.position,
    required this.color,
    this.isSelected = false,
    this.type = EntityType.concept,
    this.metadata = const {},
    this.width = 100,
    this.height = 50,
  });

  /// The rectangle that represents this entity's bounds
  Rect get bounds =>
      Rect.fromCenter(center: position, width: width, height: height);

  /// Creates a copy of this entity with the given properties changed
  CanvasEntity copyWith({
    String? id,
    String? label,
    Offset? position,
    Color? color,
    bool? isSelected,
    EntityType? type,
    Map<String, dynamic>? metadata,
    double? width,
    double? height,
  }) {
    return CanvasEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

/// The type of entity being rendered
enum EntityType { domain, model, concept, attribute, relationship }

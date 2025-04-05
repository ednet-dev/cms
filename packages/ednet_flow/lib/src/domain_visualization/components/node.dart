// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';



/// Represents a node in a domain model graph.
///
/// A Node represents a vertex in the graph with:
/// - A unique identifier
/// - A specific type defining its role in the domain model
/// - A position in the visualization space
/// - Visual properties for rendering
/// - Optional connection to EDNet Core domain model elements
///
/// Nodes are the fundamental building blocks of domain model visualizations,
/// representing entities, value objects, events, and other domain concepts.
class Node {
  /// The unique identifier for this node.
  final String id;

  /// The display label for this node.
  final String label;

  /// A more detailed description of this node.
  final String description;

  /// The type of this node (e.g., entity, value object, event).
  final NodeType type;

  /// The position of this node in the visualization.
  final Offset position;

  /// The visual size of this node.
  final double size;

  /// The color used to render this node.
  final Color color;

  /// Additional properties for this node.
  final Map<String, dynamic> properties;

  /// Optional reference to an EDNet Core domain entity.
  final Entity? entity;

  /// Creates a new node.
  const Node({
    required this.id,
    required this.label,
    this.description = '',
    required this.type,
    required this.position,
    this.size = 50.0,
    required this.color,
    this.properties = const {},
    this.entity,
  });

  /// Creates a node from an entity in the domain model.
  ///
  /// This factory method automatically sets appropriate properties based on
  /// the entity's characteristics, making it easy to visualize domain entities.
  factory Node.fromEntity(Entity entity, {Offset? position}) {
    // Determine if this entity is an aggregate root
    final isAggregateRoot = entity.concept?.entry ?? false;

    // Choose appropriate node type
    final nodeType = isAggregateRoot ? NodeType.aggregateRoot : NodeType.entity;

    // Choose appropriate color
    final color =
        isAggregateRoot
            ? const Color(0xFFE57373) // Light red for aggregate roots
            : const Color(0xFF90CAF9); // Light blue for regular entities

    return Node(
      id: entity.oid.toString(),
      label: entity.toString(),
      description: entity.description ?? '',
      type: nodeType,
      position: position ?? Offset.zero,
      color: color,
      entity: entity,
      properties: {
        'conceptName': entity.concept?.name ?? 'Unknown',
        'isAggregateRoot': isAggregateRoot,
        'attributes': entity.attributeMap.keys.toList(),
      },
    );
  }

  /// Creates a copy of this node with the specified properties replaced.
  Node copyWith({
    String? id,
    String? label,
    String? description,
    NodeType? type,
    Offset? position,
    double? size,
    Color? color,
    Map<String, dynamic>? properties,
    Entity? entity,
  }) {
    return Node(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      properties: properties ?? this.properties,
      entity: entity ?? this.entity,
    );
  }

  /// Converts this node to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'type': type.toString(),
      'position': {'x': position.dx, 'y': position.dy},
      'size': size,
      'color': color.value,
      'properties': properties,
    };
  }

  /// Creates a node from a JSON map.
  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String? ?? '',
      type: NodeType.fromString(json['type'] as String),
      position: Offset(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      size: (json['size'] as num).toDouble(),
      color: Color(json['color'] as int),
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Node) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

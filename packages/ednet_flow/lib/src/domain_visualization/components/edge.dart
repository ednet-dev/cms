// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';



/// Represents an edge in a domain model graph.
///
/// An Edge represents a relationship between two nodes in the graph:
/// - A [source] node where the edge originates
/// - A [target] node where the edge terminates
/// - A [type] defining the edge's characteristics (e.g., association, composition)
/// - A [direction] specifying the edge's orientation
/// - Various visual properties for rendering
///
/// Edges are essential for expressing the relationships between domain concepts,
/// allowing visualizations to show how entities and other domain elements relate to
/// each other.
class Edge {
  /// The unique identifier for this edge.
  final String id;

  /// The display label for this edge.
  final String label;

  /// A more detailed description of this edge.
  final String description;

  /// The source node where this edge originates.
  final Node source;

  /// The target node where this edge terminates.
  final Node target;

  /// The type of this edge (e.g., association, composition).
  final EdgeType type;

  /// The direction of this edge (e.g., left-to-right, bidirectional).
  final EdgeDirection direction;

  /// The color used to render this edge.
  final Color color;

  /// The line width for rendering this edge.
  final double width;

  /// Whether this edge should be rendered with a dashed line.
  final bool isDashed;

  /// Additional properties for this edge.
  final Map<String, dynamic> properties;

  /// Optional reference to an EDNet Core domain relation.
  final Relation? relation;

  /// Creates a new edge.
  const Edge({
    required this.id,
    required this.label,
    this.description = '',
    required this.source,
    required this.target,
    required this.type,
    this.direction = EdgeDirection.leftToRight,
    required this.color,
    this.width = 1.0,
    this.isDashed = false,
    this.properties = const {},
    this.relation,
  });

  /// Creates an edge from a relation between entities in the domain model.
  ///
  /// This factory method automatically sets appropriate properties based on
  /// the relation's characteristics, making it easy to visualize domain relationships.
  factory Edge.fromRelation(
    Node sourceNode,
    Node targetNode,
    Relation relation,
  ) {
    // Determine edge type based on relation properties
    final edgeType = _determineEdgeType(relation);

    return Edge(
      id: '${sourceNode.id}_${relation.name}_${targetNode.id}',
      label: relation.name,
      source: sourceNode,
      target: targetNode,
      type: edgeType,
      color: _colorForEdgeType(edgeType),
      relation: relation,
      properties: {
        'relationName': relation.name,
        'sourceId': sourceNode.id,
        'targetId': targetNode.id,
      },
    );
  }

  /// Determines the edge type based on relation properties.
  static EdgeType _determineEdgeType(Relation relation) {
    // This is a simplified implementation
    // In a real implementation, you would analyze the relation's properties
    // to determine the most appropriate edge type
    return EdgeType.association;
  }

  /// Returns an appropriate color for the given edge type.
  static Color _colorForEdgeType(EdgeType type) {
    switch (type) {
      case EdgeType.association:
        return const Color(0xFF2196F3); // Blue
      case EdgeType.composition:
        return const Color(0xFFF44336); // Red
      case EdgeType.aggregation:
        return const Color(0xFF4CAF50); // Green
      case EdgeType.inheritance:
        return const Color(0xFF9C27B0); // Purple
      case EdgeType.implementation:
        return const Color(0xFF00BCD4); // Cyan
      case EdgeType.dependency:
        return const Color(0xFFFF9800); // Orange
      case EdgeType.causation:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Creates a copy of this edge with the specified properties replaced.
  Edge copyWith({
    String? id,
    String? label,
    String? description,
    Node? source,
    Node? target,
    EdgeType? type,
    EdgeDirection? direction,
    Color? color,
    double? width,
    bool? isDashed,
    Map<String, dynamic>? properties,
    Relation? relation,
  }) {
    return Edge(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      source: source ?? this.source,
      target: target ?? this.target,
      type: type ?? this.type,
      direction: direction ?? this.direction,
      color: color ?? this.color,
      width: width ?? this.width,
      isDashed: isDashed ?? this.isDashed,
      properties: properties ?? this.properties,
      relation: relation ?? this.relation,
    );
  }

  /// Converts this edge to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'sourceId': source.id,
      'targetId': target.id,
      'type': type.toString().split('.').last,
      'direction': direction.toString().split('.').last,
      'color': color.value,
      'width': width,
      'isDashed': isDashed,
      'properties': properties,
    };
  }

  /// Creates an edge from a JSON map.
  ///
  /// Note: This constructor requires a map of node IDs to Node objects,
  /// as the JSON only stores node IDs, not the full node objects.
  factory Edge.fromJson(Map<String, dynamic> json, Map<String, Node> nodeMap) {
    final sourceId = json['sourceId'] as String;
    final targetId = json['targetId'] as String;

    // Look up source and target nodes by ID
    final source = nodeMap[sourceId];
    final target = nodeMap[targetId];

    if (source == null || target == null) {
      throw ArgumentError('Source or target node not found');
    }

    return Edge(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String? ?? '',
      source: source,
      target: target,
      type: EdgeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => EdgeType.association,
      ),
      direction: EdgeDirection.values.firstWhere(
        (d) => d.toString().split('.').last == json['direction'],
        orElse: () => EdgeDirection.leftToRight,
      ),
      color: Color(json['color'] as int),
      width: (json['width'] as num).toDouble(),
      isDashed: json['isDashed'] as bool,
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Edge) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

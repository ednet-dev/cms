// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';




/// Type of node in the visual graph.
enum VisualNodeType {
  /// Entity node (represents a domain entity)
  entity,

  /// Attribute node (represents an entity attribute)
  attribute,

  /// Relation node (represents a relationship between entities)
  relation,

  /// Event node (represents a domain event)
  event,

  /// Command node (represents a command)
  command,

  /// Aggregate root node (represents an aggregate root)
  aggregateRoot,

  /// Policy node (represents a policy)
  policy,

  /// Other node (generic node type)
  other,
}

/// A node in a visual graph representing a domain model.
class VisualNode {
  /// The unique identifier for this node.
  final String id;

  /// The display label for this node.
  final String label;

  /// The type of this node.
  final VisualNodeType type;

  /// Additional data associated with this node.
  final Map<String, dynamic> data;

  /// Creates a new visual node.
  const VisualNode({
    required this.id,
    required this.label,
    this.type = VisualNodeType.other,
    this.data = const {},
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VisualNode) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// A node in a tree visualization of a domain model.
///
/// TreeNode extends the basic functionality of a node by adding:
/// - Position information for layout algorithms
/// - Size information for rendering
/// - Parent-child relationships for hierarchical layouts
/// - Visual style properties
///
/// This class is used by layout algorithms to position nodes in a
/// domain visualization.
class TreeNode {
  /// The unique identifier for this node.
  final String id;

  /// The display label for this node.
  final String label;

  /// The type of this node.
  final NodeType type;

  /// The current position of this node in the visualization.
  Offset position;

  /// The size of this node for rendering purposes.
  final Size size;

  /// The parent node of this node (if any).
  TreeNode? parent;

  /// The children of this node.
  final List<TreeNode> children;

  /// Additional data associated with this node.
  final Map<String, dynamic> data;

  /// The color used to render this node.
  final Color color;

  /// The border color for this node.
  final Color borderColor;

  /// The border width for this node.
  final double borderWidth;

  /// Creates a new tree node.
  TreeNode({
    required this.id,
    required this.label,
    required this.type,
    Offset? position,
    Size? size,
    this.parent,
    List<TreeNode>? children,
    this.data = const {},
    this.color = const Color(0xFF2196F3),
    this.borderColor = const Color(0xFF000000),
    this.borderWidth = 1.0,
  }) : position = position ?? Offset.zero,
       size = size ?? const Size(100, 60),
       children = children ?? [];

  /// Creates a tree node from a domain concept.
  factory TreeNode.fromConcept(Concept concept, {Offset? position}) {
    return TreeNode(
      id: concept.code,
      label: concept.name,
      type: concept.entry ? NodeType.AggregateRoot : NodeType.Entity,
      position: position,
      data: {
        'conceptId': concept.code,
        'description': concept.description,
        'isEntry': concept.entry,
      },
      color:
          concept.entry
              ? const Color(0xFFF44336) // Red for aggregate roots
              : const Color(0xFF2196F3), // Blue for regular entities
    );
  }

  /// Creates a tree node from an entity.
  factory TreeNode.fromEntity(Entity entity, {Offset? position}) {
    return TreeNode(
      id: entity.oid.toString(),
      label: entity.concept.name,
      type: entity.concept.entry ? NodeType.AggregateRoot : NodeType.Entity,
      position: position,
      data: {
        'entityId': entity.oid.toString(),
        'conceptCode': entity.concept.code,
      },
      color:
          entity.concept.entry
              ? const Color(0xFFF44336) // Red for aggregate roots
              : const Color(0xFF2196F3), // Blue for regular entities
    );
  }

  /// Adds a child node to this node.
  void addChild(TreeNode child) {
    children.add(child);
    child.parent = this;
  }

  /// Converts this node to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type.name,
      'position': {'x': position.dx, 'y': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'data': data,
      'color': color.value,
      'borderColor': borderColor.value,
      'borderWidth': borderWidth,
    };
  }
}

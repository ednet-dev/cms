// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';



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

/// A visual edge connecting nodes in a visualization.
///
/// This is a simplified edge representation designed to work with VisualNode
/// in the domain model graph. It provides essential properties for connecting
/// nodes in visualization while keeping the implementation lightweight.
class VisualEdge {
  /// The source node where this edge originates.
  final VisualNode source;

  /// The target node where this edge terminates.
  final VisualNode target;

  /// The display label for this edge.
  final String? label;

  /// Additional data associated with this edge.
  final Map<String, dynamic> data;

  /// Creates a new visual edge.
  const VisualEdge({
    required this.source,
    required this.target,
    this.label,
    this.data = const {},
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VisualEdge) return false;
    return source == other.source &&
        target == other.target &&
        label == other.label;
  }

  @override
  int get hashCode => Object.hash(source, target, label);
}

/// A specialized graph representation of a domain model.
///
/// This class creates a visual representation of a domain model
/// where:
/// - Nodes represent entities and their fields
/// - Edges represent relationships between entities and their fields
/// - The graph structure reflects the domain model's hierarchy
///
/// The graph is automatically built from the domain model's entities and their
/// relationships during construction.
class DomainModelGraph {
  /// Creates a new domain model graph.
  ///
  /// Parameters:
  /// - [domainModel]: The domain model to represent
  /// - [nodes]: Initial list of nodes in the graph
  /// - [edges]: Initial list of edges in the graph
  DomainModelGraph({
    required this.domainModel,
    List<VisualNode> nodes = const [],
    List<VisualEdge> edges = const [],
  }) : _nodes = List.from(nodes),
       _edges = List.from(edges) {
    build();
  }

  /// The domain model represented by this graph.
  final dynamic domainModel;

  /// The nodes in this graph.
  final List<VisualNode> _nodes;

  /// The edges in this graph.
  final List<VisualEdge> _edges;

  /// Get all nodes in the graph.
  List<VisualNode> get nodes => List.unmodifiable(_nodes);

  /// Get all edges in the graph.
  List<VisualEdge> get edges => List.unmodifiable(_edges);

  /// Adds a node to the graph.
  void addNode(VisualNode node) {
    if (!_nodes.contains(node)) {
      _nodes.add(node);
    }
  }

  /// Adds an edge to the graph.
  void addEdge(VisualNode source, VisualNode target, {String? label}) {
    final edge = VisualEdge(source: source, target: target, label: label);
    if (!_edges.contains(edge)) {
      _edges.add(edge);
    }
  }

  /// Builds the graph structure from the domain model.
  ///
  /// This method:
  /// 1. Adds nodes for each entity in the domain model
  /// 2. Adds nodes for each field of each entity
  /// 3. Creates edges connecting entities to their fields
  void build() {
    // Clear existing graph
    _nodes.clear();
    _edges.clear();

    // Handle different domain model types
    try {
      // Add domain model entities as nodes
      for (final entity in domainModel.entities) {
        final entityNode = VisualNode(
          id: entity.name,
          label: entity.name,
          type: VisualNodeType.entity,
        );
        addNode(entityNode);

        // Add entity fields as nodes
        for (final attribute in entity.attributes) {
          final attributeNode = VisualNode(
            id: '${entity.name}_${attribute.name}',
            label: attribute.name,
            type: VisualNodeType.attribute,
          );
          addNode(attributeNode);
          addEdge(entityNode, attributeNode, label: 'has');
        }
      }

      // Add edges for relationships between entities
      for (final entity in domainModel.entities) {
        final sourceNode = _findNodeById(entity.name);
        if (sourceNode == null) continue;

        for (final relation in entity.relations) {
          final targetEntity = domainModel.getEntity(
            relation.destinationEntityName,
          );
          if (targetEntity == null) continue;

          final targetNode = _findNodeById(targetEntity.name);
          if (targetNode == null) continue;

          addEdge(sourceNode, targetNode, label: relation.name);
        }
      }
    } catch (e) {
      // Handle errors or alternative domain model structures
      print('Error building domain model graph: $e');
    }
  }

  /// Finds a node by its ID.
  VisualNode? _findNodeById(String id) {
    for (final node in _nodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }
}

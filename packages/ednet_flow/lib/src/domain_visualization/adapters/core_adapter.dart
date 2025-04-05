// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';




/// Adapter for converting between ednet_core domain models and visualization components.
///
/// This adapter provides methods to convert ednet_core domain models to visualization
/// components that can be used in ednet_flow. It serves as a bridge between the
/// domain model layer and the visualization layer.
class CoreAdapter {
  /// Converts an ednet_core Domain to a list of VisualNodes and VisualEdges.
  ///
  /// This method transforms a Domain and its children (Models, Concepts, etc.)
  /// into VisualNodes and VisualEdges for visualization.
  static Map<String, dynamic> domainToVisualGraph(Domain domain) {
    final nodes = <VisualNode>[];
    final edges = <VisualEdge>[];

    // Create node for domain
    final domainNode = VisualNode(
      id: domain.code,
      label: domain.name,
      type: VisualNodeType.other,
      data: {'code': domain.code, 'type': 'domain'},
    );
    nodes.add(domainNode);

    // Create nodes for models and connect to domain
    for (final model in domain.models) {
      final modelNode = VisualNode(
        id: model.code,
        label: model.name,
        type: VisualNodeType.other,
        data: {'code': model.code, 'type': 'model'},
      );
      nodes.add(modelNode);
      edges.add(
        VisualEdge(source: domainNode, target: modelNode, label: 'contains'),
      );

      // Create nodes for concepts and connect to model
      for (final concept in model.concepts) {
        final conceptNode = VisualNode(
          id: concept.code,
          label: concept.name,
          type:
              concept.entry
                  ? VisualNodeType.aggregateRoot
                  : VisualNodeType.entity,
          data: {
            'code': concept.code,
            'type': 'concept',
            'isEntry': concept.entry,
          },
        );
        nodes.add(conceptNode);
        edges.add(
          VisualEdge(source: modelNode, target: conceptNode, label: 'contains'),
        );

        // Create nodes for attributes and connect to concept
        for (final attribute in concept.attributes) {
          final attributeNode = VisualNode(
            id: '${concept.code}_${attribute.code}',
            label: attribute.name,
            type: VisualNodeType.attribute,
            data: {
              'code': attribute.code,
              'type': 'attribute',
              'attributeType': attribute.type,
            },
          );
          nodes.add(attributeNode);
          edges.add(
            VisualEdge(
              source: conceptNode,
              target: attributeNode,
              label: 'has',
            ),
          );
        }
      }
    }

    return {'nodes': nodes, 'edges': edges};
  }

  /// Creates a DomainModelGraph from an ednet_core DomainModel.
  static DomainModelGraph createDomainModelGraph(DomainModel domainModel) {
    return DomainModelGraph(domainModel: domainModel);
  }

  /// Converts an ednet_core Entity to a VisualNode.
  static VisualNode entityToVisualNode(Entity entity) {
    bool isAggregateRoot = false;

    // Check if the entity is an AggregateRoot by examining its concept
    try {
      final concept = entity.concept;
      isAggregateRoot = concept.entry;
    } catch (e) {
      // If there's an error accessing the concept, assume it's not an aggregate root
    }

    return VisualNode(
      id: entity.oid.toString(),
      label: entity.toString(),
      type:
          isAggregateRoot
              ? VisualNodeType.aggregateRoot
              : VisualNodeType.entity,
      data: {'entityType': entity.runtimeType.toString()},
    );
  }
}

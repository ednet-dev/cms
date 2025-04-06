// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';



/// The main game controller for domain model visualization.
///
/// This class provides a game-based approach to domain model visualization,
/// enabling interactive, dynamic exploration of domain models.
class VisualizationGame {
  /// The domain model being visualized.
  final DomainModel domainModel;

  /// The entity components in this visualization.
  final List<EntityComponent> entities;

  /// The relation components in this visualization.
  final List<RelationComponent> relations;

  /// The current camera zoom level.
  double zoom;

  /// The current camera offset.
  final Point cameraOffset;

  /// Whether edit mode is enabled.
  bool editMode;

  /// Creates a new visualization game.
  VisualizationGame({
    required this.domainModel,
    List<EntityComponent>? entities,
    List<RelationComponent>? relations,
    this.zoom = 1.0,
    Point? cameraOffset,
    this.editMode = false,
  }) : entities = entities ?? [],
       relations = relations ?? [],
       cameraOffset = cameraOffset ?? const Point(0, 0);

  /// Creates a visualization game from a domain model.
  ///
  /// This factory method automatically generates entity and relation components
  /// from the provided domain model, creating a complete visualization.
  factory VisualizationGame.fromDomainModel(DomainModel domainModel) {
    final game = VisualizationGame(domainModel: domainModel);
    game._buildFromDomainModel();
    return game;
  }

  /// Builds visualization components from the domain model.
  ///
  /// This method:
  /// 1. Creates entity components for each entity in the domain model
  /// 2. Creates attribute components for each entity's attributes
  /// 3. Creates relation components for the relationships between entities
  void _buildFromDomainModel() {
    // Clear existing components
    entities.clear();
    relations.clear();

    // Map to store entities by name for relation creation
    final entityMap = <String, EntityComponent>{};

    // Create entity components
    int xPosition = 0;
    for (final entity in domainModel.entities) {
      // Determine if entity is an aggregate root (entry concept)
      final isAggregateRoot = entity.concept?.entry ?? false;

      // Create entity component
      final entityComponent = EntityComponent(
        id: entity.name,
        name: entity.name,
        description: entity.description ?? '',
        position: Point(xPosition * 150.0, 0),
        color: isAggregateRoot ? 0xFF8BC34A : 0xFF2196F3,
        isAggregateRoot: isAggregateRoot,
      );

      // Store in map for relation creation
      entityMap[entity.name] = entityComponent;

      // Add to entities list
      entities.add(entityComponent);

      // Increment x position for next entity
      xPosition++;
    }

    // Create relation components
    for (final entity in domainModel.entities) {
      final sourceComponent = entityMap[entity.name];
      if (sourceComponent == null) continue;

      for (final relation in entity.relations) {
        final targetComponent = entityMap[relation.destinationEntityName];
        if (targetComponent == null) continue;

        // Create relation component
        final relationComponent = RelationComponent(
          id: '${entity.name}_${relation.name}_${relation.destinationEntityName}',
          name: relation.name,
          sourceId: entity.name,
          targetId: relation.destinationEntityName,
          type: _determineRelationType(relation),
          color: 0xFF9E9E9E,
        );

        // Add to relations list
        relations.add(relationComponent);
      }
    }
  }

  /// Determines the appropriate relation type based on the EDNet relation.
  RelationType _determineRelationType(Relation relation) {
    // This is a simplified implementation; in a real implementation,
    // you would analyze the relation's properties to determine the type
    return RelationType.association;
  }

  /// Updates the game state.
  void update(double dt) {
    // This would be implemented in the platform-specific code
    // to handle updates, interactions, etc.
  }

  /// Converts the game state to a serializable map.
  Map<String, dynamic> toJson() {
    return {
      'zoom': zoom,
      'cameraOffset': cameraOffset.toJson(),
      'editMode': editMode,
      'entities': entities.map((e) => e.toJson()).toList(),
      'relations': relations.map((r) => r.toJson()).toList(),
    };
  }

  /// Creates a VisualizationGame from a serialized map.
  factory VisualizationGame.fromJson(
    DomainModel domainModel,
    Map<String, dynamic> json,
  ) {
    return VisualizationGame(
      domainModel: domainModel,
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
      cameraOffset:
          json['cameraOffset'] != null
              ? Point.fromJson(json['cameraOffset'] as Map<String, dynamic>)
              : const Point(0, 0),
      editMode: json['editMode'] as bool? ?? false,
      entities:
          (json['entities'] as List?)
              ?.map((e) => EntityComponent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      relations:
          (json['relations'] as List?)
              ?.map(
                (r) => RelationComponent.fromJson(r as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

/// A component that represents an entity in the domain model.
class EntityComponent {
  /// The unique identifier for this entity.
  final String id;

  /// The display name of this entity.
  final String name;

  /// The description of this entity.
  final String description;

  /// The position of this entity in the visualization.
  final Point position;

  /// The color of this entity.
  final int color;

  /// Whether this entity is an aggregate root.
  final bool isAggregateRoot;

  /// Creates a new entity component.
  EntityComponent({
    required this.id,
    required this.name,
    this.description = '',
    required this.position,
    required this.color,
    this.isAggregateRoot = false,
  });

  /// Creates an entity component from a serialized map.
  factory EntityComponent.fromJson(Map<String, dynamic> json) {
    return EntityComponent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      position: Point.fromJson(json['position'] as Map<String, dynamic>),
      color: json['color'] as int,
      isAggregateRoot: json['isAggregateRoot'] as bool? ?? false,
    );
  }

  /// Converts this entity to a serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'position': position.toJson(),
      'color': color,
      'isAggregateRoot': isAggregateRoot,
    };
  }
}

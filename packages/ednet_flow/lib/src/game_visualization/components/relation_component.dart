// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





class RelationComponent {
  /// The unique identifier for this relation.
  final String id;

  /// The name of this relation.
  final String name;

  /// A more detailed description of this relation.
  final String description;

  /// The ID of the source entity.
  final String sourceId;

  /// The ID of the target entity.
  final String targetId;

  /// The type of this relation.
  final RelationType type;

  /// The visual color of this relation.
  final int color;

  /// Whether this relation is bidirectional.
  final bool isBidirectional;

  /// Additional labels to display on this relation.
  final Map<String, String> labels;

  /// Visual waypoints for drawing the relation path.
  final List<Point> waypoints;

  /// Creates a new relation component.
  RelationComponent({
    required this.id,
    required this.name,
    this.description = '',
    required this.sourceId,
    required this.targetId,
    required this.type,
    required this.color,
    this.isBidirectional = false,
    this.labels = const {},
    this.waypoints = const [],
  });

  /// Converts this relation to a serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceId': sourceId,
      'targetId': targetId,
      'type': type.toString().split('.').last,
      'color': color,
      'isBidirectional': isBidirectional,
      'labels': labels,
      'waypoints': waypoints.map((wp) => wp.toJson()).toList(),
    };
  }

  /// Creates a relation component from a serialized map.
  factory RelationComponent.fromJson(Map<String, dynamic> json) {
    return RelationComponent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      type: _parseRelationType(json['type'] as String? ?? 'association'),
      color: json['color'] as int,
      isBidirectional: json['isBidirectional'] as bool? ?? false,
      labels:
          (json['labels'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          {},
      waypoints:
          (json['waypoints'] as List?)
              ?.map((wp) => Point.fromJson(wp as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts this relation component to an EDNet Core relation.
  Relation toDomainRelation() {
    // This is a simplified implementation
    return Relation(name: name, destinationEntityName: targetId);
  }

  /// Parses a relation type string to a RelationType enum.
  static RelationType _parseRelationType(String type) {
    switch (type.toLowerCase()) {
      case 'composition':
        return RelationType.composition;
      case 'aggregation':
        return RelationType.aggregation;
      case 'inheritance':
        return RelationType.inheritance;
      case 'implementation':
        return RelationType.implementation;
      case 'dependency':
        return RelationType.dependency;
      case 'association':
      default:
        return RelationType.association;
    }
  }
}

enum RelationType {
  /// Association relationship - entities are related but independent
  association,

  /// Composition relationship - child entity's lifecycle depends on parent
  composition,

  /// Aggregation relationship - child entity can exist independently
  aggregation,

  /// Inheritance relationship - child inherits from parent
  inheritance,

  /// Implementation relationship - child implements parent interface
  implementation,

  /// Dependency relationship - one entity depends on another
  dependency,
}

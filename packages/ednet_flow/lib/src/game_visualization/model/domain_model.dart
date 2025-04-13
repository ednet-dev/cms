// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





class DomainModel {
  /// The entities in this domain model.
  final List<Entity> entities;

  /// Creates a new domain model with the given [entities].
  DomainModel({List<Entity>? entities}) : entities = entities ?? [];

  /// Adds an entity to this domain model.
  void addEntity(Entity entity) {
    entities.add(entity);
  }

  /// Finds an entity by name.
  Entity? findEntity(String name) {
    return entities.firstWhere(
      (element) => element.name == name,
      orElse: () => throw Exception('Entity $name not found'),
    );
  }

  /// Converts this domain model to a serializable map.
  Map<String, dynamic> toJson() {
    return {'entities': entities.map((e) => e.toJson()).toList()};
  }

  /// Creates a domain model from a serialized map.
  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      entities:
          (json['entities'] as List)
              .map((e) => Entity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class Entity {
  /// The name of this entity.
  final String name;

  /// The description of this entity.
  final String? description;

  /// The concept related to this entity.
  final Concept? concept;

  /// The relations of this entity.
  final List<Relation> relations;

  /// Creates a new entity.
  Entity({
    required this.name,
    this.description,
    this.concept,
    List<Relation>? relations,
  }) : relations = relations ?? [];

  /// Adds a relation to this entity.
  void addRelation(Relation relation) {
    relations.add(relation);
  }

  /// Converts this entity to a serializable map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'concept': concept?.toJson(),
      'relations': relations.map((r) => r.toJson()).toList(),
    };
  }

  /// Creates an entity from a serialized map.
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['name'] as String,
      description: json['description'] as String?,
      concept:
          json['concept'] != null
              ? Concept.fromJson(json['concept'] as Map<String, dynamic>)
              : null,
      relations:
          (json['relations'] as List?)
              ?.map((r) => Relation.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Concept {
  /// Whether this concept is an entry point (aggregate root).
  final bool entry;

  /// Creates a new concept.
  Concept({this.entry = false});

  /// Converts this concept to a serializable map.
  Map<String, dynamic> toJson() {
    return {'entry': entry};
  }

  /// Creates a concept from a serialized map.
  factory Concept.fromJson(Map<String, dynamic> json) {
    return Concept(entry: json['entry'] as bool? ?? false);
  }
}

class Relation {
  /// The name of this relation.
  final String name;

  /// The name of the destination entity.
  final String destinationEntityName;

  /// Creates a new relation.
  Relation({required this.name, required this.destinationEntityName});

  /// Converts this relation to a serializable map.
  Map<String, dynamic> toJson() {
    return {'name': name, 'destinationEntityName': destinationEntityName};
  }

  /// Creates a relation from a serialized map.
  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      name: json['name'] as String,
      destinationEntityName: json['destinationEntityName'] as String,
    );
  }
}

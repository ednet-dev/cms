import 'package:equatable/equatable.dart';
import 'package:ednet_core/ednet_core.dart';

/// Base event for entity operations
abstract class EntityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to load entities for a concept
class LoadEntitiesEvent extends EntityEvent {
  /// The domain containing the entities
  final Domain domain;

  /// The model containing the entities
  final Model model;

  /// The concept to load entities for
  final Concept concept;

  /// Creates a load entities event
  LoadEntitiesEvent({
    required this.domain,
    required this.model,
    required this.concept,
  });

  @override
  List<Object?> get props => [domain, model, concept];
}

/// Event to select an entity
class SelectEntityEvent extends EntityEvent {
  /// The entity to select
  final Entity<dynamic> entity;

  /// Creates a select entity event
  SelectEntityEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}

/// Event to prepare for creating a new entity
class PrepareCreateEntityEvent extends EntityEvent {
  /// The concept to create an entity for
  final Concept concept;

  /// Creates a prepare create entity event
  PrepareCreateEntityEvent({required this.concept});

  @override
  List<Object?> get props => [concept];
}

/// Event to create a new entity
class CreateEntityEvent extends EntityEvent {
  /// The domain containing the entities
  final Domain domain;

  /// The model containing the entities
  final Model model;

  /// The concept to create an entity for
  final Concept concept;

  /// The attribute values for the new entity
  final Map<String, dynamic> attributeValues;

  /// Creates a create entity event
  CreateEntityEvent({
    required this.domain,
    required this.model,
    required this.concept,
    required this.attributeValues,
  });

  @override
  List<Object?> get props => [domain, model, concept, attributeValues];
}

/// Event to prepare for updating an entity
class PrepareUpdateEntityEvent extends EntityEvent {
  /// The entity to update
  final Entity<dynamic> entity;

  /// The concept of the entity
  final Concept concept;

  /// Creates a prepare update entity event
  PrepareUpdateEntityEvent({required this.entity, required this.concept});

  @override
  List<Object?> get props => [entity, concept];
}

/// Event to update an entity
class UpdateEntityEvent extends EntityEvent {
  /// The domain containing the entities
  final Domain domain;

  /// The model containing the entities
  final Model model;

  /// The concept of the entity
  final Concept concept;

  /// The OID of the entity to update
  final int oid;

  /// The new attribute values
  final Map<String, dynamic> attributeValues;

  /// Creates an update entity event
  UpdateEntityEvent({
    required this.domain,
    required this.model,
    required this.concept,
    required this.oid,
    required this.attributeValues,
  });

  @override
  List<Object?> get props => [domain, model, concept, oid, attributeValues];
}

/// Event to delete an entity
class DeleteEntityEvent extends EntityEvent {
  /// The domain containing the entities
  final Domain domain;

  /// The model containing the entities
  final Model model;

  /// The concept of the entity
  final Concept concept;

  /// The entity to delete
  final Entity<dynamic> entity;

  /// Creates a delete entity event
  DeleteEntityEvent({
    required this.domain,
    required this.model,
    required this.concept,
    required this.entity,
  });

  @override
  List<Object?> get props => [domain, model, concept, entity];
}

/// Event to set form field value
class SetFormFieldValueEvent extends EntityEvent {
  /// The field name
  final String field;

  /// The field value
  final dynamic value;

  /// Creates a set form field value event
  SetFormFieldValueEvent({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

/// Event to clear current selection
class ClearSelectionEvent extends EntityEvent {}

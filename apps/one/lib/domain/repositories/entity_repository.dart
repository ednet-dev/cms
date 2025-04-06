import 'package:ednet_core/ednet_core.dart';

/// Repository interface for performing CRUD operations on entities
abstract class EntityRepository {
  /// Get all entities for a specified concept
  Future<List<Entity<dynamic>>> getEntities(
    Domain domain,
    Model model,
    Concept concept,
  );

  /// Get a specific entity by OID
  Future<Entity<dynamic>?> getEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
  );

  /// Create a new entity with the provided attribute values
  Future<Entity<dynamic>> createEntity(
    Domain domain,
    Model model,
    Concept concept,
    Map<String, dynamic> attributeValues,
  );

  /// Update an entity with new attribute values
  Future<Entity<dynamic>> updateEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
    Map<String, dynamic> attributeValues,
  );

  /// Delete an entity
  Future<bool> deleteEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
  );
}

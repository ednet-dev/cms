import 'package:ednet_core/ednet_core.dart';

/// Repository interface for entity operations
abstract class EntityRepository<T extends Entity<dynamic>> {
  /// Find an entity by its ID
  Future<T?> findById(dynamic id);

  /// Find all entities
  Future<Iterable<T>> findAll();

  /// Save an entity
  Future<bool> save(T entity);

  /// Save multiple entities
  Future<bool> saveAll(Iterable<T> entities);

  /// Remove an entity
  Future<bool> remove(T entity);

  /// Remove an entity by its ID
  Future<bool> removeById(dynamic id);

  /// Remove all entities
  Future<bool> clear();
}

/// Repository interface with serialization capabilities
abstract class SerializableRepository<T extends Entity<dynamic>>
    extends EntityRepository<T> {
  /// Get the concept code for this repository
  String get conceptCode;

  /// Serialize an entity to a map
  Map<String, dynamic> serialize(T entity);

  /// Deserialize a map to an entity
  T deserialize(Map<String, dynamic> data);
}

/// Repository for domain models
abstract class DomainModelRepository {
  /// Save a domain model with the given ID
  Future<bool> saveDomainModel(dynamic domainModel, String domainModelId);

  /// Load a domain model with the given ID
  Future<dynamic> loadDomainModel(String domainModelId);

  /// Check if a domain model exists
  Future<bool> domainModelExists(String domainModelId);

  /// Clear a domain model
  Future<bool> clearDomainModel(String domainModelId);
}

import 'package:ednet_core/ednet_core.dart';

/// A generic repository for serializable domain models
abstract class SerializableRepository<T extends Entity<dynamic>> {
  /// The concept code this repository handles
  String get conceptCode;

  /// Saves a domain entity to persistent storage
  Future<bool> save(T entity);

  /// Saves multiple domain entities to persistent storage
  Future<bool> saveAll(Iterable<T> entities);

  /// Finds an entity by its ID
  Future<T?> findById(dynamic id);

  /// Gets all entities of this type
  Future<Iterable<T>> findAll();

  /// Removes an entity from storage
  Future<bool> remove(T entity);

  /// Removes an entity by ID from storage
  Future<bool> removeById(dynamic id);

  /// Clears all entities of this type
  Future<bool> clear();

  /// Serializes an entity to a Map
  Map<String, dynamic> serialize(T entity);

  /// Deserializes a Map to an entity
  T deserialize(Map<String, dynamic> data);
}

/// Repository for managing domain models with persistence
abstract class DomainModelRepository {
  /// Saves the entire domain model state
  Future<bool> saveDomainModel(dynamic domainModel, String domainModelId);

  /// Loads a domain model from persistence
  Future<dynamic> loadDomainModel(String domainModelId);

  /// Checks if a domain model exists in persistence
  Future<bool> domainModelExists(String domainModelId);

  /// Clears a domain model from persistence
  Future<bool> clearDomainModel(String domainModelId);
}

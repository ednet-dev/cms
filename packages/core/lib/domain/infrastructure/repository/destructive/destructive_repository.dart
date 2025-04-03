// part of repository;
//
// /// A repository implementation that supports destructive updates to entities.
// ///
// /// The [DestructiveRepository] class provides:
// /// - CRUD operations for domain entities
// /// - Query-based entity retrieval
// /// - Transaction support
// /// - Event sourcing capabilities
// ///
// /// This implementation:
// /// - Uses Isar for persistence
// /// - Supports aggregate roots
// /// - Maintains entity consistency
// /// - Handles concurrent access
// ///
// /// Example usage:
// /// ```dart
// /// final repository = DestructiveRepository(isar);
// ///
// /// // Save an aggregate root
// /// await repository.save(order);
// ///
// /// // Find by ID
// /// final order = await repository.findById('order-1');
// ///
// /// // Query with criteria
// /// final orders = await repository.findByCriteria(
// ///   Criteria<Order>(
// ///     filter: OrderStatusFilter(OrderStatus.pending),
// ///   ),
// /// );
// /// ```
// class DestructiveRepository implements Repository {
//   /// The Isar database instance for persistence.
//   final Isar _isar;
//
//   /// Creates a new destructive repository with the given [isar] database.
//   DestructiveRepository(this._isar);
//
//   /// Retrieves an entity by its ID.
//   ///
//   /// Parameters:
//   /// - [id]: The unique identifier of the entity
//   ///
//   /// Returns:
//   /// The entity if found, null otherwise
//   @override
//   Future<T> get<T extends Entity>(Id id) async {
//     return _isar.get<T>(id);
//   }
//
//   /// Finds entities matching the given criteria.
//   ///
//   /// Parameters:
//   /// - [criterion]: The criteria for filtering entities
//   ///
//   /// Returns:
//   /// List of matching entities
//   @override
//   Future<List<T>> query<T extends Entity>(Criterion criterion) async {
//     return _isar.query<T>(criterion).findAll();
//   }
//
//   /// Saves a single entity.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to save
//   @override
//   Future<void> put<T extends Entity>(T entity) async {
//     await _isar.put(entity);
//   }
//
//   /// Saves multiple entities in a single transaction.
//   ///
//   /// Parameters:
//   /// - [entities]: The entities to save
//   @override
//   Future<void> putAll<T extends Entity>(List<T> entities) async {
//     await _isar.putAll(entities);
//   }
//
//   /// Deletes a single entity.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to delete
//   @override
//   Future<void> delete<T extends Entity>(T entity) async {
//     await _isar.delete(entity);
//   }
//
//   /// Deletes multiple entities in a single transaction.
//   ///
//   /// Parameters:
//   /// - [entities]: The entities to delete
//   @override
//   Future<void> deleteAll<T extends Entity>(List<T> entities) async {
//     await _isar.deleteAll(entities);
//   }
//
//   /// Retrieves all aggregate roots.
//   ///
//   /// Returns:
//   /// List of all aggregate roots
//   @override
//   List<AggregateRoot> findAll() {
//     return _isar.getAll<AggregateRoot>();
//   }
//
//   /// Finds aggregate roots matching the given criteria.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria for filtering aggregate roots
//   ///
//   /// Returns:
//   /// List of matching aggregate roots
//   @override
//   List<AggregateRoot> findByCriteria(criteria) {
//     return _isar.query<AggregateRoot>(criteria).findAll();
//   }
//
//   /// Retrieves an aggregate root by its ID.
//   ///
//   /// Parameters:
//   /// - [id]: The unique identifier of the aggregate root
//   ///
//   /// Returns:
//   /// The aggregate root if found, null otherwise
//   @override
//   AggregateRoot findById(String id) {
//     return _isar.get<AggregateRoot>(id);
//   }
//
//   /// Saves an aggregate root.
//   ///
//   /// Parameters:
//   /// - [aggregateRoot]: The aggregate root to save
//   @override
//   void save(AggregateRoot aggregateRoot) {
//     _isar.put(aggregateRoot);
//   }
// }
// // // TODO Implement this library.

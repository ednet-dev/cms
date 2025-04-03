// part of repository;
//
// /// A repository implementation that supports event sourcing and non-destructive updates.
// ///
// /// The [NonDestructiveRepository] class provides:
// /// - Event-sourced entity persistence
// /// - Event replay and rehydration
// /// - Immutable history tracking
// /// - Optimistic concurrency control
// ///
// /// This implementation:
// /// - Uses Isar for event storage
// /// - Supports event sourcing patterns
// /// - Maintains entity history
// /// - Handles event replay
// ///
// /// Example usage:
// /// ```dart
// /// final repository = NonDestructiveRepository(isar);
// ///
// /// // Save an aggregate root (stores events)
// /// await repository.save(order);
// ///
// /// // Find by ID (replays events)
// /// final order = await repository.findById('order-1');
// ///
// /// // Query with criteria (replays events)
// /// final orders = await repository.findByCriteria(
// ///   Criteria<Order>(
// ///     filter: OrderStatusFilter(OrderStatus.pending),
// ///   ),
// /// );
// /// ```
// class NonDestructiveRepository extends CoreRepository {
//   /// The Isar database instance for event storage.
//   final Isar _isar;
//
//   /// Creates a new non-destructive repository with the given [isar] database.
//   NonDestructiveRepository(this._isar);
//
//   /// Retrieves an entity by its ID by replaying its event history.
//   ///
//   /// Parameters:
//   /// - [id]: The unique identifier of the entity
//   ///
//   /// Returns:
//   /// The rehydrated entity if found, null otherwise
//   @override
//   Future<T> get<T extends Entity>(Id id) async {
//     final snapshot = await _isar.snapshot(id);
//     return snapshot.rehydrate<T>();
//   }
//
//   /// Finds entities matching the given criteria by replaying their event histories.
//   ///
//   /// Parameters:
//   /// - [criterion]: The criteria for filtering entities
//   ///
//   /// Returns:
//   /// List of rehydrated matching entities
//   @override
//   Future<List<T>> query<T extends Entity>(Criterion criterion) async {
//     final snapshots = await _isar.snapshotAll(criterion);
//     return snapshots.map((snapshot) => snapshot.rehydrate<T>()).toList();
//   }
//
//   /// Saves a single entity by storing its events.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to save
//   @override
//   Future<void> put<T extends Entity>(T entity) async {
//     await _isar.applyEvents(entity.events);
//   }
//
//   /// Saves multiple entities in a single transaction by storing their events.
//   ///
//   /// Parameters:
//   /// - [entities]: The entities to save
//   @override
//   Future<void> putAll<T extends Entity>(List<T> entities) async {
//     final events = entities.expand((entity) => entity.events);
//     await _isar.applyEvents(events);
//   }
//
//   /// Deletes a single entity by storing its delete events.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to delete
//   @override
//   Future<void> delete<T extends Entity>(T entity) async {
//     await _isar.applyEvents(entity.deleteEvents);
//   }
//
//   /// Deletes multiple entities in a single transaction by storing their delete events.
//   ///
//   /// Parameters:
//   /// - [entities]: The entities to delete
//   @override
//   Future<void> deleteAll<T extends Entity>(List<T> entities) async {
//     final events = entities.expand((entity) => entity.deleteEvents);
//     await _isar.applyEvents(events);
//   }
//
//   /// Retrieves all aggregate roots by replaying their event histories.
//   ///
//   /// Returns:
//   /// List of all rehydrated aggregate roots
//   @override
//   List<AggregateRoot> findAll() {
//     final snapshots = _isar.getAllSnapshots<AggregateRoot>();
//     return snapshots.map((snapshot) => snapshot.rehydrate<AggregateRoot>()).toList();
//   }
//
//   /// Finds aggregate roots matching the given criteria by replaying their event histories.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria for filtering aggregate roots
//   ///
//   /// Returns:
//   /// List of rehydrated matching aggregate roots
//   @override
//   List<AggregateRoot> findByCriteria(criteria) {
//     final snapshots = _isar.querySnapshots<AggregateRoot>(criteria);
//     return snapshots.map((snapshot) => snapshot.rehydrate<AggregateRoot>()).toList();
//   }
//
//   /// Retrieves an aggregate root by its ID by replaying its event history.
//   ///
//   /// Parameters:
//   /// - [id]: The unique identifier of the aggregate root
//   ///
//   /// Returns:
//   /// The rehydrated aggregate root if found, null otherwise
//   @override
//   AggregateRoot findById(String id) {
//     final snapshot = _isar.getSnapshot<AggregateRoot>(id);
//     return snapshot?.rehydrate<AggregateRoot>();
//   }
//
//   /// Saves an aggregate root by storing its events.
//   ///
//   /// Parameters:
//   /// - [aggregateRoot]: The aggregate root to save
//   @override
//   void save(AggregateRoot aggregateRoot) {
//     _isar.applyEvents(aggregateRoot.events);
//   }
// }

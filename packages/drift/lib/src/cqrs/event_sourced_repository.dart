part of cqrs_drift;

/// Repository that supports event sourcing for aggregates.
///
/// This repository extends the standard [DriftQueryRepository] with
/// event sourcing capabilities:
/// - Stores aggregate changes as domain events
/// - Reconstructs aggregates from their event history
/// - Supports snapshots for performance optimization
///
/// Example usage:
/// ```dart
/// final repository = EventSourcedRepository<Order>(
///   db,
///   orderConcept,
///   eventStore
/// );
/// 
/// // Create and save an order
/// final order = Order(customerId: '12345')..addItem('product1', 2);
/// await repository.save(order);
/// 
/// // Load order from its event history
/// final loadedOrder = await repository.getById('order-1');
/// ```
class EventSourcedRepository<T extends AggregateRoot<T>> extends DriftQueryRepository<T> {
  /// The event store for persisting domain events
  final EventStore _eventStore;
  
  /// Factory function to create an empty aggregate
  final T Function() _createEmptyAggregate;
  
  /// Creates a new event-sourced repository.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [concept]: The concept for this repository
  /// - [eventStore]: The event store for persisting events
  /// - [createEmptyAggregate]: Factory function to create empty aggregates
  EventSourcedRepository(
    EDNetDriftDatabase db,
    Concept concept,
    this._eventStore,
    this._createEmptyAggregate,
  ) : super(db, concept);
  
  /// Saves an aggregate to the repository.
  ///
  /// This method:
  /// 1. Extracts uncommitted events from the aggregate
  /// 2. Persists them to the event store
  /// 3. Optionally saves a snapshot of the aggregate
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate to save
  ///
  /// Returns:
  /// A command result indicating success or failure
  @override
  Future<CommandResult> save(T aggregate) async {
    try {
      // Get all uncommitted events
      final uncommittedEvents = aggregate.getUncommittedEvents();
      
      if (uncommittedEvents.isEmpty) {
        // No changes to save
        return CommandResult.success();
      }
      
      // Save base entity to database
      await super.save(aggregate);
      
      // Store events in the event store
      await _eventStore.storeAll(uncommittedEvents);
      
      // Clear uncommitted events
      aggregate.clearUncommittedEvents();
      
      // Consider creating a snapshot if there are many events
      await _createSnapshotIfNeeded(aggregate);
      
      return CommandResult.success();
    } catch (e) {
      return CommandResult.failure('Failed to save aggregate: $e');
    }
  }
  
  /// Gets an aggregate by its ID.
  ///
  /// This method either:
  /// 1. Loads the latest snapshot and applies subsequent events, or
  /// 2. Reconstructs the aggregate from its complete event history
  ///
  /// Parameters:
  /// - [id]: The aggregate ID
  ///
  /// Returns:
  /// The reconstituted aggregate, or null if not found
  @override
  Future<T?> findById(dynamic id) async {
    final stringId = id.toString();
    
    // Try to load from snapshot first for performance
    final snapshot = await _loadFromSnapshot(stringId);
    if (snapshot != null) {
      // Load events that occurred after the snapshot
      final events = await _eventStore.getEventsForAggregate(
        _concept.code,
        stringId,
      );
      
      // Apply events that occurred after the snapshot
      final laterEvents = events.where((e) => 
        e.aggregateVersion > snapshot.version
      ).toList();
      
      snapshot.loadFromHistory(laterEvents);
      return snapshot;
    }
    
    // No snapshot, so reconstitute from complete event history
    final events = await _eventStore.getEventsForAggregate(
      _concept.code,
      stringId,
    );
    
    if (events.isEmpty) {
      // No events found, so the aggregate doesn't exist
      return await super.findById(id);
    }
    
    // Create a new aggregate and apply all events
    final aggregate = _createEmptyAggregate();
    aggregate.loadFromHistory(events);
    
    return aggregate;
  }
  
  /// Creates a snapshot of the aggregate if needed.
  ///
  /// This method is called after saving an aggregate. It creates
  /// a snapshot if the number of events since the last snapshot
  /// exceeds a threshold.
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate to snapshot
  ///
  /// Returns:
  /// Future that completes when the snapshot is created (if needed)
  Future<void> _createSnapshotIfNeeded(T aggregate) async {
    // Check if we need to create a snapshot
    // This could be based on:
    // - Number of events since last snapshot
    // - Time since last snapshot
    // - Other criteria
    
    // For now, keep a simple implementation that snapshots
    // every 20 events
    const snapshotFrequency = 20;
    
    if (aggregate.version % snapshotFrequency == 0) {
      await _createSnapshot(aggregate);
    }
  }
  
  /// Creates a snapshot of the aggregate.
  ///
  /// A snapshot is a serialized copy of the aggregate at a specific version,
  /// which allows faster reconstitution than replaying all events.
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate to snapshot
  ///
  /// Returns:
  /// Future that completes when the snapshot is created
  Future<void> _createSnapshot(T aggregate) async {
    try {
      // Save the current state as a snapshot
      await _db.customInsert(
        '''
        INSERT OR REPLACE INTO aggregate_snapshots (
          aggregate_type,
          aggregate_id,
          version,
          snapshot_data,
          created_at
        ) VALUES (?, ?, ?, ?, ?)
        ''',
        variables: [
          Variable(_concept.code),
          Variable(aggregate.aggregateId),
          Variable(aggregate.version),
          Variable(jsonEncode(aggregate.toJson())),
          Variable(DateTime.now().millisecondsSinceEpoch),
        ],
      );
    } catch (e) {
      // Log error but don't fail - snapshots are for optimization only
      print('Error creating snapshot: $e');
    }
  }
  
  /// Loads an aggregate from its latest snapshot.
  ///
  /// Parameters:
  /// - [aggregateId]: The ID of the aggregate
  ///
  /// Returns:
  /// The aggregate reconstructed from the snapshot, or null if no snapshot exists
  Future<T?> _loadFromSnapshot(String aggregateId) async {
    try {
      final result = await _db.customSelect(
        '''
        SELECT * FROM aggregate_snapshots
        WHERE aggregate_type = ? AND aggregate_id = ?
        ORDER BY version DESC
        LIMIT 1
        ''',
        variables: [
          Variable(_concept.code),
          Variable(aggregateId),
        ],
      ).getSingleOrNull();
      
      if (result == null) {
        return null;
      }
      
      // Deserialize the snapshot data
      final snapshotData = jsonDecode(result.read<String>('snapshot_data'));
      
      // Create a new aggregate and restore from snapshot
      final aggregate = _createEmptyAggregate();
      _restoreFromSnapshot(aggregate, snapshotData);
      
      return aggregate;
    } catch (e) {
      // Log error but don't fail - we can fall back to event sourcing
      print('Error loading snapshot: $e');
      return null;
    }
  }
  
  /// Restores an aggregate from snapshot data.
  ///
  /// This method must be implemented by subclasses to handle
  /// concept-specific deserialization.
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate to restore
  /// - [snapshotData]: The serialized snapshot data
  void _restoreFromSnapshot(T aggregate, Map<String, dynamic> snapshotData) {
    // This is a basic implementation that works with simple aggregates
    // For complex aggregates, this should be overridden
    
    // Set the ID
    if (snapshotData.containsKey('id')) {
      aggregate.id = snapshotData['id'];
    }
    
    // Set the version
    if (snapshotData.containsKey('version')) {
      aggregate.version = snapshotData['version'];
    }
    
    // Set other attributes
    snapshotData.forEach((key, value) {
      if (!['id', 'version'].contains(key)) {
        aggregate.setAttribute(key, value);
      }
    });
  }
}

/// Factory for creating event-sourced repositories.
///
/// This factory simplifies the creation of event-sourced repositories
/// by handling the common setup and configuration details.
class EventSourcedRepositoryFactory {
  /// The Drift database
  final EDNetDriftDatabase _db;
  
  /// The domain model
  final Domain _domain;
  
  /// The event store
  final EventStore _eventStore;
  
  /// Creates a new event-sourced repository factory.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [domain]: The domain model
  /// - [eventStore]: The event store
  EventSourcedRepositoryFactory(this._db, this._domain, this._eventStore);
  
  /// Creates an event-sourced repository for a specific aggregate type.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept
  /// - [createEmptyAggregate]: Factory function for creating empty aggregates
  ///
  /// Type parameters:
  /// - [T]: The aggregate type
  ///
  /// Returns:
  /// An event-sourced repository for the specified aggregate type
  EventSourcedRepository<T> createRepository<T extends AggregateRoot<T>>(
    String conceptCode,
    T Function() createEmptyAggregate
  ) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    
    return EventSourcedRepository<T>(
      _db,
      concept,
      _eventStore,
      createEmptyAggregate,
    );
  }
  
  /// Ensures that the necessary database tables exist for event sourcing.
  ///
  /// Returns:
  /// Future that completes when the tables are ready
  Future<void> ensureEventSourcingTables() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS domain_events (
        event_id TEXT PRIMARY KEY,
        event_type TEXT NOT NULL,
        aggregate_type TEXT NOT NULL,
        aggregate_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        payload TEXT NOT NULL,
        sequence_number INTEGER NOT NULL,
        
        -- Indices for efficient querying
        INDEX idx_events_aggregate (aggregate_type, aggregate_id, sequence_number),
        INDEX idx_events_type (event_type, timestamp)
      )
    ''');
    
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS aggregate_snapshots (
        aggregate_type TEXT NOT NULL,
        aggregate_id TEXT NOT NULL,
        version INTEGER NOT NULL,
        snapshot_data TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        
        -- Primary key
        PRIMARY KEY (aggregate_type, aggregate_id, version),
        
        -- Index for latest version
        INDEX idx_snapshots_latest (aggregate_type, aggregate_id, version DESC)
      )
    ''');
  }
} 
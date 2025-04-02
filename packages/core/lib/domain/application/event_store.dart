part of ednet_core;

/// Event Store for persisting and publishing domain events.
///
/// The EventStore acts as a central repository for domain events, providing:
/// - Persistent storage of all domain events
/// - Event publishing to event handlers and subscribers
/// - Event replay capabilities for aggregate reconstitution
/// - Temporal querying of domain history
///
/// This is a key component of event sourcing architecture that maintains
/// the complete history of domain changes.
///
/// Example usage:
/// ```dart
/// final eventStore = EventStore(database, eventPublisher);
/// await eventStore.store(orderCreatedEvent);
/// final events = await eventStore.getEventsForAggregate('Order', '12345');
/// ```
class EventStore {
  /// The database for persistent storage
  final EDNetDriftDatabase _db;
  
  /// The event publisher for distributing events
  final EventPublisher _publisher;
  
  /// Creates a new EventStore with the specified database and publisher.
  ///
  /// Parameters:
  /// - [db]: Database for event persistence
  /// - [publisher]: Publisher for event distribution
  EventStore(this._db, this._publisher);
  
  /// Stores and publishes a domain event.
  ///
  /// This method:
  /// 1. Persists the event to the database
  /// 2. Publishes the event to all subscribers
  ///
  /// The operation is wrapped in a transaction to ensure consistency.
  ///
  /// Parameters:
  /// - [event]: The domain event to store
  ///
  /// Returns:
  /// Future that completes when the event is stored and published
  Future<void> store(IDomainEvent event) async {
    await _db.transaction(() async {
      await _storeEvent(event);
      await _publisher.publish(event);
    });
  }
  
  /// Stores multiple domain events in a single transaction.
  ///
  /// This method:
  /// 1. Persists all events to the database in a single transaction
  /// 2. Publishes all events to subscribers
  ///
  /// Parameters:
  /// - [events]: List of domain events to store
  ///
  /// Returns:
  /// Future that completes when all events are stored and published
  Future<void> storeAll(List<IDomainEvent> events) async {
    if (events.isEmpty) return;
    
    await _db.transaction(() async {
      for (final event in events) {
        await _storeEvent(event);
      }
      
      for (final event in events) {
        await _publisher.publish(event);
      }
    });
  }
  
  /// Retrieves events for a specific aggregate instance.
  ///
  /// This method returns all events for the specified aggregate instance
  /// in chronological order, allowing for aggregate reconstitution.
  ///
  /// Parameters:
  /// - [aggregateType]: The type of aggregate (e.g., 'Order')
  /// - [aggregateId]: The ID of the aggregate instance
  ///
  /// Returns:
  /// List of domain events for the aggregate in chronological order
  Future<List<IDomainEvent>> getEventsForAggregate(
    String aggregateType, 
    String aggregateId
  ) async {
    final rows = await _db.customSelect(
      '''
      SELECT * FROM domain_events 
      WHERE aggregate_type = ? AND aggregate_id = ?
      ORDER BY sequence_number ASC
      ''',
      variables: [
        Variable(aggregateType),
        Variable(aggregateId),
      ],
    ).get();
    
    return rows.map(_rowToEvent).toList();
  }
  
  /// Retrieves events of a specific type.
  ///
  /// This method returns events of the specified type in chronological order,
  /// useful for event handlers that process specific event types.
  ///
  /// Parameters:
  /// - [eventType]: The type of event to retrieve
  /// - [since]: Optional timestamp to retrieve events after a specific time
  ///
  /// Returns:
  /// List of domain events of the specified type
  Future<List<IDomainEvent>> getEventsByType(
    String eventType, {
    DateTime? since,
  }) async {
    String query = '''
      SELECT * FROM domain_events 
      WHERE event_type = ?
    ''';
    
    final variables = [Variable(eventType)];
    
    if (since != null) {
      query += ' AND timestamp >= ?';
      variables.add(Variable(since.millisecondsSinceEpoch));
    }
    
    query += ' ORDER BY timestamp ASC';
    
    final rows = await _db.customSelect(
      query,
      variables: variables,
    ).get();
    
    return rows.map(_rowToEvent).toList();
  }
  
  /// Private method to store an event in the database.
  ///
  /// Parameters:
  /// - [event]: The domain event to store
  ///
  /// Returns:
  /// Future that completes when the event is stored
  Future<void> _storeEvent(IDomainEvent event) async {
    await _db.customInsert(
      '''
      INSERT INTO domain_events (
        event_id, 
        event_type, 
        aggregate_type, 
        aggregate_id, 
        timestamp, 
        payload,
        sequence_number
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable(event.id),
        Variable(event.name),
        Variable(event.aggregateType),
        Variable(event.aggregateId),
        Variable(event.timestamp.millisecondsSinceEpoch),
        Variable(jsonEncode(event.toJson())),
        Variable(_getNextSequenceNumber(event.aggregateType, event.aggregateId)),
      ],
    );
  }
  
  /// Gets the next sequence number for an aggregate instance.
  ///
  /// This ensures events are ordered correctly for each aggregate.
  ///
  /// Parameters:
  /// - [aggregateType]: The type of aggregate
  /// - [aggregateId]: The ID of the aggregate instance
  ///
  /// Returns:
  /// The next sequence number for the aggregate
  Future<int> _getNextSequenceNumber(String aggregateType, String aggregateId) async {
    final result = await _db.customSelect(
      '''
      SELECT MAX(sequence_number) as max_seq 
      FROM domain_events 
      WHERE aggregate_type = ? AND aggregate_id = ?
      ''',
      variables: [
        Variable(aggregateType),
        Variable(aggregateId),
      ],
    ).getSingleOrNull();
    
    if (result == null || result.read<int?>('max_seq') == null) {
      return 1;
    }
    
    return result.read<int>('max_seq') + 1;
  }
  
  /// Converts a database row to a domain event.
  ///
  /// This uses a registry of event types to create the appropriate event instance.
  ///
  /// Parameters:
  /// - [row]: The database row
  ///
  /// Returns:
  /// The reconstituted domain event
  IDomainEvent _rowToEvent(QueryRow row) {
    final eventType = row.read<String>('event_type');
    final payload = jsonDecode(row.read<String>('payload'));
    
    // Use the event registry to create the appropriate event type
    return EventTypeRegistry.createEvent(eventType, payload);
  }
} 
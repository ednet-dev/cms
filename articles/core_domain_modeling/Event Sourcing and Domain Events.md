# Event Sourcing and Domain Events

Traditional domain models focus on the current state of entities. Event Sourcing offers a different paradigm: instead of storing the current state, it captures all changes to an application state as a sequence of events. EDNet Core provides built-in support for this powerful pattern, enabling you to build more robust, auditable, and flexible domain models.

## Understanding Domain Events

Domain events represent significant occurrences within your domain model. Unlike commands (which represent intentions to change state), events represent facts that have already happened:

```dart
// A command (intention)
CreateOrderCommand(customerId, items)

// An event (fact)
OrderCreatedEvent(orderId, customerId, items, timestamp)
```

In EDNet Core, domain events are represented by the `Event` class:

```dart
class Event {
  final String name;
  final String description;
  final List<String> handlers;
  final Entity entity;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  Event(
    this.name, 
    this.description, 
    this.handlers, 
    this.entity, 
    this.data
  ) : timestamp = DateTime.now();
  
  // Implementation details...
}
```

Events capture:
- **What happened** (name and description)
- **Who should react** (handlers)
- **Which entity changed** (entity)
- **Relevant data** (data payload)
- **When it happened** (timestamp)

## The Event Sourcing Pattern

Event Sourcing is a pattern where:
1. All changes to domain objects are captured as a sequence of events
2. These events are stored in the order they were applied
3. The current state can be recreated by replaying the events

This approach brings several powerful benefits:
- **Complete audit trail** of all changes
- **Temporal queries** to see the state at any point in time
- **Event replay** for debugging, testing, or recovery
- **Separation of concerns** between state changes and state queries

## Implementing Event Sourcing with EDNet Core

EDNet Core's `AggregateRoot` class provides built-in support for event sourcing:

```dart
abstract class AggregateRoot<T extends Entity<T>> extends Entity<T> {
  final List<dynamic> _pendingEvents = [];
  int _version = 0;
  
  List<dynamic> get pendingEvents => List.unmodifiable(_pendingEvents);
  
  void markEventsAsProcessed() {
    _pendingEvents.clear();
  }
  
  dynamic recordEvent(
    String name,
    String description,
    List<String> handlers, {
    Map<String, dynamic> data = const {},
  }) {
    final event = Event(name, description, handlers, this, data);
    _pendingEvents.add(event);
    applyEvent(event);
    return event;
  }
  
  void rehydrateFromEventHistory(List<dynamic> eventHistory) {
    for (var event in eventHistory) {
      applyEvent(event);
      _version++;
    }
  }
  
  void applyEvent(dynamic event) {
    // Implement in concrete classes to update state based on events
  }
}
```

This structure provides the foundation for event sourcing:
- `recordEvent()` creates and stores events
- `applyEvent()` updates the entity state based on events
- `rehydrateFromEventHistory()` rebuilds state from an event stream
- `pendingEvents` provides access to events that need processing

## Recording Domain Events

In your domain model, you record events to capture significant state changes:

```dart
class Order extends AggregateRoot<Order> {
  late String status;
  late DateTime orderDate;
  late String customerId;
  List<OrderLine> lines = [];
  
  void place() {
    // Record the event
    recordEvent(
      'OrderPlaced',
      'Order was placed by customer',
      ['OrderFulfillmentHandler', 'NotificationHandler'],
      data: {
        'customerId': customerId,
        'orderTotal': calculateTotal(),
        'lineCount': lines.length
      }
    );
    
    // The state change happens in applyEvent()
  }
  
  void ship(String trackingNumber) {
    recordEvent(
      'OrderShipped',
      'Order was shipped to customer',
      ['NotificationHandler'],
      data: {
        'trackingNumber': trackingNumber,
        'shippedDate': DateTime.now().toIso8601String()
      }
    );
  }
  
  @override
  void applyEvent(dynamic event) {
    if (event.name == 'OrderPlaced') {
      status = 'Placed';
      orderDate = event.timestamp;
    } else if (event.name == 'OrderShipped') {
      status = 'Shipped';
      // Update other state as needed
    }
  }
}
```

This pattern ensures that:
1. All state changes are explicitly documented as events
2. The events contain all necessary data to understand the change
3. State is only modified through event application

## Storing and Retrieving Events

To fully implement event sourcing, you need to store and retrieve events:

```dart
class EventStore {
  final Database _db;
  
  EventStore(this._db);
  
  Future<void> saveEvents(String aggregateId, List<Event> events, int expectedVersion) async {
    // Start a transaction
    await _db.startTransaction();
    
    try {
      // Check for concurrency conflicts
      final currentVersion = await _db.getVersion(aggregateId);
      if (currentVersion != expectedVersion) {
        throw ConcurrencyException(
          'Expected version $expectedVersion but found $currentVersion'
        );
      }
      
      // Save each event
      for (var event in events) {
        await _db.saveEvent(
          aggregateId,
          event.name,
          event.description,
          jsonEncode(event.data),
          event.timestamp,
          expectedVersion + 1
        );
        expectedVersion++;
      }
      
      // Update aggregate version
      await _db.updateVersion(aggregateId, expectedVersion);
      
      // Commit transaction
      await _db.commitTransaction();
    } catch (e) {
      // Rollback on error
      await _db.rollbackTransaction();
      rethrow;
    }
  }
  
  Future<List<Event>> getEvents(String aggregateId) async {
    final eventRows = await _db.getEvents(aggregateId);
    return eventRows.map((row) => Event(
      row.name,
      row.description,
      row.handlers?.split(',') ?? [],
      null, // Entity reference needs to be set by the caller
      jsonDecode(row.data)
    )).toList();
  }
}
```

## Event Sourced Repositories

Repositories in an event-sourced system work differently, focusing on event streams rather than direct entity state:

```dart
class OrderRepository {
  final EventStore _eventStore;
  
  OrderRepository(this._eventStore);
  
  Future<Order> getById(String orderId) async {
    // Retrieve the event stream
    final events = await _eventStore.getEvents(orderId);
    
    // Create a new aggregate instance
    var order = Order();
    order.oid = Oid.fromString(orderId);
    
    // Replay events to build current state
    order.rehydrateFromEventHistory(events);
    
    return order;
  }
  
  Future<void> save(Order order) async {
    // Save only the new (pending) events
    if (order.pendingEvents.isNotEmpty) {
      await _eventStore.saveEvents(
        order.oid.toString(),
        order.pendingEvents.toList(),
        order.version
      );
      
      // Mark events as processed
      order.markEventsAsProcessed();
    }
  }
}
```

## Event Handlers and Reactions

Domain events often trigger reactions in other parts of the system. EDNet Core provides an event handling mechanism:

```dart
class OrderPlacedHandler implements EventHandler {
  final NotificationService _notificationService;
  final InventoryService _inventoryService;
  
  OrderPlacedHandler(this._notificationService, this._inventoryService);
  
  @override
  String get eventName => 'OrderPlaced';
  
  @override
  Future<void> handle(Event event) async {
    final order = event.entity as Order;
    
    // Send confirmation notification
    await _notificationService.sendOrderConfirmation(
      order.customerId,
      order.oid.toString(),
      event.data['orderTotal']
    );
    
    // Reserve inventory
    for (var line in order.lines) {
      await _inventoryService.reserveInventory(
        line.productId,
        line.quantity
      );
    }
  }
}
```

## Event Versioning and Evolution

As your domain model evolves, your events will need to evolve too. EDNet Core supports several strategies for event versioning:

### 1. Event Upcasting

Transform old event formats into new ones during event loading:

```dart
class EventUpcastService {
  Event upcast(Event event) {
    // Handle v1 to v2 conversions
    if (event.name == 'OrderPlaced' && !event.data.containsKey('paymentMethod')) {
      // Add missing fields with default values
      final updatedData = Map<String, dynamic>.from(event.data);
      updatedData['paymentMethod'] = 'Unknown';
      
      return Event(
        event.name,
        event.description,
        event.handlers,
        event.entity,
        updatedData
      );
    }
    
    return event;
  }
}
```

### 2. Event Versioning

Include explicit version information in event names:

```dart
// Version 1
recordEvent(
  'OrderPlaced_v1',
  'Order was placed by customer',
  ['OrderHandler_v1'],
  data: { /* v1 data */ }
);

// Version 2
recordEvent(
  'OrderPlaced_v2',
  'Order was placed by customer',
  ['OrderHandler_v2'],
  data: { /* v2 data with additional fields */ }
);

@override
void applyEvent(dynamic event) {
  if (event.name == 'OrderPlaced_v1') {
    // Handle v1 format
  } else if (event.name == 'OrderPlaced_v2') {
    // Handle v2 format
  }
}
```

## Snapshotting for Performance

For aggregates with many events, replaying the entire event stream can become inefficient. Snapshotting periodically captures the current state:

```dart
class SnapshotStore {
  final Database _db;
  
  SnapshotStore(this._db);
  
  Future<void> saveSnapshot(AggregateRoot aggregate) async {
    await _db.saveSnapshot(
      aggregate.oid.toString(),
      aggregate.version,
      jsonEncode(aggregate.toJsonMap()),
      DateTime.now()
    );
  }
  
  Future<Snapshot?> getLatestSnapshot(String aggregateId) async {
    final row = await _db.getLatestSnapshot(aggregateId);
    if (row == null) return null;
    
    return Snapshot(
      row.version,
      jsonDecode(row.state),
      row.timestamp
    );
  }
}

class EventSourcedRepository<T extends AggregateRoot<T>> {
  final EventStore _eventStore;
  final SnapshotStore _snapshotStore;
  final T Function() _factory;
  
  EventSourcedRepository(this._eventStore, this._snapshotStore, this._factory);
  
  Future<T> getById(String id) async {
    // Try to get a snapshot first
    final snapshot = await _snapshotStore.getLatestSnapshot(id);
    
    // Create the aggregate
    T aggregate = _factory();
    aggregate.oid = Oid.fromString(id);
    
    int fromVersion = 0;
    
    // Apply snapshot if available
    if (snapshot != null) {
      aggregate.fromJsonMap(snapshot.state);
      fromVersion = snapshot.version;
    }
    
    // Get events after the snapshot version
    final events = await _eventStore.getEventsAfterVersion(id, fromVersion);
    
    // Apply remaining events
    aggregate.rehydrateFromEventHistory(events);
    
    return aggregate;
  }
  
  Future<void> save(T aggregate) async {
    // Save events
    await _eventStore.saveEvents(
      aggregate.oid.toString(),
      aggregate.pendingEvents.toList(),
      aggregate.version
    );
    
    // Create snapshot if needed (e.g., every 100 events)
    if (aggregate.version % 100 == 0) {
      await _snapshotStore.saveSnapshot(aggregate);
    }
    
    // Mark events as processed
    aggregate.markEventsAsProcessed();
  }
}
```

## Projections: Building Read Models

Event sourcing naturally separates write models (aggregates) from read models (projections). EDNet Core supports building projections from event streams:

```dart
class OrderSummaryProjection {
  final Database _db;
  
  OrderSummaryProjection(this._db);
  
  Future<void> handle(Event event) async {
    if (event.name == 'OrderPlaced') {
      // Create new summary
      await _db.insertOrderSummary(
        event.entity.oid.toString(),
        event.data['customerId'],
        'Placed',
        event.data['orderTotal'],
        event.timestamp
      );
    } else if (event.name == 'OrderShipped') {
      // Update existing summary
      await _db.updateOrderSummary(
        event.entity.oid.toString(),
        'Shipped',
        event.data['trackingNumber']
      );
    } else if (event.name == 'OrderCancelled') {
      // Update status
      await _db.updateOrderSummary(
        event.entity.oid.toString(),
        'Cancelled',
        null
      );
    }
  }
}
```

Projections enable efficient querying while maintaining the full event history for the write model.

## Practical Example: Customer Account Management

Let's see a complete example of event sourcing for customer account management:

```dart
// The aggregate root
class CustomerAccount extends AggregateRoot<CustomerAccount> {
  String? name;
  String? email;
  double balance = 0.0;
  List<TransactionRecord> transactions = [];
  bool isLocked = false;
  
  // Command methods - these record events
  void create(String name, String email) {
    recordEvent(
      'AccountCreated',
      'Customer account was created',
      ['NotificationHandler', 'AuditHandler'],
      data: {'name': name, 'email': email}
    );
  }
  
  void deposit(double amount) {
    if (isLocked) {
      throw DomainException('Cannot deposit to locked account');
    }
    
    recordEvent(
      'FundsDeposited',
      'Funds were deposited to the account',
      ['TransactionHandler'],
      data: {'amount': amount}
    );
  }
  
  void withdraw(double amount) {
    if (isLocked) {
      throw DomainException('Cannot withdraw from locked account');
    }
    
    if (balance < amount) {
      throw DomainException('Insufficient funds');
    }
    
    recordEvent(
      'FundsWithdrawn',
      'Funds were withdrawn from the account',
      ['TransactionHandler'],
      data: {'amount': amount}
    );
  }
  
  void lock(String reason) {
    if (isLocked) return;
    
    recordEvent(
      'AccountLocked',
      'Account was locked',
      ['SecurityHandler', 'NotificationHandler'],
      data: {'reason': reason}
    );
  }
  
  void unlock() {
    if (!isLocked) return;
    
    recordEvent(
      'AccountUnlocked',
      'Account was unlocked',
      ['SecurityHandler', 'NotificationHandler'],
      data: {}
    );
  }
  
  // Apply events to update state
  @override
  void applyEvent(dynamic event) {
    if (event.name == 'AccountCreated') {
      name = event.data['name'];
      email = event.data['email'];
      balance = 0.0;
      isLocked = false;
    } else if (event.name == 'FundsDeposited') {
      double amount = event.data['amount'];
      balance += amount;
      transactions.add(TransactionRecord(
        'Deposit',
        amount,
        event.timestamp,
        balance
      ));
    } else if (event.name == 'FundsWithdrawn') {
      double amount = event.data['amount'];
      balance -= amount;
      transactions.add(TransactionRecord(
        'Withdrawal',
        -amount,
        event.timestamp,
        balance
      ));
    } else if (event.name == 'AccountLocked') {
      isLocked = true;
    } else if (event.name == 'AccountUnlocked') {
      isLocked = false;
    }
  }
}

// Transaction record value object
class TransactionRecord {
  final String type;
  final double amount;
  final DateTime timestamp;
  final double resultingBalance;
  
  TransactionRecord(
    this.type, 
    this.amount, 
    this.timestamp, 
    this.resultingBalance
  );
}

// Using the event-sourced aggregate
Future<void> processDeposit(String accountId, double amount) async {
  final repository = CustomerAccountRepository(eventStore, snapshotStore);
  
  // Load account from event history
  var account = await repository.getById(accountId);
  
  // Execute command
  account.deposit(amount);
  
  // Save new events
  await repository.save(account);
}
```

## When to Use Event Sourcing

Event sourcing is particularly valuable when:

1. **Audit requirements are strict**: You need to track every change
2. **Business processes are temporal**: Time and sequence matter
3. **Debugging complex issues**: You need to understand how state evolved
4. **Domain experts think in terms of events**: Events match the ubiquitous language
5. **State reconstruction is valuable**: You need to rebuild state or projections

However, it also brings challenges:
- Learning curve for developers
- Eventually consistent read models
- Schema evolution complexity
- Potential performance implications

## Best Practices for Event Sourcing in EDNet Core

1. **Keep events focused**: Each event should represent a single logical change
2. **Include all necessary data**: Events should be self-contained
3. **Make events immutable**: Never alter stored events
4. **Design for versioning**: Plan for event schema evolution
5. **Separate command and query responsibilities**: Use projections for queries
6. **Snapshot where appropriate**: Balance performance and completeness
7. **Think in event streams**: Model your domain around event flows, not just state

## Conclusion

Event Sourcing provides a powerful approach to domain modeling, capturing the complete history of changes rather than just the current state. EDNet Core's built-in support for event recording, application, and rehydration makes it easy to implement this pattern in your domain models.

By focusing on domain events as the primary record of truth, you gain auditability, temporal queries, and the ability to rebuild state. This approach aligns well with complex domains where understanding the journey is as important as the destination.

In the next article, we'll explore the Command-Event-Policy cycle, showing how commands, events, and policies work together to create reactive, autonomous domain models.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 
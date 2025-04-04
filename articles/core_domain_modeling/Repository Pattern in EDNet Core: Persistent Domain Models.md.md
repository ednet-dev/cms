# Repository Pattern in EDNet Core: Persistent Domain Models

## Introduction

The Repository pattern is a crucial component in Domain-Driven Design that mediates between the domain and data mapping layers. In EDNet Core, repositories provide a collection-like interface for accessing and managing domain objects, abstracting away the complexities of data persistence and retrieval. This article explores how EDNet Core implements the Repository pattern to create a clean separation between your domain model and persistence mechanisms.

## The Repository Pattern in DDD

Before diving into EDNet's implementation, let's review the key aspects of the Repository pattern:

- **Domain-focused interface**: Repositories present a collection-like interface that domain experts can understand
- **Persistence abstraction**: They hide the details of data storage and retrieval
- **Object lifecycle management**: Repositories handle object creation, tracking, and disposal
- **Query capabilities**: They provide methods to find and filter domain objects
- **Transaction support**: Repositories work within transaction boundaries

EDNet Core's repository implementation adheres to these principles while adding powerful capabilities specific to its domain modeling approach.

## Core Repository Implementation

EDNet Core provides a base `Repository<T>` class that serves as the foundation for all domain repositories:

```dart
class Repository<T extends Entity<T>> {
  final DomainSession _session;
  final String _conceptCode;
  
  Repository(this._session, this._conceptCode);
  
  // Object lifecycle methods
  T create() {
    return _session.domain.models
        .getModelEntries(_conceptCode)
        .newEntity() as T;
  }
  
  void save(T entity) {
    _session.domain.models
        .getModelEntries(_conceptCode)
        .add(entity);
  }
  
  bool remove(T entity) {
    return _session.domain.models
        .getModelEntries(_conceptCode)
        .remove(entity);
  }
  
  // Query methods
  Entities<T> getAll() {
    return _session.domain.models
        .getModelEntries(_conceptCode) as Entities<T>;
  }
  
  T? getById(Id id) {
    return _session.domain.models
        .getModelEntries(_conceptCode)
        .singleWhereId(id) as T?;
  }
  
  // Other implementation details...
}
```

This base class can be extended for specific domain entities:

```dart
class OrderRepository extends Repository<Order> {
  OrderRepository(DomainSession session) 
      : super(session, 'Order');
      
  // Domain-specific query methods
  Entities<Order> findByCustomer(Customer customer) {
    return getAll().selectWhereParent('customer', customer);
  }
  
  Entities<Order> findPendingOrders() {
    return getAll().selectWhereAttribute('status', 'pending');
  }
}
```

## Transaction Management

EDNet Core repositories work seamlessly with the transaction system to ensure data consistency:

```dart
// Example of transaction usage with repositories
void placeOrder(Order order) {
  final transaction = session.beginTransaction('PlaceOrder');
  
  try {
    // Get repositories
    final orderRepo = OrderRepository(session);
    final inventoryRepo = InventoryRepository(session);
    
    // Perform operations
    for (var item in order.lineItems) {
      inventoryRepo.reduceStock(item.product, item.quantity);
    }
    orderRepo.save(order);
    
    // Commit if everything succeeded
    transaction.commit();
  } catch (e) {
    // Rollback on error
    transaction.rollback();
    throw OrderException('Failed to place order: $e');
  }
}
```

Transactions in EDNet Core provide:

1. **Atomicity**: All operations succeed or fail together
2. **Consistency**: The domain model remains in a valid state
3. **Isolation**: Changes are isolated until transaction completion
4. **Durability**: Committed changes persist (when using persistent storage)

## Query Capabilities

EDNet repositories provide rich querying capabilities through the underlying `Entities` collection:

```dart
// Basic querying with repositories
final orderRepo = OrderRepository(session);

// Find all orders for a customer
final customerOrders = orderRepo.findByCustomer(customer);

// Find recent high-value orders
final highValueOrders = orderRepo.getAll()
    .where((order) => order.getAttribute<double>('total')! > 1000)
    .whereType<Order>()
    .order((a, b) => b.createdAt.compareTo(a.createdAt))
    .takeFirst(10);
```

For more complex queries, EDNet Core supports query objects:

```dart
class OrderQuery {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? status;
  final double? minTotal;
  
  OrderQuery({this.fromDate, this.toDate, this.status, this.minTotal});
  
  Entities<Order> execute(OrderRepository repository) {
    var result = repository.getAll();
    
    if (fromDate != null) {
      result = result.where((order) => 
          order.getAttribute<DateTime>('createdAt')!.isAfter(fromDate!))
          .whereType<Order>();
    }
    
    if (toDate != null) {
      result = result.where((order) => 
          order.getAttribute<DateTime>('createdAt')!.isBefore(toDate!))
          .whereType<Order>();
    }
    
    if (status != null) {
      result = result.selectWhereAttribute('status', status!);
    }
    
    if (minTotal != null) {
      result = result.where((order) => 
          order.getAttribute<double>('total')! >= minTotal!)
          .whereType<Order>();
    }
    
    return result as Entities<Order>;
  }
}

// Using the query object
final query = OrderQuery(
  fromDate: DateTime(2023, 1, 1),
  status: 'completed',
  minTotal: 500,
);

final matchingOrders = query.execute(orderRepo);
```

## Persistence Strategies

EDNet Core repositories can work with different persistence mechanisms:

1. **In-memory**: For testing or simple applications
2. **Document databases**: Like MongoDB or Firestore
3. **Relational databases**: Using SQL adapters
4. **Event sourcing**: Storing event streams instead of current state

The repository implementation abstracts these details away from the domain model:

```dart
// Example of repository factory with different persistence options
class RepositoryFactory {
  final DomainSession session;
  
  RepositoryFactory(this.session);
  
  OrderRepository createOrderRepository() {
    // Configuration determines implementation
    switch (session.persistenceStrategy) {
      case PersistenceStrategy.inMemory:
        return InMemoryOrderRepository(session);
      case PersistenceStrategy.mongodb:
        return MongoDbOrderRepository(session);
      case PersistenceStrategy.eventSourcing:
        return EventSourcedOrderRepository(session);
      default:
        return OrderRepository(session);
    }
  }
}
```

## Event Publishing

EDNet repositories can automatically publish domain events when entities change:

```dart
class EventPublishingRepository<T extends Entity<T>> extends Repository<T> {
  final EventBus _eventBus;
  
  EventPublishingRepository(DomainSession session, String conceptCode, this._eventBus)
      : super(session, conceptCode);
  
  @override
  void save(T entity) {
    super.save(entity);
    
    // If this is an AggregateRoot with pending events
    if (entity is AggregateRoot) {
      for (var event in entity.pendingEvents) {
        _eventBus.publish(event);
      }
      entity.markEventsAsProcessed();
    } else {
      // For regular entities, publish a generic EntityChanged event
      _eventBus.publish(EntityChangedEvent(entity));
    }
  }
}
```

## Testing with Repositories

EDNet's repository pattern simplifies testing by allowing test doubles to be substituted:

```dart
class MockOrderRepository extends OrderRepository {
  final List<Order> _mockOrders = [];
  
  MockOrderRepository() : super(MockSession());
  
  @override
  void save(Order order) {
    _mockOrders.add(order);
  }
  
  @override
  Entities<Order> getAll() {
    final entities = Entities<Order>();
    for (var order in _mockOrders) {
      entities.add(order);
    }
    return entities;
  }
  
  // Other mocked methods...
}

// Using in tests
test('should place order and reduce inventory', () {
  // Arrange
  final mockOrderRepo = MockOrderRepository();
  final mockInventoryRepo = MockInventoryRepository();
  final orderService = OrderService(mockOrderRepo, mockInventoryRepo);
  
  // Act
  orderService.placeOrder(testOrder);
  
  // Assert
  expect(mockOrderRepo.getAll().length, equals(1));
  expect(mockInventoryRepo.getStockReduction(testProduct), equals(5));
});
```

## Conclusion

The Repository pattern in EDNet Core provides a powerful abstraction for working with domain objects, separating domain logic from persistence concerns. By implementing rich querying capabilities, transaction support, and flexible persistence strategies, EDNet repositories enable developers to focus on the domain model while ensuring data is properly managed.

In the next article, we'll explore EDNet's approach to error handling and validation, which works closely with the repository pattern to maintain domain invariants.

---

*This article is part of the extended #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

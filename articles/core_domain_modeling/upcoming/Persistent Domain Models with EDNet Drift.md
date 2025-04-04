# Persistent Domain Models with EDNet Drift: Beyond In-Memory State

## Introduction

Domain models are the backbone of modern software systems, encoding business rules and driving core application logic. However, for most real-world applications, these models need persistence to survive application restarts and to sync across devices. Enter EDNet Drift - a powerful integration between EDNet Core's rich domain modeling capabilities and the type-safe, reactive SQLite persistence provided by the Drift package.

In this article, we'll explore how EDNet Drift enables seamless persistence of domain models without sacrificing the expressiveness and purity of your domain layer. We'll see how this integration preserves the benefits of domain-driven design while providing robust data storage capabilities.

## The Persistence Dilemma

When implementing domain-driven designs, developers often face a challenging question: how do we persist our carefully crafted domain models without contaminating them with storage concerns? Common approaches include:

1. **Object-Relational Mapping (ORM)**: Maps domain entities to database tables, but often leads to the "impedance mismatch" problem.
2. **Active Record Pattern**: Blends domain and persistence concerns, but can violate separation of concerns.
3. **Repository Pattern**: Provides a collection-like interface for retrieving domain objects, but implementation can be complex.
4. **Event Sourcing**: Persists event streams rather than current state, requiring specialized storage strategies.

EDNet Drift takes a hybrid approach that combines the repository pattern with reactive, type-safe database access.

## Introducing EDNet Drift

EDNet Drift is a specialized persistence layer for EDNet Core that leverages the powerful Drift SQLite toolkit. It provides:

1. **Type-safe persistence**: Compile-time verification of database operations
2. **Reactive data access**: Stream-based queries that update UI when data changes
3. **Domain-driven repositories**: Repository implementations that preserve domain integrity
4. **Migration support**: Seamless database schema evolution as your model changes
5. **Cross-platform storage**: Works on all Flutter platforms - mobile, desktop, and web

## Core Architecture

The architecture of EDNet Drift consists of three main layers:

```txt
┌─────────────────────┐
│  Domain Model       │
│  (EDNet Core)       │
└─────────────────────┘
           ↑↓
┌─────────────────────┐
│  Repository Layer   │
│  (EDNet Drift)      │
└─────────────────────┘
           ↑↓
┌─────────────────────┐
│  Database Layer     │
│  (Drift + SQLite)   │
└─────────────────────┘
```

These layers work together to provide a seamless experience:

1. **Domain Model**: Your pure domain model built with EDNet Core, focused on business rules and logic
2. **Repository Layer**: Translates between domain objects and database records
3. **Database Layer**: Provides type-safe, efficient data storage and retrieval

## Implementation Example

Let's walk through implementing a persistent domain model using EDNet Drift.

### 1. Define your domain model using EDNet Core

First, we define our domain model using standard EDNet Core patterns:

```dart
// Domain entity
class Product extends Entity<Product> {
  String get name => getAttribute<String>('name') ?? '';
  set name(String value) => setAttribute('name', value);
  
  double get price => getAttribute<double>('price') ?? 0.0;
  set price(double value) => setAttribute('price', value);
  
  int get stockLevel => getAttribute<int>('stockLevel') ?? 0;
  set stockLevel(int value) => setAttribute('stockLevel', value);
}

// Domain repository interface
abstract class IProductRepository {
  Future<Product> getById(String id);
  Future<List<Product>> getAll();
  Future<void> save(Product product);
  Future<void> delete(Product product);
  Stream<List<Product>> watchAll();
}
```

### 2. Define drift database schema

Next, we define our database schema using Drift's type-safe DSL:

```dart
// In products.drift
CREATE TABLE products (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  stock_level INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

getAllProducts: SELECT * FROM products ORDER BY name;
getProductById: SELECT * FROM products WHERE id = ?;
```

### 3. Implement the drift database class

Then we implement the database class:

```dart
@DriftDatabase(tables: [Products], queries: {
  'getAllProducts': 'SELECT * FROM products ORDER BY name',
  'getProductById': 'SELECT * FROM products WHERE id = ?',
})
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor executor) : super(executor);
  
  @override
  int get schemaVersion => 1;
  
  Future<void> saveProduct(ProductsCompanion product) async {
    await into(products).insertOnConflictUpdate(product);
  }
  
  Future<void> deleteProduct(String id) async {
    await (delete(products)..where((p) => p.id.equals(id))).go();
  }
}
```

### 4. Implement the EDNet Drift repository

Finally, we implement the repository that bridges our domain model with the database:

```dart
class DriftProductRepository implements IProductRepository {
  final AppDatabase _database;
  
  DriftProductRepository(this._database);
  
  @override
  Future<Product> getById(String id) async {
    final productRow = await _database.getProductById(id).getSingleOrNull();
    if (productRow == null) {
      throw EntityNotFoundException('Product with ID $id not found');
    }
    return _mapToEntity(productRow);
  }
  
  @override
  Future<List<Product>> getAll() async {
    final products = await _database.getAllProducts().get();
    return products.map(_mapToEntity).toList();
  }
  
  @override
  Stream<List<Product>> watchAll() {
    return _database.getAllProducts().watch()
      .map((rows) => rows.map(_mapToEntity).toList());
  }
  
  @override
  Future<void> save(Product product) async {
    await _database.saveProduct(
      ProductsCompanion(
        id: Value(product.id.toString()),
        name: Value(product.name),
        price: Value(product.price),
        stockLevel: Value(product.stockLevel),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        createdAt: Value(product.whenAdded?.millisecondsSinceEpoch ?? 
            DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
  
  @override
  Future<void> delete(Product product) async {
    await _database.deleteProduct(product.id.toString());
  }
  
  // Helper method to map database rows to domain entities
  Product _mapToEntity(ProductsData row) {
    final product = Product();
    product.id = Id.fromString(row.id);
    product.name = row.name;
    product.price = row.price;
    product.stockLevel = row.stockLevel;
    product.whenAdded = DateTime.fromMillisecondsSinceEpoch(row.createdAt);
    product.whenSet = DateTime.fromMillisecondsSinceEpoch(row.updatedAt);
    return product;
  }
}
```

## Advanced Features

### Event-Sourced Persistence

EDNet Drift also supports event-sourced persistence for aggregate roots:

```dart
class EventSourcedRepository<T extends AggregateRoot<T>> {
  final AppDatabase _database;
  final EventMapper<T> _eventMapper;
  
  EventSourcedRepository(this._database, this._eventMapper);
  
  Future<T> getById(String id) async {
    // Fetch all events for this aggregate
    final events = await _database.getEventsByAggregateId(id).get();
    
    // Create a new aggregate instance
    final aggregate = _createEmptyAggregate();
    
    // Apply events to rebuild aggregate state
    final domainEvents = events.map(_eventMapper.mapToDomainEvent).toList();
    aggregate.rehydrateFromEventHistory(domainEvents);
    
    return aggregate;
  }
  
  Future<void> save(T aggregate) async {
    // Store all pending events
    for (final event in aggregate.pendingEvents) {
      final dbEvent = _eventMapper.mapToDbEvent(event);
      await _database.saveEvent(dbEvent);
    }
    
    // Mark events as processed
    aggregate.markEventsAsProcessed();
  }
  
  // Abstract method to be implemented by concrete repositories
  T _createEmptyAggregate();
}
```

### Multi-Platform Support

EDNet Drift works across platforms with appropriate database drivers:

```dart
// Factory to create the right database for each platform
QueryExecutor getDatabaseExecutor() {
  if (kIsWeb) {
    return WebDatabase('app_database');
  } else if (Platform.isAndroid || Platform.isIOS) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'app_database.sqlite'));
      return NativeDatabase(file);
    });
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'app_database.sqlite'));
      return NativeDatabase(file);
    });
  }
  throw UnsupportedError('Unsupported platform');
}
```

### Schema Migrations

As your domain model evolves, EDNet Drift handles schema migrations seamlessly:

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) {
    return m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from < 2) {
      // Migration for schema version 1 to 2
      await m.addColumn(products, products.categoryId);
    }
    if (from < 3) {
      // Migration for schema version 2 to 3
      await m.createTable(productTags);
    }
  },
);
```

## Integration with Domain Policies and Rules

EDNet Drift repositories can automatically enforce domain policies when loading or saving data:

```dart
class PolicyEnforcingRepository<T extends Entity<T>> implements Repository<T> {
  final DriftRepository<T> _repository;
  final PolicyEvaluator _policyEvaluator;
  
  PolicyEnforcingRepository(this._repository, this._policyEvaluator);
  
  @override
  Future<void> save(T entity) async {
    // Evaluate policies before saving
    final result = _policyEvaluator.evaluate(entity);
    if (!result.success) {
      throw PolicyViolationException(result.violations);
    }
    
    // If policies pass, proceed with save
    await _repository.save(entity);
  }
  
  // Other methods would follow a similar pattern
}
```

## Transaction Support

EDNet Drift supports transactions to ensure data consistency:

```dart
Future<void> transferFunds(Account from, Account to, double amount) async {
  await _database.transaction(() async {
    // Deduct from source account
    from.balance -= amount;
    await _accountRepository.save(from);
    
    // Add to destination account
    to.balance += amount;
    await _accountRepository.save(to);
    
    // Record the transfer
    final transfer = Transfer(from, to, amount, DateTime.now());
    await _transferRepository.save(transfer);
  });
}
```

## Performance Considerations

When working with large domain models, performance can become a concern. EDNet Drift provides several optimization strategies:

1. **Selective loading**: Load only the parts of aggregates that are needed
2. **Lazy relationships**: Defer loading related entities until they're accessed
3. **Pagination**: Load large collections in chunks
4. **Indexes**: Optimize database performance with appropriate indexes

```dart
// Example of pagination
class PaginatedDriftRepository<T extends Entity<T>> {
  final AppDatabase _database;
  final int _pageSize;
  
  PaginatedDriftRepository(this._database, {int pageSize = 20})
      : _pageSize = pageSize;
  
  Future<List<T>> getPage(int pageNumber) async {
    final offset = pageNumber * _pageSize;
    final rows = await (_database.select(_database.entities)
      ..limit(_pageSize, offset: offset)
    ).get();
    
    return rows.map(_mapToEntity).toList();
  }
  
  // Other methods...
}
```

## Conclusion

EDNet Drift bridges the gap between rich domain modeling and robust persistence, enabling developers to build applications that are both domain-driven and data-persistent. By combining the expressive power of EDNet Core with the type-safe, reactive database access of Drift, developers can create applications that maintain domain integrity while efficiently storing and retrieving data.

This persistence layer is a key component in the EDNet ecosystem, working alongside other features like the command-event-policy cycle, meta-modeling, and policy enforcement to provide a comprehensive solution for building complex, domain-driven applications.

In the next article, we'll explore how the EDNet One Interpreter enables domain experts to express domain models in natural, domain-specific languages, further extending the power of the EDNet ecosystem.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

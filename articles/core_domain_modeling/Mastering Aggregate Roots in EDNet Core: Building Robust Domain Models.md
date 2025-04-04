# Mastering Aggregate Roots in EDNet Core: Building Robust Domain Models

## Introduction

In Domain-Driven Design (DDD), the Aggregate Root pattern is a crucial tactical design element that ensures domain integrity and consistency. As part of our ongoing series on EDNet Core, this article explores how we've implemented the Aggregate Root pattern to provide a seamless, type-safe approach to domain modeling in Dart.

## The Aggregate Root Pattern: A Quick Refresher

Before diving into implementation, let's remember what an Aggregate Root is:

- **Consistency boundary** - Ensures all related objects maintain valid state transitions
- **Single entry point** - The only object in the aggregate that external code can reference
- **Transaction scope** - Defines a boundary for atomic operations
- **Identity provider** - Provides a stable identity for the entire aggregate
- **Rule enforcer** - Implements business rules that span multiple entities

## Command-Event-Policy Cycle: The Heart of Dynamic Domains

EDNet Core now implements a powerful command-event-policy cycle:

```txt
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Commands  │────▶│    Events   │────▶│   Policies  │
└─────────────┘     └─────────────┘     └─────────────┘
       ▲                                       │
       │                                       │
       └───────────────────────────────────────┘
```

1. **Commands** - Express user intent and are executed on AggregateRoots
2. **Events** - Record what happened when commands were executed
3. **Policies** - React to events and may generate new commands

## Implementation in EDNet Core

The AggregateRoot in EDNet Core extends the existing Entity framework:

```dart
abstract class AggregateRoot<T extends Entity<T>> extends Entity<T> {
  final List<dynamic> _pendingEvents = [];
  int _version = 0;
  
  // Get current version
  int get version => _version;
  
  // Get pending events
  List<dynamic> get pendingEvents => List.unmodifiable(_pendingEvents);
  
  // Clear pending events
  void markEventsAsProcessed() {
    _pendingEvents.clear();
  }
  
  // Record events with domain context
  dynamic recordEvent(String name, String description, List<String> handlers, {
    Map<String, dynamic> data = const {},
  }) {
    // implementation...
  }
  
  // Execute commands with validation
  dynamic executeCommand(dynamic command) {
    // implementation...
  }
  
  // Apply events to update state
  void applyEvent(dynamic event) {
    // Override in concrete classes
  }
  
  // Rehydrate from event history
  void rehydrateFromEventHistory(List<dynamic> eventHistory) {
    // implementation...
  }
}
```

## Using Aggregate Roots in Your Domain

Here's a practical example using a Product aggregate:

```dart
class Product extends AggregateRoot<Product> {
  String name;
  double price;
  List<Review> reviews = [];
  
  @override
  void applyEvent(dynamic event) {
    if (event.name == 'ProductCreated') {
      name = event.data['name'];
      price = event.data['price'];
    } else if (event.name == 'ReviewAdded') {
      reviews.add(Review(
        event.data['rating'],
        event.data['comment'],
        event.data['reviewer']
      ));
    }
  }
  
  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();
    
    if (price < 0) {
      exceptions.add(ValidationException(
        'price',
        'Price cannot be negative',
        entity: this
      ));
    }
    
    return exceptions;
  }
}
```

## Integration with EDNet's Application Services

AggregateRoots work seamlessly with EDNet's ApplicationService:

```dart
class ProductService extends ApplicationService {
  final ProductRepository _repository;
  
  ProductService(DomainSession session, this._repository) : super(session);
  
  dynamic createProduct(CreateProductCommand command) {
    // Start transaction
    final transaction = beginTransaction('CreateProduct');
    
    try {
      // Create and validate the product
      final product = Product();
      product.name = command.name;
      product.price = command.price;
      
      // Execute the command
      final result = product.executeCommand(command);
      if (!result['isSuccess']) {
        return result;
      }
      
      // Save and publish events
      _repository.save(product);
      publishEvents(product.pendingEvents);
      product.markEventsAsProcessed();
      
      // Commit transaction
      transaction.commit();
      
      return result;
    } catch (e) {
      transaction.rollback();
      return {'isSuccess': false, 'errorMessage': e.toString()};
    }
  }
}
```

## Event-Triggered Policies

One of the most powerful features is the ability to react to domain events through policies:

```dart
class LowStockNotificationPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'LowStockNotification';
  
  @override
  bool evaluate(Entity entity) {
    return entity is Product;
  }
  
  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event.name == 'InventoryChanged';
  }
  
  @override
  void executeActions(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'];
    
    if (newStock < product.reorderThreshold) {
      // Perform notification action
    }
  }
  
  @override
  List<dynamic> generateCommands(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'];
    
    if (newStock < product.reorderThreshold) {
      return [CreatePurchaseOrderCommand(product)];
    }
    return [];
  }
}
```

## Benefits of EDNet's Aggregate Root Implementation

Our implementation provides several advantages:

1. **Type-safe domain modeling** - Leverages Dart's static type system
2. **Event sourcing capability** - Built-in event recording and replay
3. **Command-validation flow** - Automatic enforcement of business rules
4. **Policy automation** - Reactive domain logic that can trigger new workflows
5. **Seamless integration** - Works with existing Entity and Repository patterns

## Conclusion

The AggregateRoot pattern in EDNet Core provides a powerful foundation for implementing rich domain models following DDD principles. By encapsulating state changes, enforcing invariants, and supporting event-driven architectures, it enables robust, maintainable domain models.

In the next articles in this series, we'll explore advanced features like:

- Event sourcing with EDNet
- Complex business process orchestration
- Testing strategies for Aggregate Roots

Join us on this journey of building better domain models with EDNet Core!

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

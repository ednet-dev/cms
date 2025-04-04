## What is EDNet Core?

EDNet Core is a sophisticated domain modeling framework for Dart that empowers developers to implement complex business logic using Domain-Driven Design (DDD) principles. Unlike traditional frameworks that focus primarily on data persistence or UI components, EDNet Core provides the tactical patterns and infrastructure needed to express rich domain models that truly capture business complexity.

## The Philosophy Behind EDNet Core

EDNet Core embraces several key principles:

1. **Domain First**: The domain model is the heart of the application, not an afterthought.
2. **Metadata-Driven**: Runtime introspection and meta-modeling allow for powerful abstractions.
3. **Type Safety**: Leveraging Dart's type system for robust, self-documenting code.
4. **Expressiveness**: Rich vocabulary for domain experts to collaborate with developers.
5. **Composable Patterns**: Tactical DDD patterns that work together harmoniously.

## Core Building Blocks

EDNet Core provides implementations of essential DDD tactical patterns:

### Entities and Identity

```dart
class Customer extends Entity<Customer> {
  String get name => getAttribute<String>('name')!;
  set name(String value) => setAttribute('name', value);
  
  String get email => getAttribute<String>('email')!;
  set email(String value) => setAttribute('email', value);
}
```

Entities maintain identity through state changes and enforce business rules through validation.

### Value Objects

```dart
class EmailAddress extends ValueObject {
  final String value;
  
  EmailAddress(this.value) {
    if (!_isValidEmail(value)) {
      throw ValidationException('email', 'Invalid email format');
    }
  }
  
  bool _isValidEmail(String email) => 
    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
}
```

Value objects are immutable, interchangeable objects defined by their attributes rather than identity.

### Aggregates and Boundaries

```dart
class Order extends AggregateRoot<Order> {
  Customer get customer => getParent('customer') as Customer;
  set customer(Customer value) => setParent('customer', value);
  
  Entities<OrderLine> get lines => getChild('lines') as Entities<OrderLine>;
  
  double get total => lines
    .map<double>((line) => line.quantity * line.unitPrice)
    .fold(0, (sum, amount) => sum + amount);
}
```

Aggregates define consistency boundaries and encapsulate related entities.

### Domain Events

```dart
final event = orderAggregate.recordEvent(
  'OrderShipped',
  'Order has been prepared and shipped to customer',
  ['ShippingHandler', 'NotificationHandler'],
  data: {'trackingNumber': 'SHP123456789'}
);
```

Events capture significant state changes and allow for reactive behavior.

### Repositories

```dart
class OrderRepository {
  final DomainSession session;
  
  OrderRepository(this.session);
  
  Future<Order?> getById(String orderId) async {
    // Implementation to retrieve from data store
  }
  
  Future<void> save(Order order) async {
    // Implementation to persist to data store
  }
}
```

Repositories provide data access abstraction and enforce aggregate boundaries.

## Meta-Modeling: The Secret Sauce

What makes EDNet Core particularly powerful is its meta-modeling capability, allowing for runtime introspection and dynamic behavior:

```dart
// Define the model structure using concepts
final orderConcept = Concept(model, 'Order')
  ..entry = true;

final customerParent = Parent('customer', orderConcept)
  ..required = true
  ..destination = customerConcept;
orderConcept.parents.add(customerParent);

final linesChild = Child('lines', orderConcept)
  ..destination = orderLineConcept
  ..internal = true;
orderConcept.children.add(linesChild);

// Now entities are aware of their structure
final order = Order();
order.concept = orderConcept;
```

This meta-model awareness unlocks powerful capabilities:
- Automatic validation based on model constraints
- Dynamic UI generation
- Serialization/deserialization
- Policy evaluation

## Putting It All Together

Here's how these components come together in a typical EDNet Core application:

```dart
void main() {
  // 1. Define your domain model
  final domain = Domain('ECommerce');
  final model = Model(domain, 'Orders');
  
  // 2. Set up your concepts and relationships
  defineModelStructure(model);
  
  // 3. Instantiate your session
  final session = DomainSession(model);
  
  // 4. Use repositories to interact with your domain
  final orderRepo = OrderRepository(session);
  
  // 5. Execute your business logic
  createOrder(orderRepo, session);
}

Future<void> createOrder(OrderRepository repo, DomainSession session) async {
  final service = OrderService(session, repo);
  
  final command = CreateOrderCommand(
    customerId: 'CUST123',
    items: [
      {'productId': 'PROD456', 'quantity': 2},
      {'productId': 'PROD789', 'quantity': 1}
    ]
  );
  
  final result = await service.createOrder(command);
  
  if (result['isSuccess']) {
    print('Order created: ${result['data']['orderId']}');
  } else {
    print('Failed: ${result['errorMessage']}');
  }
}
```

## Why Choose EDNet Core?

EDNet Core stands out for several reasons:

1. **Rich Domain Modeling**: Implements the full spectrum of DDD tactical patterns
2. **Meta-Model Support**: Runtime introspection and structural awareness
3. **Dart/Flutter Integration**: Built specifically for the Dart ecosystem
4. **Policy-Driven Logic**: Declarative business rules with automatic enforcement
5. **Event Sourcing Ready**: Built-in support for event-based architectures

## Conclusion

EDNet Core provides a comprehensive toolkit for domain-driven design in Dart, enabling developers to build rich, expressive domain models that accurately capture business complexity. In the upcoming articles in this series, we'll dive deeper into each component of the framework, exploring how they work together to create powerful, maintainable applications.

In the next article, we'll explore the Entity pattern in detail, examining how EDNet Core implements this fundamental building block of domain models.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

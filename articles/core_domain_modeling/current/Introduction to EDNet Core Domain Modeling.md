# Introduction to EDNet Core Domain Modeling

## Understanding Domain-Driven Design in Dart

Domain-Driven Design (DDD) has established itself as a powerful approach for tackling complex software systems. By focusing on creating a shared language between technical and domain experts, DDD enables developers to build software that better reflects the real-world domain it serves. EDNet Core brings these concepts to the Dart ecosystem, providing a comprehensive framework for implementing domain models that are both expressive and maintainable.

## What is EDNet Core?

EDNet Core is an open-source library designed to support domain modeling in Dart applications. It provides a rich set of building blocks for implementing domain-driven design patterns while leveraging Dart's strong typing and modern language features. Unlike many ORM or data modeling libraries, EDNet Core focuses on capturing rich business behaviors, domain rules, and complex relationships.

At its foundation, EDNet Core provides:

- **Rich domain modeling capabilities** with support for entities, value objects, aggregates, and repositories
- **Meta-modeling** through a concept-based architecture that enables runtime introspection
- **Reactive domain behavior** through a command-event-policy cycle
- **Validation and business rule enforcement** at all levels of the domain model
- **Event sourcing support** for tracking and replaying changes to the domain state

## The Building Blocks of EDNet Core

EDNet Core is built around several key concepts that work together to form a comprehensive domain modeling framework:

```
┌───────────────────┐     ┌───────────────────┐     ┌───────────────────┐
│                   │     │                   │     │                   │
│     Entities      │◄────┤     Concepts      │────►│     Attributes    │
│                   │     │                   │     │                   │
└───────┬───────────┘     └─────────┬─────────┘     └───────────────────┘
        │                           │
        │                           │
┌───────▼───────────┐     ┌─────────▼─────────┐     ┌───────────────────┐
│                   │     │                   │     │                   │
│ Aggregate Roots   │     │     Policies      │◄────┤    Commands       │
│                   │     │                   │     │                   │
└───────┬───────────┘     └─────────┬─────────┘     └───────┬───────────┘
        │                           │                       │
        │                           │                       │
┌───────▼───────────┐     ┌─────────▼─────────┐     ┌───────▼───────────┐
│                   │     │                   │     │                   │
│   Repositories    │     │      Events       │◄────┤   Transactions    │
│                   │     │                   │     │                   │
└───────────────────┘     └───────────────────┘     └───────────────────┘
```

### 1. Meta-Model Components

The meta-model provides the foundation for EDNet Core's domain modeling capabilities:

- **Concept**: Defines the structure of domain objects, including attributes, relationships, and constraints
- **Attribute**: Defines the properties of domain objects, including types, validation rules, and default values
- **Relationship**: Defines connections between concepts (Parent and Child relationships)

### 2. Domain Model Components

Building on the meta-model, these components represent the actual domain objects:

- **Entity**: Objects with distinct identity that persists throughout changes to their attributes
- **Entities**: Collections of entities with rich querying and relationship management
- **AggregateRoot**: Special entities that form consistency boundaries within the domain
- **Repository**: Provides access to domain objects and encapsulates persistence

### 3. Behavior Components

These components capture the dynamic behavior of the domain:

- **Command**: Represents an intent to change the domain state
- **Event**: Represents something that has happened in the domain
- **Policy**: Encapsulates business rules and reactions to domain events
- **Transaction**: Manages atomic changes to the domain state

## Why Choose EDNet Core?

EDNet Core offers several advantages over other domain modeling approaches:

### 1. Rich Domain Expression

Unlike simple data models or ORMs, EDNet Core enables you to express complex domain behaviors, constraints, and relationships. The meta-model allows for runtime introspection and validation, ensuring domain rules are consistently enforced.

```dart
// Creating a rich domain concept
var customerConcept = Concept(model, 'Customer');
customerConcept.entry = true;

// Adding attributes with validation rules
var emailAttribute = Attribute('email', customerConcept);
emailAttribute.type = StringType..pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
emailAttribute.required = true;
customerConcept.attributes.add(emailAttribute);
```

### 2. Type-Safe Domain Models

EDNet Core leverages Dart's strong typing to provide type safety throughout your domain model:

```dart
// Type-safe entity creation
class Customer extends Entity<Customer> {
  String get email => getAttribute<String>('email')!;
  set email(String value) => setAttribute('email', value);
  
  List<Order> get orders => 
      getChild('orders')?.cast<Order>().toList() ?? [];
}
```

### 3. Event-Driven Architecture

The framework's support for event sourcing and the command-event-policy cycle enables reactive, event-driven domain models:

```dart
// Command execution that produces events
final command = PlaceOrderCommand(customer, items);
final result = orderAggregate.executeCommand(command);

// Events can be captured and processed
for (var event in orderAggregate.pendingEvents) {
  eventBus.publish(event);
}
```

### 4. Flexible Meta-Modeling

The concept-based meta-model provides a powerful foundation for dynamic domain models that can evolve at runtime:

```dart
// Runtime model introspection
final attributes = customerConcept.attributes;
final requiredAttributes = customerConcept.requiredAttributes;
final relationships = customerConcept.parents.toList() 
                     + customerConcept.children.toList();
```

## A Simple Example

To illustrate how these components work together, let's consider a simple e-commerce domain model:

```dart
// Domain model definition
var model = Model(Domain('ECommerce'), 'ShopModel');

// Product concept
var productConcept = Concept(model, 'Product');
productConcept.entry = true;
var nameAttr = Attribute('name', productConcept);
nameAttr.required = true;
productConcept.attributes.add(nameAttr);

var priceAttr = Attribute('price', productConcept);
priceAttr.type = model.domain.types.getTypeByCode('double');
priceAttr.required = true;
productConcept.attributes.add(priceAttr);

// Order concept
var orderConcept = Concept(model, 'Order');
orderConcept.entry = true;

// LineItem concept with relationships
var lineItemConcept = Concept(model, 'LineItem');
var productParent = Parent('product', lineItemConcept);
productParent.destinationConcept = productConcept;
productParent.required = true;
lineItemConcept.parents.add(productParent);

var orderParent = Parent('order', lineItemConcept);
orderParent.destinationConcept = orderConcept;
orderParent.internal = true;
orderParent.required = true;
lineItemConcept.parents.add(orderParent);

// Using the domain model
var product = Product();
product.concept = productConcept;
product.name = 'Dart T-Shirt';
product.price = 25.99;

var order = Order();
order.concept = orderConcept;

var lineItem = LineItem();
lineItem.concept = lineItemConcept;
lineItem.setParent('product', product);
lineItem.setParent('order', order);
lineItem.quantity = 2;
```

## Getting Started with EDNet Core

To begin using EDNet Core in your Dart project, add it to your `pubspec.yaml`:

```yaml
dependencies:
  ednet_core: ^1.0.0
```

Then, you can start building your domain model:

1. Define your domain and model
2. Create concepts for your domain entities
3. Define attributes and relationships
4. Implement entity classes
5. Create repositories for entity access

## What's Next?

Throughout this series, we'll explore each component of EDNet Core in detail:

- **The Entity Pattern in EDNet Core**: Understanding the fundamental building block of domain models
- **Working with Entity Collections in EDNet Core**: Managing collections of domain objects
- **Mastering Aggregate Roots in EDNet Core**: Implementing consistency boundaries
- **Meta-Modeling with Concepts**: Leveraging the power of meta-models
- **Policies and Rules**: Enforcing domain logic
- **Event Sourcing and Domain Events**: Capturing domain state changes
- **The Command-Event-Policy Cycle**: Building reactive domain models

In the next article, we'll dive deep into the Entity pattern, exploring how EDNet Core implements this fundamental building block of domain-driven design.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

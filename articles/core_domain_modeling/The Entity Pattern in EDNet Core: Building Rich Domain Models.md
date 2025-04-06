
# The Entity Pattern in EDNet Core: Building Rich Domain Models

## Introduction

In Domain-Driven Design, the Entity pattern represents objects with a distinct identity that persists throughout their lifecycle, regardless of attribute changes. EDNet Core provides a powerful implementation of the Entity pattern that goes beyond basic identification to support rich domain modeling capabilities. This article explores how EDNet's Entity class forms the foundation for building expressive, type-safe domain models in Dart.

## The Entity in Domain-Driven Design

In DDD, an Entity is distinguished by having:

- A **unique identity** that remains stable throughout state changes
- A **lifecycle** that can be tracked from creation to deletion
- **Business rules** that maintain its internal consistency
- **Relationships** with other domain objects

EDNet Core implements all these characteristics while adding powerful features like meta-model awareness, rich validation capabilities, and policy enforcement.

## Implementation in EDNet Core

At its core, EDNet's Entity is a generic class that forms the foundation of the domain model:

```dart
class Entity<E extends Entity<E>> implements IEntity<E> {
  Concept? _concept;
  var _oid = Oid();
  String? _code;
  DateTime? _whenAdded;
  DateTime? _whenSet;
  DateTime? _whenRemoved;
  
  // Internal storage
  Map<String, Object?> _attributeMap = <String, Object?>{};
  Map<String, Reference> _referenceMap = <String, Reference>{};
  Map<String, Object?> _parentMap = <String, Object?>{};
  Map<String, Object?> _childMap = <String, Object?>{};
  
  // Implementation logic...
}
```

The class uses Dart's generic types for self-reference, allowing for type-safe operations across an inheritance hierarchy. The `<E extends Entity<E>>` parameter enables methods to return properly typed results even in subclasses.

## Identity Management

EDNet provides multiple ways to identify an entity:

1. **Oid (Object ID)**: A globally unique identifier automatically assigned at creation
2. **Code**: A human-readable string identifier often used in business contexts
3. **Id**: A composite identifier that can combine multiple attributes and references

```dart
// Ways to reference an entity
final orderByOid = repository.getByOid(Oid.ts(timestamp));
final orderByCode = repository.getByCode("ORD-2023-12345");
final orderById = repository.getById(Id(orderConcept)
  ..setAttribute("orderNumber", "2023-12345"));
```

This flexibility allows domain models to use the identification scheme most appropriate for the business context.

## Attribute Management

Entities maintain attributes with rich type support and validation:

```dart
// Setting attributes with type safety
entity.setAttribute("price", 299.99);
entity.setAttribute("name", "Premium Widget");
entity.setAttribute("createdAt", DateTime.now());

// Getting typed attributes
double price = entity.getAttribute<double>("price")!;
String name = entity.getAttribute<String>("name")!;
```

EDNet Core also supports dynamic attribute parsing and type conversion:

```dart
// Parsing from string representations
entity.setStringToAttribute("price", "299.99"); // Converts to double
entity.setStringToAttribute("available", "true"); // Converts to boolean
```

## Relationship Management

One of EDNet's most powerful features is its relationship management system:

```dart
// Parent relationships (many-to-one)
entity.setParent("customer", customerEntity);
var customer = entity.getParent("customer");

// Child relationships (one-to-many)
var lineItems = entity.getChild("lineItems") as Entities<LineItem>;
lineItems.add(newLineItem);
```

These relationships are enforced by EDNet's meta-model through the Concept class, which defines the structure of each entity type including its attributes, parents, and children.

## Lifecycle Tracking

Every Entity in EDNet tracks its lifecycle:

```dart
final createdAt = entity.whenAdded;     // When entity was first created
final lastUpdated = entity.whenSet;     // When entity was last modified
final deletedAt = entity.whenRemoved;   // When entity was logically deleted
```

This automatic tracking provides an audit trail without requiring additional code.

## Meta-Model Awareness

What sets EDNet apart is its integration with a meta-model through the Concept class:

```dart
// Entity linked to its concept (meta-model)
final concept = entity.concept;

// Discovering structure through the meta-model
final attributes = concept.attributes;
final parents = concept.parents;
final children = concept.children;

// Checking if an attribute is required
final isRequired = concept.getAttribute("email")?.required ?? false;
```

This runtime introspection enables powerful features like automatic validation, serialization, and UI generation.

## Validation and Business Rules

EDNet entities support rich validation capabilities:

```dart
// Pre and post validation hooks
entity.pre = true;  // Enable validation before changes
entity.post = true; // Enable validation after changes

// Validation exceptions are collected
if (!entity.exceptions.isEmpty) {
  // Handle validation errors
}
```

Combined with policy enforcement, this ensures domain rules are always maintained:

```dart
// Evaluating policies on an entity
final policyResult = entity.evaluatePolicies();
if (!policyResult.success) {
  // Handle policy violations
}
```

## Serialization Support

Entities include built-in serialization capabilities:

```dart
// Converting to/from JSON
final json = entity.toJson();
entity.fromJson(jsonString);

// Graph representation for more complex structures
final graph = entity.toGraph();
```

This makes it easy to persist entities to databases or transmit them over networks.

## Advanced Usage: The Builder Pattern

EDNet Core supports the builder pattern for creating entities with fluent interfaces:

```dart
final product = Product()
  ..setAttribute("name", "Premium Widget")
  ..setAttribute("price", 299.99)
  ..setAttribute("inStock", true)
  ..setParent("category", widgetCategory);
```

This approach creates more readable code when setting up complex entities.

## Entity vs. Value Object

Unlike Value Objects (which EDNet Core also supports), Entities are distinguished by having identity and mutable state:

```dart
// Entity equality is based on identity
final sameEntity = entity1 == entity2; // Compares OIDs

// Content equality checks actual attribute values
final sameContent = entity1.equalContent(entity2);
```

This distinction is crucial for domain modeling where some objects maintain identity through changes (Entities) while others are immutable and interchangeable (Value Objects).

## Integration with the Repository Pattern

Entities work seamlessly with EDNet's Repository pattern:

```dart
// Working with a repository
final repository = ProductRepository(session);
repository.save(product);

// Finding entities via repository
final allProducts = repository.getAll();
final activeProducts = repository.query()
  .where((p) => p.getAttribute("status") == "active")
  .toList();
```

## Conclusion

The Entity pattern in EDNet Core provides a robust foundation for domain modeling in Dart. By combining rich identity management, attribute handling, relationship mapping, and meta-model awareness, it enables developers to build expressive, maintainable domain models.

In the next article in this series, we'll explore the Entities class, which provides collection management for domain entities with rich querying and relationship maintenance capabilities.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*

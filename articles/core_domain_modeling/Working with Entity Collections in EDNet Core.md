# Working with Entity Collections in EDNet Core

Most domain models involve working with collections of entities, whether managing a product catalog, tracking order lines, or handling customer records. EDNet Core provides a powerful `Entities<E>` class that goes beyond simple collections, offering rich querying, validation, and relationship management capabilities specifically designed for domain modeling.

## Beyond Standard Collections

While Dart's standard collections (`List`, `Set`, `Map`) serve many purposes well, domain modeling requires additional capabilities:

- Enforcing domain constraints on collection operations
- Validating entities before they're added to collections
- Managing parent-child relationships
- Maintaining references for efficient lookup
- Supporting business operations on collections

The `Entities<E>` class in EDNet Core addresses these needs, providing a robust foundation for working with collections of domain objects.

## The Entities Class

`Entities<E>` is a generic class that manages collections of entities of type `E`, where `E` extends `Entity<E>`. This self-referential type pattern ensures that operations on the collection maintain proper typing throughout your domain model:

```dart
class Entities<E extends Entity<E>> implements IEntities<E> {
  Concept? _concept;
  var _entityList = <E>[];
  final _oidEntityMap = <int, E>{};
  final _codeEntityMap = <String, E>{};
  final _idEntityMap = <String, E>{};
  
  // More implementation...
}
```

The class maintains several internal maps for efficient entity lookup:
- `_oidEntityMap`: Maps OID timestamps to entities for fast lookup by identity
- `_codeEntityMap`: Maps entity codes to entities for lookup by code
- `_idEntityMap`: Maps entity IDs to entities for business identifier lookups

## Collection Fundamentals

At its core, `Entities<E>` implements `Iterable<E>`, providing all the familiar collection operations:

```dart
// Creating an Entities collection
final products = Entities<Product>();
products.concept = productConcept;

// Adding items
products.add(newProduct);

// Removing items
products.remove(obsoleteProduct);

// Iterating
for (var product in products) {
  print(product.name);
}

// Standard operations
final count = products.length;
final isEmpty = products.isEmpty;
final first = products.first;
```

But `Entities<E>` goes far beyond these basics to provide domain-specific operations.

## Domain Validation

When adding entities to a collection, `Entities<E>` performs domain validation before accepting the entity, maintaining the integrity of your domain model:

```dart
bool add(E entity) {
  bool added = false;
  if (isValid(entity)) {  // Validation happens here
    // Add to collection
    // ...
    added = true;
  }
  return added;
}
```

This validation includes:

1. **Cardinality constraints**: Ensuring the collection doesn't exceed maximum size
   ```dart
   // Setting max cardinality
   orderLines.maxC = '10';  // Max 10 line items per order
   ```

2. **Required attributes**: Checking that all required attributes are set
   ```dart
   // Validation fails if required fields are missing
   product.name = null;  // If name is required, adding fails
   ```

3. **Type validation**: Ensuring attribute values match their defined types
   ```dart
   // Automatic type checking based on concept definition
   product.price = "not a price";  // Fails if price is defined as numeric
   ```

4. **Unique identifiers**: Ensuring there are no duplicate IDs within the collection
   ```dart
   // Automatically prevents duplicate identifiers
   products.add(existingProduct);  // Fails if ID already exists
   ```

## Rich Query Capabilities

`Entities<E>` provides numerous methods for querying and filtering collections:

```dart
// Finding by OID
final productById = products.singleWhereOid(productOid);

// Finding by code
final productByCode = products.singleWhereCode('PROD-123');

// Finding by ID
final productById = products.singleWhereId(productId);

// Finding by attribute
final featuredProducts = products.selectWhereAttribute('featured', true);

// Finding by parent
final customerOrders = orders.selectWhereParent('customer', customer);

// Custom predicates
final expensiveProducts = products.selectWhere((p) => p.price > 1000);

// Paging
final firstTenProducts = products.takeFirst(10);
final nextTenProducts = products.skipFirst(10).takeFirst(10);
```

These operations return new `Entities<E>` collections, allowing for method chaining and composable queries.

## Relationship Management

One of the most powerful features of `Entities<E>` is its support for relationship management, enabling domain-driven relationships to be maintained with integrity:

```dart
// Setting up a parent-child relationship
order.setChild('lineItems', lineItems);

// Adding an entity to a child collection
var lineItems = order.getChild('lineItems') as Entities<OrderLine>;
lineItems.add(newOrderLine);

// Automatically set bi-directional references
newOrderLine.setParent('order', order);
```

The system enforces relationship constraints defined in the meta-model:
- Required parent references
- Internal vs. external relationships
- Cascading operations (e.g., deletion)

## Collection Integration and Synchronization

`Entities<E>` provides methods for integrating and synchronizing with other collections:

```dart
// Adding all entities from another collection
baseProducts.addFrom(newProducts);

// Removing all entities from another collection
activeProducts.removeFrom(discontinuedProducts);

// Updating attributes from another collection
products.setAttributesFrom(updatedProducts);

// Full integration (add, remove, update)
inventory.integrate(updatedInventory);

// Selective integration
inventory.integrateAdd(newItems);
inventory.integrateRemove(deletedItems);
inventory.integrateSet(modifiedItems);
```

These operations are particularly useful when synchronizing with external systems or handling batch updates.

## Ordered Collections

Domain models often require ordered collections, which `Entities<E>` supports through sorting and ordering operations:

```dart
// Sorting in place
products.sort((a, b) => a.name.compareTo(b.name));

// Creating a new sorted collection
var sortedProducts = products.order((a, b) => a.price.compareTo(b.price));
```

## Serialization Support

`Entities<E>` provides built-in serialization capabilities, making it easy to persist or transmit collections:

```dart
// Converting to JSON
final json = products.toJson();

// Loading from JSON
var newProducts = Entities<Product>();
newProducts.concept = productConcept;
newProducts.fromJson(jsonString);

// Graph representation for complex structures
final graph = products.toGraph();
```

## Practical Example: Order Management

Let's see how these capabilities come together in a more complete example for an order management system:

```dart
// Domain model setup
var model = Model(Domain('ECommerce'), 'OrderModel');

// Define concepts
var orderConcept = Concept(model, 'Order');
orderConcept.entry = true;
// ... additional concept setup ...

var orderLineConcept = Concept(model, 'OrderLine');
var orderParent = Parent('order', orderLineConcept);
orderParent.destinationConcept = orderConcept;
orderParent.internal = true;
orderParent.required = true;
orderLineConcept.parents.add(orderParent);

var quantityAttr = Attribute('quantity', orderLineConcept);
quantityAttr.type = model.domain.types.getTypeByCode('int');
quantityAttr.required = true;
orderLineConcept.attributes.add(quantityAttr);

// Implementation
class Order extends Entity<Order> {
  Entities<OrderLine> get lines => 
      getChild('lines') as Entities<OrderLine>;
      
  double calculateTotal() {
    return lines.fold<double>(
      0, 
      (sum, line) => sum + line.calculateAmount()
    );
  }
  
  void addProduct(Product product, int quantity) {
    var line = OrderLine();
    line.concept = orderLineConcept;
    line.setParent('order', this);
    line.setParent('product', product);
    line.quantity = quantity;
    
    // The line item is automatically added to the order's lines collection
    // due to the internal parent-child relationship
  }
  
  void applyDiscount(double percentage) {
    for (var line in lines) {
      line.applyDiscount(percentage);
    }
  }
}

// Using the domain model
var order = Order();
order.concept = orderConcept;

// Add products to order
order.addProduct(keyboard, 1);
order.addProduct(mouse, 2);

// Apply discount to order
order.applyDiscount(0.1);  // 10% discount

// Calculate order total
print('Order total: \$${order.calculateTotal()}');

// Query order lines
var highQuantityItems = order.lines.selectWhere((line) => line.quantity > 1);
print('Items with quantity > 1: ${highQuantityItems.length}');
```

## Advanced Features: Collection Policies

EDNet Core allows you to define and enforce policies at the collection level:

```dart
// Define a collection policy
class OrderLinesPolicy implements IPolicy {
  @override
  String get name => 'OrderLinesPolicy';
  
  @override
  String get description => 'Order must have at least one line item';
  
  @override
  bool evaluate(Entity entity) {
    if (entity is Order) {
      return entity.lines.isNotEmpty;
    }
    return true;
  }
  
  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    bool result = evaluate(entity);
    return PolicyEvaluationResult(
      result,
      result 
        ? [] 
        : [PolicyViolation(name, 'Order must have at least one line item')]
    );
  }
}

// Register the policy
model.registerPolicy('OrderLinesPolicy', OrderLinesPolicy());
```

## Performance Considerations

The `Entities<E>` class is optimized for domain operations, maintaining multiple indexes for efficient retrieval. However, there are some performance considerations to keep in mind:

1. **Collection Size**: While efficient for typical domain collections, very large collections (thousands of items) may benefit from specialized data structures.

2. **Query Patterns**: If you frequently query by specific attributes that aren't part of the standard indexes, consider implementing custom indexes.

3. **Memory Usage**: The multiple index maps increase memory usage. For memory-constrained environments, consider lazy loading strategies.

## Conclusion

The `Entities<E>` class in EDNet Core provides a comprehensive solution for working with collections in domain models. Going far beyond standard collections, it offers rich querying, validation, and relationship management capabilities that make it possible to express complex domain logic in a clean, maintainable way.

By leveraging this powerful abstraction, you can build domain models that not only capture the static structure of your domain but also the dynamic behaviors that operate on collections of entities.

In the next article, we'll explore how EDNet Core implements the Aggregate Root pattern to enforce domain boundaries and maintain consistency through events and commands.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 
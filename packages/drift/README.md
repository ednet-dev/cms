# EDNet Drift CQRS

A powerful, type-safe integration of EDNet Core domain models with Drift database through a CQRS architecture.

## Overview

EDNet Drift CQRS bridges the gap between your domain model and the Drift database persistence layer, providing:

- Full CQRS (Command Query Responsibility Segregation) capabilities
- Type-safe, composable query expressions
- Efficient translation of domain queries to SQL
- Support for complex filtering, relationship traversal, and pagination
- Clean, fluent API for constructing queries

This package makes it easy to build domain-driven applications with robust data access while maintaining clean separation between your domain logic and database concerns.

## Installation

```yaml
dependencies:
  ednet_core: ^1.0.0
  ednet_drift: ^1.0.0
  drift: ^2.0.0
```

## Getting Started

### 1. Define Your Domain Model

Using EDNet Core, define your domain concepts, attributes, and relationships:

```dart
final domain = Domain('MyDomain');
final productConcept = Concept(domain.model, 'Product');

// Add attributes
productConcept.attributes.add(Attribute()
  ..code = 'name'
  ..type = StringType());
  
productConcept.attributes.add(Attribute()
  ..code = 'price'
  ..type = DoubleType());

// Add to domain
domain.model.concepts.add(productConcept);
```

### 2. Create a Repository

```dart
// Initialize the Drift database
final db = EDNetDriftDatabase(domain, NativeDatabase(File('db.sqlite')));

// Create a repository
final repository = EDNetDriftCqrsRepository(
  domain: domain,
  sqlitePath: 'db.sqlite',
);
```

### 3. Query Your Domain Entities

#### Using the Query Builder

```dart
final result = await repository.queryWhere('Product', (builder) {
  builder.where('price').lessThan(100)
    .and('category').equals('electronics')
    .orderBy('name')
    .paginate(1, 20);
});

if (result.isSuccess) {
  for (final product in result.data!) {
    print('${product.getAttribute('name')}: \$${product.getAttribute('price')}');
  }
}
```

#### Using Expression Queries Directly

```dart
final priceExpression = AttributeExpression('price', ComparisonOperator.lessThan, 100);
final query = ExpressionQuery('FindAffordableProducts', productConcept, priceExpression);
final result = await repository.forConcept('Product').executeExpressionQuery(query);
```

#### Using Relationship Traversal

```dart
final productRepo = repository.forConcept('Product');
final result = await productRepo.findWhere((builder) {
  builder.whereRelated('category', RelationshipType.parent)
    .where('name').equals('Electronics')
    .end()
    .and('price').lessThan(100);
});
```

## Key Concepts

### Query Expressions

The heart of the query system is the `QueryExpression` class hierarchy:

- `AttributeExpression`: Filter by attribute values
- `RelationshipExpression`: Traverse and filter by relationships
- `LogicalExpression`: Combine expressions with AND/OR
- `NotExpression`: Negate expressions
- `FunctionExpression`: Apply functions to attributes
- `ConstantExpression`: Always evaluate to a fixed value

Expressions can be composed to create complex queries:

```dart
final expression = AttributeExpression('price', ComparisonOperator.lessThan, 100)
  .and(RelationshipExpression(
    'category',
    RelationshipType.parent,
    AttributeExpression('name', ComparisonOperator.equals, 'Electronics')
  ));
```

### Query Builder

For more readable queries, use the fluent `QueryBuilder`:

```dart
final query = QueryBuilder.forConcept(productConcept, 'FindProducts')
  .where('price').lessThan(100)
  .andWhere('category', RelationshipType.parent)
    .where('name').equals('Electronics')
  .end()
  .orderBy('name')
  .paginate(1, 20)
  .build();
```

### Drift Adapters

The integration between EDNet Core and Drift is handled by adapter classes:

- `DriftExpressionQueryAdapter`: Translates expressions to SQL
- `DriftCommandAdapter`: Translates commands to SQL operations
- `DriftQueryHandler`: Routes queries to the appropriate handler

These adapters work together to provide seamless integration between your domain model and the database.

## Advanced Usage

### Implementing Custom Query Handlers

You can implement custom query handlers for specific query types:

```dart
class FindFeaturedProductsQuery extends Query {
  FindFeaturedProductsQuery() : super('FindFeaturedProducts', conceptCode: 'Product');
}

class FeaturedProductsHandler implements IQueryHandler<FindFeaturedProductsQuery, EntityQueryResult<Product>> {
  final Repository<Product> _repository;
  
  FeaturedProductsHandler(this._repository);
  
  @override
  Future<EntityQueryResult<Product>> handle(FindFeaturedProductsQuery query) async {
    // Custom implementation...
  }
}

// Register the handler
dispatcher.registerHandler<FindFeaturedProductsQuery, EntityQueryResult<Product>>(
  FeaturedProductsHandler(repository)
);
```

### Transactions

Execute multiple operations in a transaction:

```dart
await repository.runInTransaction(() async {
  await productRepo.save(product1);
  await productRepo.save(product2);
  await categoryRepo.delete(oldCategory);
});
```

## Best Practices

1. **Use Concept-Specific Repositories**: Create repositories for each concept to leverage type safety.

2. **Prefer the Query Builder**: Use the fluent API when possible for readable code.

3. **Keep Queries Focused**: Create specific query classes for complex or reusable queries.

4. **Validate Inputs**: Always validate user inputs before constructing expressions.

5. **Handle Pagination**: Use pagination for large result sets to improve performance.

## Troubleshooting

### Common Issues

- **Query Not Returning Expected Results**: Check that attribute names match exactly with concept definitions.

- **Type Conversion Errors**: Ensure attribute types in the domain model match database column types.

- **Performance Issues**: Add appropriate indexes for frequently queried fields.

## Contributing

Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## Maintainer introduction

 Domain-Driven Query Architecture for EDNet Drift Integration

 This document explains the semantic roles of components in the
 EDNet Drift integration and how they fit together to provide
 a comprehensive query system that translates domain concepts
 to database operations.

### Architectural Overview

 The integration follows a layered architecture:

 1. Domain Layer (EDNet Core)
    - Entity and concept definitions
    - Query interfaces and expressions
    - Command interfaces

 2. Application Layer
    - Query handlers
    - Command handlers
    - Query dispatcher

 3. Persistence Layer (Drift)
    - Query adapters
    - Command adapters
    - Repository implementation

### Key Components and Their Semantic Roles

## Expression System

 The expression system is the foundation of the query capabilities.
 It provides a type-safe, composable way to express complex queries
 that can be evaluated against in-memory entities or translated to SQL.

 [QueryExpression]: Base class for all expressions
 [AttributeExpression]: Filters by attribute values
 [RelationshipExpression]: Traverses and filters by relationships
 [LogicalExpression]: Combines expressions with AND/OR
 [NotExpression]: Negates expressions
 [FunctionExpression]: Applies functions to attributes

## Query Builder Component

 The query builder provides a fluent API for constructing queries
 without directly working with expression objects. It helps developers
 write clean, readable code while still leveraging the full power of
 the expression system.

 [QueryBuilder]: Main builder class
 [AttributeFilterBuilder]: Builds attribute filters
 [RelationshipBuilder]: Builds relationship traversals

## Query Adapters

 Adapters translate domain queries and expressions to SQL operations.
 They bridge the gap between the domain model and the database.

 [DriftQueryAdapter]: Base adapter for simple queries
 [DriftExpressionQueryAdapter]: Adapter for expression queries
 [RestQueryAdapter]: Adapter for REST API parameters

## Command Adapters

 Command adapters translate domain commands to SQL operations.
 They handle create, update, and delete operations.

 [DriftCommandAdapter]: Translates commands to SQL

## Repository Extensions

 Extensions that add CQRS capabilities to the standard repository.
 They provide a clean API for domain-focused querying.

 [EDNetDriftCqrsRepository]: CQRS-enabled repository
 [DriftQueryRepository]: Concept-specific query repository

## Query Flow

 1. Client code constructs a query using the builder or expressions
 2. Query is passed to a repository or dispatcher
 3. Repository routes the query to the appropriate handler
 4. Handler uses adapters to translate the query to SQL
 5. Adapter executes the SQL and maps results to domain entities
 6. Handler returns the results to the client

## Command Flow

 1. Client code constructs a command
 2. Command is passed to a repository or dispatcher
 3. Repository routes the command to the appropriate handler
 4. Handler uses adapters to translate the command to SQL
 5. Adapter executes the SQL in a transaction
 6. Handler returns the result to the client

## Extending the System

 To add new query capabilities:

 1. Define new expression types if needed
 2. Extend the query builder to support new expressions
 3. Update adapters to translate new expressions to SQL
 4. Add convenience methods to repositories

## Maintaining the System

 When updating the system, consider:

- Backward compatibility with existing queries
- Performance implications of new features
- Type safety and validation
- Documentation and examples for new features

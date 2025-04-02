# EDNet Core Unified Query System

This document explains the unified query system in EDNet Core, which merges the previously separate query capabilities from the application services and the model/queries domains.

## Overview

The unified query system provides a consistent approach to querying data in EDNet Core applications. It combines the strengths of:

- The model layer's rich query expressions and concept-specific queries
- The application layer's validation and business logic integration

## Key Components

### 1. Query Types

The system supports multiple query types:

- **Basic Query**: A simple named query with parameters (`model.Query`)
- **Concept Query**: A query targeting a specific concept with validation (`model.ConceptQuery`)
- **Expression Query**: A powerful query using the expression system (`model.ExpressionQuery`)

### 2. Query Dispatcher

The unified `QueryDispatcher` serves as the central hub for query execution:

- Dispatches queries based on type, name, or concept
- Maintains a registry of query handlers
- Supports dynamic query creation and execution

### 3. Application Services

Application services provide convenient methods for query execution:

- `executeQuery<Q, R>()`: Execute a typed query
- `executeQueryByName()`: Execute a query by name
- `executeConceptQuery()`: Execute a concept-specific query
- `executeExpressionQuery()`: Execute an expression-based query

## Usage Examples

### Basic Query

```dart
// Define a query
class FindTasksByStatusQuery extends Query {
  final String status;

  FindTasksByStatusQuery(this.status) : super('FindTasksByStatus');

  @override
  Map<String, dynamic> getParameters() => {'status': status};
}

// Register a handler
queryDispatcher.registerHandler<FindTasksByStatusQuery, QueryResult>(handler);

// Execute via application service
final result = await taskService.executeQuery(FindTasksByStatusQuery('active'));
```

### Concept Query

```dart
// Execute directly via concept service
final result = await taskService.executeConceptQuery(
  'FindByStatus',
  {'status': 'active'},
);
```

### Expression Query

```dart
// Create an expression
final expression = AttributeExpression('status', 'active', ComparisonOperator.equals);

// Execute via concept service
final result = await taskService.executeExpressionQuery(
  'FindActive',
  expression,
  pagination: {'page': 1, 'pageSize': 20},
  sorting: {'sortBy': 'dueDate', 'sortDirection': 'asc'},
);
```

## Migration Guide

To migrate existing code to the unified query system:

1. **Application Layer Queries**:
   - Update existing `Query` classes to extend `model.Query`
   - Move query-specific logic to dedicated handlers

2. **Custom Query Handlers**:
   - Implement `model.IQueryHandler<Q, R>` for your handlers
   - Register handlers with the unified `QueryDispatcher`

3. **Application Services**:
   - Use the unified `executeQuery` methods
   - Replace custom query implementations with standard patterns

## Best Practices

1. **Choose the Right Query Type**:
   - Basic queries for simple operations
   - Concept queries for concept-specific operations with validation
   - Expression queries for complex filtering and traversal

2. **Separate Query Handlers**:
   - Implement dedicated classes for complex query handling
   - Register handlers with the dispatcher for reuse

3. **Consider Performance**:
   - Use pagination for large result sets
   - Leverage expression optimizations for complex queries
   - Implement caching for frequently executed queries

## Architecture

The unified query system follows these architectural principles:

- **Single Responsibility**: Each component has a clear purpose
- **Open/Closed**: Extensible for new query types and handlers
- **Dependency Inversion**: High-level modules depend on abstractions
- **CQRS**: Clear separation of command and query responsibilities

## Further Reading

- See the `QueryDispatcher` class for implementation details
- Explore the `ExpressionQuery` system for advanced query capabilities
- Review the `ConceptApplicationService` for concept-specific query patterns 
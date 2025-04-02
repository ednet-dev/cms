# EDNet Core Drift Query Integration

This document explains how the EDNet Core unified query system integrates with Drift/SQLite repositories.

## Overview

The Drift query integration provides a bridge between the EDNet Core unified query system and Drift/SQLite databases. It enables you to:

1. Execute standard EDNet queries against Drift repositories
2. Use Drift-specific features like raw SQL and JOINs
3. Handle both static typed tables and dynamic concept tables
4. Take advantage of SQLite's performance and features

## Getting Started

To use the Drift query integration, you need to:

1. Add the `ednet_core` and `drift` packages to your dependencies
2. Create a domain model with your concepts
3. Set up a query dispatcher
4. Initialize the EDNetDriftRepository with the query dispatcher
5. Register query handlers for your concepts

Here's a basic example:

```dart
// Create a domain model
final domain = Domain('MyDomain');
// ... add concepts to the domain

// Create a query dispatcher
final queryDispatcher = QueryDispatcher();

// Create the Drift repository
final repository = EDNetDriftRepository(
  domain: domain,
  sqlitePath: 'my_database.db',
  queryDispatcher: queryDispatcher,
);

// Ensure the database is open
await repository.open();
```

## Query Types

The integration supports several types of queries:

### 1. Standard Concept Queries

Using the standard EDNet Core concept queries:

```dart
// Execute a concept query
final result = await repository.executeConceptQuery(
  'Users',
  'FindByStatus',
  {'status': 'active'},
);

// Using the query dispatcher directly
final query = ConceptQuery('FindByStatus', usersConcept)
  .withParameter('status', 'active');
final result = await queryDispatcher.dispatch(query);
```

### 2. Drift-Specific Queries

For more advanced scenarios using Drift/SQLite features:

```dart
// Create a Drift query with raw SQL
final driftQuery = repository.createDriftQuery(
  'FindRecentUsers',
  'Users',
  rawSql: 'created_at > ? AND status = ?',
  sqlVariables: [
    Variable(DateTime.now().subtract(Duration(days: 30))),
    Variable('active'),
  ],
);

// Execute the query
final result = await repository.executeQuery(driftQuery);
```

### 3. Queries with JOINs

For queries that need to join multiple tables:

```dart
// Create a query with a JOIN
final joinQuery = DriftQuery(
  'FindUsersWithPosts',
  conceptCode: 'Users',
  joins: [
    'LEFT JOIN posts ON users.id = posts.user_id',
  ],
  rawSql: 'posts.id IS NOT NULL',
);

// Execute the query
final result = await repository.executeQuery(joinQuery);
```

## Working with Static vs. Dynamic Tables

The Drift integration handles both static typed tables and dynamic concept tables:

### Static Tables

Static tables have a fixed schema that is known at compile time. They are typically defined as Drift table classes:

```dart
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  BoolColumn get isAdmin => boolean().named('is_admin').withDefault(const Constant(false))();
}
```

When using static tables with the query system, you need to:

1. Mark your concepts as static: `concept.isStatic = true`
2. Provide a mapping function from database rows to entity objects

### Dynamic Tables

Dynamic tables are created at runtime based on concept definitions. The schema is determined by the concept's attributes:

```dart
final postConcept = Concept('Post')
  ..addAttribute(StringAttribute('id')..isPrimaryKey = true)
  ..addAttribute(StringAttribute('title'))
  ..addAttribute(StringAttribute('content'));
```

Dynamic tables are automatically handled by the Drift integration, with tables and columns created based on the concept definitions.

## Pagination and Sorting

The integration supports standard pagination and sorting:

```dart
// Create a paginated query
final query = ConceptQuery('FindAllPosts', postConcept)
  .withPagination(page: 1, pageSize: 10)
  .withSorting('createdAt', ascending: false);

// Execute the query
final result = await repository.executeQuery(query);

// Access pagination metadata
if (result.isPaginated) {
  print('Showing ${result.data.length} of ${result.totalCount} posts');
  print('Page ${result.metadata['page']} of ${(result.totalCount / result.metadata['pageSize']).ceil()}');
}
```

## Query Handlers

The `DriftQueryHandler` class handles the execution of queries against the Drift database. It translates EDNet queries into appropriate Drift/SQL queries.

For most use cases, the built-in handlers registered by the repository will be sufficient. However, you can create custom handlers for specific needs:

```dart
// Custom handler for a specific query type
final customHandler = DriftQueryHandler<User, FindUsersByNameQuery, EntityQueryResult<User>>(
  repository: repository,
  tableName: 'users',
  isStatic: true,
  concept: usersConcept,
  mapToEntity: (row) => User.fromJson(row),
  buildWhereExpression: (query) => UsersTable.name.like('%${query.namePattern}%'),
);

// Register the handler
queryDispatcher.registerHandler<FindUsersByNameQuery, EntityQueryResult<User>>(customHandler);
```

## Performance Considerations

When using the Drift integration, consider the following performance tips:

1. **Use static tables** for frequently accessed, performance-critical data
2. **Use raw SQL** for complex queries that need maximum performance
3. **Enable SQL tracing** during development to identify slow queries
4. **Use indexes** on columns that are frequently used in WHERE clauses
5. **Use pagination** for large result sets
6. **Limit JOINs** to maintain good performance with complex queries

## Integration with Existing Code

If you're migrating from a custom query solution to the unified system, you can gradually adapt your code:

1. Add the query dispatcher to your existing repository
2. Register handlers for your most important queries
3. Update your application code to use the new query methods
4. Eventually migrate all query code to the unified system

## Example

For a complete example, see the `drift_query_example.dart` file in the examples directory:

```bash
dart run packages/drift/example/drift_query_example.dart
```

## Need Help?

If you encounter any issues or have questions about the Drift query integration, please:

1. Check the API documentation for detailed information
2. Look at the example code for usage patterns
3. Refer to the EDNet Core unified query system documentation for general concepts 
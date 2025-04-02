# Unified Query System Migration Guide

This guide provides detailed instructions for migrating from the previous separate query systems to the new unified query system in EDNet Core.

## Overview

The unified query system combines the previously separate query capabilities from:
1. The application layer (`ApplicationService.executeQuery()`, etc.)
2. The model layer (`model.Query`, `QueryDispatcher`, etc.)

By unifying these systems, we've simplified the query architecture, eliminated inconsistencies, and provided a more powerful and flexible approach to querying data.

## Step 1: Update Query Dispatcher Usage

If you're currently using the query dispatcher directly in your code:

### Before:

```dart
// Model layer version
final modelDispatcher = model.QueryDispatcher();
modelDispatcher.registerHandler<MyModelQuery, model.QueryResult>(myModelHandler);
final result = await modelDispatcher.dispatch(myModelQuery);

// Application layer version
final appDispatcher = QueryDispatcher();
appDispatcher.registerHandler<MyAppQuery, QueryResult>(myAppHandler);
final result = await appDispatcher.dispatch(myAppQuery);
```

### After:

```dart
// Unified approach
final queryDispatcher = QueryDispatcher();

// Register handlers using appropriate methods
queryDispatcher.registerHandler<MyQuery, QueryResult>(myQueryHandler);
queryDispatcher.registerConceptHandler<ConceptQuery, EntityQueryResult>(
  'MyConcept',
  'MyQueryName',
  myConceptHandler,
);
queryDispatcher.registerNamedHandler<Query, QueryResult>(
  'MyQueryName',
  myNamedHandler,
);

// Dispatch queries
final result = await queryDispatcher.dispatch(myQuery);
```

## Step 2: Update Query Classes

Update your custom query classes to use the unified system:

### Before:

```dart
// Application layer query
class MyAppQuery extends Query {
  final String filter;
  
  MyAppQuery(this.filter) : super('MyQuery');
  
  @override
  Map<String, dynamic> getParameters() => {'filter': filter};
}

// Model layer query
class MyModelQuery extends model.Query {
  final String filter;
  
  MyModelQuery(this.filter) : super('MyQuery');
  
  @override
  Map<String, dynamic> getParameters() => {'filter': filter};
}
```

### After:

```dart
// Unified query - extends model.Query directly or via app.Query
class MyQuery extends Query {
  final String filter;
  
  MyQuery(this.filter) : super('MyQuery', conceptCode: 'MyConcept');
  
  @override
  Map<String, dynamic> getParameters() => {'filter': filter};
  
  @override
  bool validate() => filter.isNotEmpty;
}
```

## Step 3: Update Query Handlers

Update your query handlers to work with the unified system:

### Before:

```dart
// Application layer handler
class MyAppQueryHandler implements IQueryHandler<MyAppQuery, QueryResult> {
  @override
  Future<QueryResult> handle(MyAppQuery query) async {
    // Handler implementation
  }
}

// Model layer handler
class MyModelQueryHandler implements model.IQueryHandler<MyModelQuery, model.QueryResult> {
  @override
  Future<model.QueryResult> handle(MyModelQuery query) async {
    // Handler implementation
  }
}
```

### After:

```dart
// Option 1: Use the new ApplicationQueryHandler base class
class MyQueryHandler extends ApplicationQueryHandler<MyQuery, QueryResult> {
  @override
  Future<QueryResult> processQuery(MyQuery query) async {
    // Core handler logic
  }
  
  @override
  bool validateQuery(MyQuery query) {
    // Optional custom validation
    return super.validateQuery(query) && query.filter.length > 3;
  }
}

// Option 2: Use the RepositoryQueryHandler for common cases
final handler = RepositoryQueryHandler<MyEntity, MyQuery, EntityQueryResult<MyEntity>>(
  repository,
  buildCriteria: (query) => FilterCriteria<MyEntity>()
    ..addCriterion(Criterion('status', query.filter)),
  concept: myConcept,
);
```

## Step 4: Update Application Service Usage

Update how you use application services for queries:

### Before:

```dart
// Custom query execution
final myAppQuery = MyAppQuery('filter');
final result = await appService.executeQuery<MyAppQuery, QueryResult>(myAppQuery);

// Concept-specific query
final conceptResult = await conceptService.executeConceptQuery(
  'FindByStatus',
  {'status': 'active'},
);
```

### After:

```dart
// Use the same executeQuery method for custom queries
final myQuery = MyQuery('filter');
final result = await appService.executeQuery<MyQuery, QueryResult>(myQuery);

// ConceptQuery remains the same 
final conceptResult = await conceptService.executeConceptQuery(
  'FindByStatus',
  {'status': 'active'},
);

// New expression query capability
final expression = AttributeExpression('status', 'active', ComparisonOperator.equals);
final expressionResult = await conceptService.executeExpressionQuery(
  'FindActiveWithExpression',
  expression,
  pagination: {'page': 1, 'pageSize': 10},
  sorting: {'sortBy': 'createdAt', 'sortDirection': 'desc'},
);

// New name-based query execution
final namedResult = await appService.executeQueryByName(
  'FindAll',
  {'includeDeleted': false},
);
```

## Step 5: Update Repository Integration

If you have custom repository implementations:

### Before:

```dart
// Two separate ways to query repositories
final appResult = await repository.findByCriteria(appCriteria);
final modelResult = await repository.findByCriteria(modelCriteria);
```

### After:

```dart
// Use the RepositoryQueryHandler for a consistent approach
final handler = RepositoryQueryHandler<MyEntity, MyQuery, EntityQueryResult<MyEntity>>(
  repository,
  concept: myConcept,
);

queryDispatcher.registerHandler<MyQuery, EntityQueryResult<MyEntity>>(handler);
```

## Best Practices for the Unified System

1. **Prefer Type Safety**: When possible, use strongly-typed queries and handlers for better error detection.

2. **Use the Right Query Type**:
   - Basic `Query` for simple parameter-based queries
   - `ConceptQuery` for concept-specific queries with validation
   - `ExpressionQuery` for complex filtering and traversal

3. **Leverage Base Classes**:
   - `ApplicationQueryHandler` for custom query handling logic
   - `RepositoryQueryHandler` for common repository query patterns

4. **Register Handlers Appropriately**:
   - `registerHandler<Q, R>()` for type-based handler registration
   - `registerConceptHandler()` for concept-specific handlers
   - `registerNamedHandler()` for name-based handlers

5. **Application Service Methods**:
   - `executeQuery<Q, R>()` for executing typed queries
   - `executeQueryByName()` for name-based query execution
   - `executeConceptQuery()` for concept-specific queries
   - `executeExpressionQuery()` for expression-based queries

## Troubleshooting

### Query Not Being Dispatched

If your query isn't being dispatched to the correct handler, check:

1. Query registration: Ensure you've registered the handler with the correct type, concept, or name
2. Query parameters: Make sure your query includes the right conceptCode if using concept handlers
3. Dispatcher configuration: Verify the application service is using the correct dispatcher

### Type Errors

If you're seeing type errors:

1. Check generic type parameters in handler registrations
2. Ensure your query class properly extends the correct base class
3. Verify your handler implements the right interface

### Query Results Not as Expected

If query results aren't what you expect:

1. Check query validation logic
2. Verify repository criteria building
3. Review pagination and sorting parameters
4. Debug handler implementation

## Example Migration

Here's a complete example of migrating a feature from the old system to the unified approach:

### Before:

```dart
// Application layer
class FindTaskQuery extends Query {
  final String status;
  FindTaskQuery(this.status) : super('FindTask');
  @override
  Map<String, dynamic> getParameters() => {'status': status};
}

class TaskQueryHandler implements IQueryHandler<FindTaskQuery, QueryResult> {
  final Repository<Task> repository;
  TaskQueryHandler(this.repository);
  
  @override
  Future<QueryResult> handle(FindTaskQuery query) async {
    final criteria = FilterCriteria<Task>()
      ..addCriterion(Criterion('status', query.status));
    final tasks = await repository.findByCriteria(criteria);
    return QueryResult.success(tasks);
  }
}

// Using it
final dispatcher = QueryDispatcher();
dispatcher.registerHandler<FindTaskQuery, QueryResult>(TaskQueryHandler(taskRepo));
final service = ApplicationService<Task>(taskRepo, queryDispatcher: dispatcher);
final result = await service.executeQuery<FindTaskQuery, QueryResult>(FindTaskQuery('active'));
```

### After:

```dart
// Unified approach
class FindTaskQuery extends Query {
  final String status;
  FindTaskQuery(this.status) : super('FindTask', conceptCode: 'Task');
  @override
  Map<String, dynamic> getParameters() => {'status': status};
}

// Option 1: Custom handler
class TaskQueryHandler extends ApplicationQueryHandler<FindTaskQuery, EntityQueryResult<Task>> {
  final Repository<Task> repository;
  TaskQueryHandler(this.repository);
  
  @override
  Future<EntityQueryResult<Task>> processQuery(FindTaskQuery query) async {
    final criteria = FilterCriteria<Task>()
      ..addCriterion(Criterion('status', query.status));
    final tasks = await repository.findByCriteria(criteria);
    return EntityQueryResult.success(tasks, conceptCode: 'Task');
  }
}

// Option 2: Using RepositoryQueryHandler
final taskHandler = RepositoryQueryHandler<Task, FindTaskQuery, EntityQueryResult<Task>>(
  taskRepo,
  buildCriteria: (query) => FilterCriteria<Task>()
    ..addCriterion(Criterion('status', query.status)),
  concept: taskConcept,
);

// Using it
final dispatcher = QueryDispatcher();
dispatcher.registerHandler<FindTaskQuery, EntityQueryResult<Task>>(taskHandler);
final service = ApplicationService<Task>(taskRepo, queryDispatcher: dispatcher);
final result = await service.executeQuery<FindTaskQuery, EntityQueryResult<Task>>(FindTaskQuery('active'));
```

## Need Help?

If you encounter difficulties during migration:

1. Refer to the example code in `packages/core/example/unified_query_example.dart`
2. Check the test case in `packages/core/test/unified_query_system_test.dart`
3. Read the detailed documentation in `packages/core/doc/query_system.md` 
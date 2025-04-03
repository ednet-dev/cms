// import 'package:ednet_core/ednet_core.dart';
// import 'package:test/test.dart';
//
// /// Test case for the unified query system.
// ///
// /// This test verifies that:
// /// 1. The query dispatcher correctly routes queries
// /// 2. Application services can execute different query types
// /// 3. The system handles errors appropriately
// void main() {
//   late Repository<TestEntity> repository;
//   late QueryDispatcher queryDispatcher;
//   late ConceptApplicationService<TestEntity> conceptService;
//   late ApplicationService<TestEntity> basicService;
//   late Concept testConcept;
//
//   setUp(() {
//     // Create test entities
//     final entities = [
//       TestEntity('1', 'First Entity', 'active', 10),
//       TestEntity('2', 'Second Entity', 'inactive', 20),
//       TestEntity('3', 'Third Entity', 'active', 30),
//       TestEntity('4', 'Fourth Entity', 'pending', 40),
//       TestEntity('5', 'Fifth Entity', 'active', 50),
//     ];
//
//     // Set up repository
//     repository = InMemoryRepository<TestEntity>();
//     for (var entity in entities) {
//       repository.save(entity);
//     }
//
//     // Set up concept
//     testConcept = Concept('TestEntity')
//       ..addAttribute(StringAttribute('name'))
//       ..addAttribute(StringAttribute('status'))
//       ..addAttribute(IntegerAttribute('value'));
//
//     // Set up query dispatcher
//     queryDispatcher = QueryDispatcher();
//
//     // Register query handlers
//     queryDispatcher.registerHandler<FindByStatusQuery, EntityQueryResult<TestEntity>>(
//       FindByStatusHandler(repository),
//     );
//
//     queryDispatcher.registerConceptHandler<ConceptQuery, EntityQueryResult<TestEntity>>(
//       'TestEntity',
//       'FindByStatus',
//       RepositoryQueryHandler<TestEntity, ConceptQuery, EntityQueryResult<TestEntity>>(
//         repository,
//         concept: testConcept,
//       ),
//     );
//
//     queryDispatcher.registerNamedHandler<Query, QueryResult>(
//       'FindAll',
//       RepositoryQueryHandler<TestEntity, Query, QueryResult>(
//         repository,
//         concept: testConcept,
//       ),
//     );
//
//     // Set up application services
//     conceptService = ConceptApplicationService<TestEntity>(
//       repository,
//       testConcept,
//       name: 'TestConceptService',
//       queryDispatcher: queryDispatcher,
//     );
//
//     basicService = ApplicationService<TestEntity>(
//       repository,
//       name: 'TestBasicService',
//       queryDispatcher: queryDispatcher,
//     );
//   });
//
//   group('Unified Query System Tests', () {
//     test('Typed query execution', () async {
//       // Execute a typed query
//       final query = FindByStatusQuery('active');
//       final result = await basicService.executeQuery<FindByStatusQuery, EntityQueryResult<TestEntity>>(query);
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(3));
//       expect(result.data?.first.status, equals('active'));
//     });
//
//     test('Concept query execution', () async {
//       // Execute a concept query
//       final result = await conceptService.executeConceptQuery(
//         'FindByStatus',
//         {'status': 'active'},
//       );
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(3));
//       expect(result.data?.first.status, equals('active'));
//     });
//
//     test('Named query execution', () async {
//       // Execute a named query
//       final result = await basicService.executeQueryByName('FindAll');
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(5));
//     });
//
//     test('Expression query execution', () async {
//       // Create an expression query
//       final expression = AttributeExpression('status', 'active', ComparisonOperator.equals);
//
//       // Register handler for expression queries
//       queryDispatcher.registerHandler<ExpressionQuery, EntityQueryResult<TestEntity>>(
//         ExpressionQueryHandler<TestEntity>(repository, testConcept),
//       );
//
//       // Execute an expression query
//       final result = await conceptService.executeExpressionQuery(
//         'FindActiveWithExpression',
//         expression,
//       );
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(3));
//       expect(result.data?.first.status, equals('active'));
//     });
//
//     test('Query with pagination', () async {
//       // Execute a concept query with pagination
//       final result = await conceptService.executeConceptQuery(
//         'FindByStatus',
//         {
//           'status': 'active',
//           'page': 1,
//           'pageSize': 2,
//         },
//       );
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(2));
//       expect(result.isPaginated, isTrue);
//       expect(result.totalCount, equals(3));
//     });
//
//     test('Query with sorting', () async {
//       // Execute a concept query with sorting
//       final result = await conceptService.executeConceptQuery(
//         'FindByStatus',
//         {
//           'status': 'active',
//           'sortBy': 'value',
//           'sortDirection': 'desc',
//         },
//       );
//
//       // Verify result
//       expect(result.isSuccess, isTrue);
//       expect(result.data, hasLength(3));
//       expect(result.data?.first.value, equals(50));
//       expect(result.data?.last.value, equals(10));
//     });
//
//     test('Invalid query validation', () async {
//       // Create an invalid query
//       final query = InvalidQuery();
//
//       // Execute the invalid query
//       final result = await basicService.executeQuery<InvalidQuery, QueryResult>(query);
//
//       // Verify result
//       expect(result.isSuccess, isFalse);
//       expect(result.errorMessage, contains('validation failed'));
//     });
//   });
// }
//
// /// Test entity for the unified query system tests.
// class TestEntity extends AggregateRoot {
//   final String name;
//   final String status;
//   final int value;
//
//   TestEntity(String id, this.name, this.status, this.value) : super(id);
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'status': status,
//       'value': value,
//     };
//   }
//
//   @override
//   dynamic getAttribute(String name) {
//     switch (name) {
//       case 'name': return this.name;
//       case 'status': return status;
//       case 'value': return value;
//       default: return super.getAttribute(name);
//     }
//   }
// }
//
// /// Test query for finding entities by status.
// class FindByStatusQuery extends Query {
//   final String status;
//
//   FindByStatusQuery(this.status) : super('FindByStatus', conceptCode: 'TestEntity');
//
//   @override
//   Map<String, dynamic> getParameters() {
//     return {'status': status};
//   }
// }
//
// /// Handler for the FindByStatus query.
// class FindByStatusHandler implements IQueryHandler<FindByStatusQuery, EntityQueryResult<TestEntity>> {
//   final Repository<TestEntity> repository;
//
//   FindByStatusHandler(this.repository);
//
//   @override
//   Future<EntityQueryResult<TestEntity>> handle(FindByStatusQuery query) async {
//     final criteria = FilterCriteria<TestEntity>()
//       ..addCriterion(Criterion('status', query.status));
//
//     final results = await repository.findByCriteria(criteria);
//
//     return EntityQueryResult.success(
//       results,
//       conceptCode: 'TestEntity',
//     );
//   }
// }
//
// /// Invalid query for testing validation.
// class InvalidQuery extends Query {
//   InvalidQuery() : super('InvalidQuery');
//
//   @override
//   bool validate() => false;
// }
//
// /// In-memory repository implementation for testing.
// class InMemoryRepository<T extends Entity> implements Repository<T> {
//   final Map<String, T> _entities = {};
//
//   @override
//   Future<void> save(T entity) async {
//     _entities[entity.id] = entity;
//   }
//
//   @override
//   Future<T?> findById(dynamic id) async {
//     return _entities[id.toString()];
//   }
//
//   @override
//   Future<List<T>> findAll() async {
//     return _entities.values.toList();
//   }
//
//   @override
//   Future<List<T>> findByCriteria(FilterCriteria<T> criteria, {int? skip, int? take}) async {
//     var results = _entities.values.where((entity) {
//       for (var criterion in criteria.criteria) {
//         final attributeName = criterion.attribute;
//         final attributeValue = criterion.value;
//
//         // Get the attribute value from the entity
//         final entityValue = entity.getAttribute(attributeName);
//
//         // If values don't match, this entity doesn't satisfy the criteria
//         if (entityValue != attributeValue) {
//           return false;
//         }
//       }
//
//       // All criteria satisfied
//       return true;
//     }).toList();
//
//     // Apply sorting if specified
//     if (criteria.sortAttribute != null) {
//       results.sort((a, b) {
//         final aValue = a.getAttribute(criteria.sortAttribute!);
//         final bValue = b.getAttribute(criteria.sortAttribute!);
//
//         // Handle null values
//         if (aValue == null && bValue == null) return 0;
//         if (aValue == null) return criteria.sortAscending ? -1 : 1;
//         if (bValue == null) return criteria.sortAscending ? 1 : -1;
//
//         // Compare values
//         int comparison;
//         if (aValue is Comparable && bValue is Comparable) {
//           comparison = aValue.compareTo(bValue);
//         } else {
//           comparison = aValue.toString().compareTo(bValue.toString());
//         }
//
//         return criteria.sortAscending ? comparison : -comparison;
//       });
//     }
//
//     // Apply pagination
//     if (skip != null || take != null) {
//       final start = skip ?? 0;
//       final end = take != null ? start + take : results.length;
//
//       if (start < results.length) {
//         results = results.sublist(start, end > results.length ? results.length : end);
//       } else {
//         results = [];
//       }
//     }
//
//     return results;
//   }
//
//   @override
//   Future<int> countByCriteria(FilterCriteria<T> criteria) async {
//     var results = await findByCriteria(criteria);
//     return results.length;
//   }
//
//   @override
//   Future<void> delete(T entity) async {
//     _entities.remove(entity.id);
//   }
//
//   @override
//   Iterable<T> getEntities() {
//     return _entities.values;
//   }
// }
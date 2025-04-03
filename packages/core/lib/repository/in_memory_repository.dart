// part of ednet_core;
//
// /// In-memory repository implementation for testing.
// ///
// /// This repository stores entities in memory, making it useful for
// /// testing and prototyping without a real database.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// class InMemoryRepository<T extends Entity> implements Repository<T> {
//   /// Map of entities by ID.
//   final Map<String, T> _entities = {};
//
//   /// The concept this repository is for.
//   final Concept? concept;
//
//   /// Creates a new in-memory repository.
//   ///
//   /// Parameters:
//   /// - [concept]: Optional concept this repository is for
//   InMemoryRepository({this.concept});
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
//     final results = await findByCriteria(criteria);
//     return results.length;
//   }
//
//   @override
//   Future<void> save(T entity) async {
//     _entities[entity.id.toString()] = entity;
//   }
//
//   @override
//   Future<void> delete(T entity) async {
//     _entities.remove(entity.id.toString());
//   }
//
//   @override
//   Iterable<T> getEntities() {
//     return _entities.values;
//   }
//
//   /// Clears all entities from this repository.
//   ///
//   /// This is useful for resetting the repository state between tests.
//   void clear() {
//     _entities.clear();
//   }
// }
//
// /// In-memory queryable repository implementation.
// ///
// /// This repository adds query capabilities to the standard in-memory repository.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// class InMemoryQueryableRepository<T extends Entity> extends InMemoryRepository<T> implements QueryableRepository<T> {
//   /// The query dispatcher used by this repository.
//   final QueryDispatcher? _queryDispatcher;
//
//   /// Creates a new in-memory queryable repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept this repository is for
//   /// - [queryDispatcher]: Optional query dispatcher
//   InMemoryQueryableRepository({
//     required Concept concept,
//     QueryDispatcher? queryDispatcher,
//   }) : _queryDispatcher = queryDispatcher,
//        super(concept: concept) {
//     if (_queryDispatcher != null) {
//       _registerHandlers();
//     }
//   }
//
//   /// Registers query handlers with the query dispatcher.
//   void _registerHandlers() {
//     if (_queryDispatcher == null || concept == null) return;
//
//     // Register a concept query handler
//     _queryDispatcher!.registerConceptHandler<ConceptQuery, EntityQueryResult<T>>(
//       concept!.code,
//       'FindAll',
//       InMemoryQueryHandler<T, ConceptQuery, EntityQueryResult<T>>(
//         this,
//         concept!,
//       ),
//     );
//   }
//
//   @override
//   Future<IQueryResult> executeQuery(IQuery query) async {
//     if (_queryDispatcher != null) {
//       return _queryDispatcher!.dispatch(query);
//     } else {
//       // Handle the query directly if no dispatcher is available
//       if (query is ConceptQuery && query.conceptCode == concept?.code) {
//         return executeConceptQuery(query.name, query.getParameters());
//       } else {
//         return QueryResult.failure('No query dispatcher available and cannot handle query directly');
//       }
//     }
//   }
//
//   @override
//   Future<IQueryResult> executeConceptQuery(String queryName, [Map<String, dynamic>? parameters]) async {
//     if (concept == null) {
//       return QueryResult.failure('No concept associated with this repository');
//     }
//
//     try {
//       final query = ConceptQuery(queryName, concept!);
//       if (parameters != null) {
//         query.withParameters(parameters);
//       }
//
//       // Execute using the dispatcher if available
//       if (_queryDispatcher != null) {
//         return _queryDispatcher!.dispatch(query);
//       }
//
//       // Otherwise handle directly
//       final criteria = FilterCriteria<T>();
//
//       // Extract pagination parameters
//       final page = parameters?['page'] as int?;
//       final pageSize = parameters?['pageSize'] as int?;
//
//       // Extract sorting parameters
//       final sortBy = parameters?['sortBy'] as String?;
//       final sortDirection = parameters?['sortDirection'] as String?;
//
//       // Apply filters from parameters
//       if (parameters != null) {
//         for (final entry in parameters.entries) {
//           final key = entry.key;
//           final value = entry.value;
//
//           // Skip pagination and sorting parameters
//           if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
//             continue;
//           }
//
//           // Add criterion for this parameter
//           criteria.addCriterion(Criterion(key, value));
//         }
//       }
//
//       // Apply sorting
//       if (sortBy != null) {
//         criteria.orderBy(sortBy, ascending: sortDirection != 'desc');
//       }
//
//       // Execute the query
//       List<T> results;
//       int totalCount = 0;
//
//       if (page != null && pageSize != null) {
//         // Get paginated results
//         totalCount = await countByCriteria(criteria);
//         results = await findByCriteria(
//           criteria,
//           skip: (page - 1) * pageSize,
//           take: pageSize,
//         );
//
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//           metadata: {
//             'page': page,
//             'pageSize': pageSize,
//             'totalCount': totalCount,
//           },
//         );
//       } else {
//         // Get all results
//         results = await findByCriteria(criteria);
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//         );
//       }
//     } catch (e) {
//       return QueryResult.failure('Error executing concept query: $e');
//     }
//   }
//
//   @override
//   QueryDispatcher? getQueryDispatcher() {
//     return _queryDispatcher;
//   }
//
//   @override
//   Concept getConcept() {
//     if (concept == null) {
//       throw StateError('No concept associated with this repository');
//     }
//     return concept!;
//   }
// }
//
// /// In-memory query handler implementation.
// ///
// /// This handler works with in-memory repositories to execute queries.
// ///
// /// Type parameters:
// /// - [T]: The entity type this handler works with
// /// - [Q]: The query type this handler processes
// /// - [R]: The type of result this handler returns
// class InMemoryQueryHandler<T extends Entity, Q extends IQuery, R extends EntityQueryResult<T>> implements IQueryHandler<Q, R> {
//   /// The repository this handler queries.
//   final InMemoryRepository<T> repository;
//
//   /// The concept this handler is for.
//   final Concept concept;
//
//   /// Creates a new in-memory query handler.
//   ///
//   /// Parameters:
//   /// - [repository]: The repository to query
//   /// - [concept]: The concept this handler is for
//   InMemoryQueryHandler(this.repository, this.concept);
//
//   @override
//   Future<R> handle(Q query) async {
//     try {
//       final criteria = FilterCriteria<T>();
//       final parameters = query is Query ? query.getParameters() : <String, dynamic>{};
//
//       // Extract pagination parameters
//       final page = parameters['page'] as int?;
//       final pageSize = parameters['pageSize'] as int?;
//
//       // Extract sorting parameters
//       final sortBy = parameters['sortBy'] as String?;
//       final sortDirection = parameters['sortDirection'] as String?;
//
//       // Apply filters from parameters
//       for (final entry in parameters.entries) {
//         final key = entry.key;
//         final value = entry.value;
//
//         // Skip pagination and sorting parameters
//         if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
//           continue;
//         }
//
//         // Add criterion for this parameter
//         criteria.addCriterion(Criterion(key, value));
//       }
//
//       // Apply sorting
//       if (sortBy != null) {
//         criteria.orderBy(sortBy, ascending: sortDirection != 'desc');
//       }
//
//       // Execute the query
//       List<T> results;
//       int totalCount = 0;
//
//       if (page != null && pageSize != null) {
//         // Get paginated results
//         totalCount = await repository.countByCriteria(criteria);
//         results = await repository.findByCriteria(
//           criteria,
//           skip: (page - 1) * pageSize,
//           take: pageSize,
//         );
//
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//           metadata: {
//             'page': page,
//             'pageSize': pageSize,
//             'totalCount': totalCount,
//           },
//         ) as R;
//       } else {
//         // Get all results
//         results = await repository.findByCriteria(criteria);
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//         ) as R;
//       }
//     } catch (e) {
//       return EntityQueryResult<T>.failure(
//         'Error executing query: $e',
//         concept: concept,
//       ) as R;
//     }
//   }
// }
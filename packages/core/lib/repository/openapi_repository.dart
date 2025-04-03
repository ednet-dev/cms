// part of ednet_core;
//
// /// Repository implementation using OpenAPI.
// ///
// /// This repository provides CRUD operations on entities using
// /// OpenAPI endpoints, with support for authentication, pagination,
// /// and filtering.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// class OpenApiRepository<T extends Entity> implements Repository<T> {
//   /// The HTTP client used for API requests.
//   final HttpClient _client;
//
//   /// The base URL for API requests.
//   final String baseUrl;
//
//   /// The concept this repository is for.
//   final Concept concept;
//
//   /// The endpoint path for this entity type.
//   final String endpoint;
//
//   /// Function to map API responses to entities.
//   final T Function(Map<String, dynamic> json) _fromJson;
//
//   /// Function to map entities to API request bodies.
//   final Map<String, dynamic> Function(T entity) _toJson;
//
//   /// Creates a new OpenAPI repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept this repository is for
//   /// - [baseUrl]: The base URL for API requests
//   /// - [endpoint]: The endpoint path for this entity type (defaults to concept name in lowercase)
//   /// - [fromJson]: Function to map API responses to entities
//   /// - [toJson]: Function to map entities to API request bodies
//   /// - [client]: Optional HTTP client
//   OpenApiRepository({
//     required this.concept,
//     required this.baseUrl,
//     String? endpoint,
//     required T Function(Map<String, dynamic> json) fromJson,
//     required Map<String, dynamic> Function(T entity) toJson,
//     HttpClient? client,
//   }) : _client = client ?? HttpClient(),
//        endpoint = endpoint ?? concept.name.toLowerCase(),
//        _fromJson = fromJson,
//        _toJson = toJson;
//
//   @override
//   Future<T?> findById(dynamic id) async {
//     try {
//       final url = '$baseUrl/$endpoint/$id';
//       final response = await _client.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as Map<String, dynamic>;
//         return _fromJson(data);
//       } else if (response.statusCode == 404) {
//         return null;
//       } else {
//         throw Exception('Failed to get entity: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to get entity: $e');
//     }
//   }
//
//   @override
//   Future<List<T>> findAll() async {
//     try {
//       final url = '$baseUrl/$endpoint';
//       final response = await _client.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as List<dynamic>;
//         return data
//             .map((item) => _fromJson(item as Map<String, dynamic>))
//             .toList();
//       } else {
//         throw Exception('Failed to get all entities: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to get all entities: $e');
//     }
//   }
//
//   @override
//   Future<List<T>> findByCriteria(FilterCriteria<T> criteria, {int? skip, int? take}) async {
//     try {
//       // Build query parameters from criteria
//       final queryParams = <String, dynamic>{};
//
//       // Add filter parameters
//       for (final criterion in criteria.criteria) {
//         queryParams[criterion.attribute] = criterion.value;
//       }
//
//       // Add sorting parameters
//       if (criteria.sortAttribute != null) {
//         queryParams['sortBy'] = criteria.sortAttribute;
//         queryParams['sortDirection'] = criteria.sortAscending ? 'asc' : 'desc';
//       }
//
//       // Add pagination parameters
//       if (skip != null) {
//         queryParams['skip'] = skip.toString();
//       }
//
//       if (take != null) {
//         queryParams['take'] = take.toString();
//       }
//
//       // Build the URL
//       final uri = Uri.parse('$baseUrl/$endpoint').replace(
//         queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())),
//       );
//
//       final response = await _client.get(uri);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as List<dynamic>;
//         return data
//             .map((item) => _fromJson(item as Map<String, dynamic>))
//             .toList();
//       } else {
//         throw Exception('Failed to query entities: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to query entities: $e');
//     }
//   }
//
//   @override
//   Future<int> countByCriteria(FilterCriteria<T> criteria) async {
//     try {
//       // Build query parameters from criteria
//       final queryParams = <String, dynamic>{};
//
//       // Add filter parameters
//       for (final criterion in criteria.criteria) {
//         queryParams[criterion.attribute] = criterion.value;
//       }
//
//       // Add count parameter
//       queryParams['count'] = 'true';
//
//       // Build the URL
//       final uri = Uri.parse('$baseUrl/$endpoint/count').replace(
//         queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())),
//       );
//
//       final response = await _client.get(uri);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as Map<String, dynamic>;
//         return data['count'] as int;
//       } else {
//         throw Exception('Failed to count entities: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to count entities: $e');
//     }
//   }
//
//   @override
//   Future<void> save(T entity) async {
//     try {
//       final url = '$baseUrl/$endpoint';
//
//       // Convert entity to JSON
//       final data = _toJson(entity);
//
//       // Determine if this is an insert or update
//       final isUpdate = await findById(entity.id) != null;
//
//       final response = isUpdate
//           ? await _client.put(
//               Uri.parse('$url/${entity.id}'),
//               headers: {'Content-Type': 'application/json'},
//               body: json.encode(data),
//             )
//           : await _client.post(
//               Uri.parse(url),
//               headers: {'Content-Type': 'application/json'},
//               body: json.encode(data),
//             );
//
//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception('Failed to save entity: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to save entity: $e');
//     }
//   }
//
//   @override
//   Future<void> delete(T entity) async {
//     try {
//       final url = '$baseUrl/$endpoint/${entity.id}';
//       final response = await _client.delete(Uri.parse(url));
//
//       if (response.statusCode != 200 && response.statusCode != 204) {
//         throw Exception('Failed to delete entity: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to delete entity: $e');
//     }
//   }
//
//   @override
//   Iterable<T> getEntities() {
//     throw UnsupportedError('OpenApiRepository does not support getEntities()');
//   }
// }
//
// /// Queryable repository implementation using OpenAPI.
// ///
// /// This repository adds query capabilities to the standard OpenAPI repository.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// class OpenApiQueryableRepository<T extends Entity> extends OpenApiRepository<T> implements QueryableRepository<T> {
//   /// The query dispatcher used by this repository.
//   final QueryDispatcher? _queryDispatcher;
//
//   /// Creates a new OpenAPI queryable repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept this repository is for
//   /// - [baseUrl]: The base URL for API requests
//   /// - [endpoint]: The endpoint path for this entity type
//   /// - [fromJson]: Function to map API responses to entities
//   /// - [toJson]: Function to map entities to API request bodies
//   /// - [queryDispatcher]: Optional query dispatcher
//   /// - [client]: Optional HTTP client
//   OpenApiQueryableRepository({
//     required Concept concept,
//     required String baseUrl,
//     String? endpoint,
//     required T Function(Map<String, dynamic> json) fromJson,
//     required Map<String, dynamic> Function(T entity) toJson,
//     QueryDispatcher? queryDispatcher,
//     HttpClient? client,
//   }) : _queryDispatcher = queryDispatcher,
//        super(
//          concept: concept,
//          baseUrl: baseUrl,
//          endpoint: endpoint,
//          fromJson: fromJson,
//          toJson: toJson,
//          client: client,
//        ) {
//     if (_queryDispatcher != null) {
//       _registerHandlers();
//     }
//   }
//
//   /// Registers query handlers with the query dispatcher.
//   void _registerHandlers() {
//     if (_queryDispatcher == null) return;
//
//     // Register a concept query handler
//     _queryDispatcher!.registerConceptHandler<ConceptQuery, EntityQueryResult<T>>(
//       concept.code,
//       'FindAll',
//       OpenApiQueryHandler<T, ConceptQuery, EntityQueryResult<T>>(
//         this,
//         concept,
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
//       if (query is ConceptQuery && query.conceptCode == concept.code) {
//         return executeConceptQuery(query.name, query.getParameters());
//       } else {
//         return QueryResult.failure('No query dispatcher available and cannot handle query directly');
//       }
//     }
//   }
//
//   @override
//   Future<IQueryResult> executeConceptQuery(String queryName, [Map<String, dynamic>? parameters]) async {
//     try {
//       final query = ConceptQuery(queryName, concept);
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
//       // Calculate skip and take
//       final skip = page != null && pageSize != null ? (page - 1) * pageSize : null;
//       final take = pageSize;
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
//       final sortBy = parameters?['sortBy'] as String?;
//       final sortDirection = parameters?['sortDirection'] as String?;
//
//       if (sortBy != null) {
//         criteria.orderBy(sortBy, ascending: sortDirection != 'desc');
//       }
//
//       // Execute the query
//       List<T> results;
//       int totalCount = 0;
//
//       if (skip != null && take != null) {
//         // Get paginated results
//         totalCount = await countByCriteria(criteria);
//         results = await findByCriteria(
//           criteria,
//           skip: skip,
//           take: take,
//         );
//
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//           metadata: {
//             'page': page,
//             'pageSize': take,
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
//     return concept;
//   }
// }
//
// /// OpenAPI query handler implementation.
// ///
// /// This handler works with OpenAPI repositories to execute queries.
// ///
// /// Type parameters:
// /// - [T]: The entity type this handler works with
// /// - [Q]: The query type this handler processes
// /// - [R]: The type of result this handler returns
// class OpenApiQueryHandler<T extends Entity, Q extends IQuery, R extends EntityQueryResult<T>> implements IQueryHandler<Q, R> {
//   /// The repository this handler queries.
//   final OpenApiRepository<T> repository;
//
//   /// The concept this handler is for.
//   final Concept concept;
//
//   /// Creates a new OpenAPI query handler.
//   ///
//   /// Parameters:
//   /// - [repository]: The repository to query
//   /// - [concept]: The concept this handler is for
//   OpenApiQueryHandler(this.repository, this.concept);
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
//       // Calculate skip and take
//       final skip = page != null && pageSize != null ? (page - 1) * pageSize : null;
//       final take = pageSize;
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
//       final sortBy = parameters['sortBy'] as String?;
//       final sortDirection = parameters['sortDirection'] as String?;
//
//       if (sortBy != null) {
//         criteria.orderBy(sortBy, ascending: sortDirection != 'desc');
//       }
//
//       // Execute the query
//       List<T> results;
//       int totalCount = 0;
//
//       if (skip != null && take != null) {
//         // Get paginated results
//         totalCount = await repository.countByCriteria(criteria);
//         results = await repository.findByCriteria(
//           criteria,
//           skip: skip,
//           take: take,
//         );
//
//         return EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//           metadata: {
//             'page': page,
//             'pageSize': take,
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
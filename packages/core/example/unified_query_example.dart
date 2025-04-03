// import 'package:ednet_core/ednet_core.dart';
//
// /// Example demonstrating the unified query system in EDNet Core.
// ///
// /// This file shows how to:
// /// 1. Set up the query system components
// /// 2. Define and execute different types of queries
// /// 3. Implement and register query handlers
// void main() async {
//   // This is a simplified example to demonstrate the unified query system
//
//   // --- Setup ---
//
//   // Create a domain models registry
//   final domainModels = DomainModels('TaskManagement');
//
//   // Create a concept for Task entities
//   final taskConcept = Concept('Task')
//     ..addAttribute(StringAttribute('title'))
//     ..addAttribute(StringAttribute('status'))
//     ..addAttribute(DateTimeAttribute('dueDate'));
//
//   // Register the concept with the domain
//   domainModels.addConcept(taskConcept);
//
//   // Create a repository for Task entities
//   final taskRepository = InMemoryRepository<Task>();
//
//   // Create a query dispatcher (the unified component)
//   final queryDispatcher = QueryDispatcher();
//
//   // Create application service
//   final taskService = ConceptApplicationService<Task>(
//     taskRepository,
//     taskConcept,
//     name: 'TaskService',
//     queryDispatcher: queryDispatcher,
//   );
//
//   // --- Register query handlers ---
//
//   // Register a handler for a specific query type
//   queryDispatcher.registerHandler<FindTasksByStatusQuery, EntityQueryResult<Task>>(
//     FindTasksByStatusHandler(taskRepository),
//   );
//
//   // Register a concept query handler
//   queryDispatcher.registerConceptHandler<ConceptQuery, EntityQueryResult<Task>>(
//     'Task',
//     'FindByStatus',
//     ConceptQueryHandler<Task>(taskRepository, taskConcept),
//   );
//
//   // --- Add sample data ---
//
//   final tasks = [
//     Task('1', 'Finish report', 'active', DateTime(2023, 6, 15)),
//     Task('2', 'Review code', 'completed', DateTime(2023, 6, 10)),
//     Task('3', 'Fix bugs', 'active', DateTime(2023, 6, 20)),
//     Task('4', 'Deploy application', 'pending', DateTime(2023, 6, 30)),
//   ];
//
//   for (var task in tasks) {
//     await taskRepository.save(task);
//   }
//
//   // --- Execute queries using different approaches ---
//
//   // 1. Using typed query with executeQuery
//   final typedQuery = FindTasksByStatusQuery('active');
//   final typedResult = await taskService.executeQuery<FindTasksByStatusQuery, EntityQueryResult<Task>>(typedQuery);
//   print('1. Typed query result: ${_formatResult(typedResult)}');
//
//   // 2. Using concept query with executeConceptQuery
//   final conceptResult = await taskService.executeConceptQuery(
//     'FindByStatus',
//     {'status': 'active'},
//   );
//   print('2. Concept query result: ${_formatResult(conceptResult)}');
//
//   // 3. Using expression query with executeExpressionQuery
//   final expression = AttributeExpression('status', 'active', ComparisonOperator.equals);
//   final expressionResult = await taskService.executeExpressionQuery(
//     'FindActiveWithExpression',
//     expression,
//     pagination: {'page': 1, 'pageSize': 10},
//     sorting: {'sortBy': 'dueDate', 'sortDirection': 'asc'},
//   );
//   print('3. Expression query result: ${_formatResult(expressionResult)}');
//
//   // 4. Using simple name-based query
//   final namedResult = await taskService.executeQueryByName(
//     'FindAll',
//   );
//   print('4. Named query result: ${namedResult.isSuccess ? namedResult.data?.length : "Error: ${namedResult.errorMessage}"}');
// }
//
// /// Simple task entity for the example
// class Task extends AggregateRoot {
//   String title;
//   String status;
//   DateTime dueDate;
//
//   Task(String id, this.title, this.status, this.dueDate) : super(id);
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'status': status,
//       'dueDate': dueDate.toIso8601String(),
//     };
//   }
//
//   @override
//   dynamic getAttribute(String name) {
//     switch (name) {
//       case 'title': return title;
//       case 'status': return status;
//       case 'dueDate': return dueDate;
//       default: return super.getAttribute(name);
//     }
//   }
// }
//
// /// Typed query for finding tasks by status
// class FindTasksByStatusQuery extends Query {
//   final String status;
//
//   FindTasksByStatusQuery(this.status) : super('FindTasksByStatus', conceptCode: 'Task');
//
//   @override
//   Map<String, dynamic> getParameters() {
//     return {'status': status};
//   }
// }
//
// /// Handler for the FindTasksByStatus query
// class FindTasksByStatusHandler implements IQueryHandler<FindTasksByStatusQuery, EntityQueryResult<Task>> {
//   final Repository<Task> repository;
//
//   FindTasksByStatusHandler(this.repository);
//
//   @override
//   Future<EntityQueryResult<Task>> handle(FindTasksByStatusQuery query) async {
//     final criteria = FilterCriteria<Task>()
//       ..addCriterion(Criterion('status', query.status));
//
//     final results = await repository.findByCriteria(criteria);
//
//     return EntityQueryResult.success(
//       results,
//       conceptCode: 'Task',
//     );
//   }
// }
//
// /// Generic concept query handler
// class ConceptQueryHandler<T extends Entity> implements IQueryHandler<ConceptQuery, EntityQueryResult<T>> {
//   final Repository<T> repository;
//   final Concept concept;
//
//   ConceptQueryHandler(this.repository, this.concept);
//
//   @override
//   Future<EntityQueryResult<T>> handle(ConceptQuery query) async {
//     // Build criteria from query parameters
//     final criteria = FilterCriteria<T>();
//
//     for (final entry in query.getParameters().entries) {
//       final key = entry.key;
//       final value = entry.value;
//
//       // Skip pagination and sorting parameters
//       if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
//         continue;
//       }
//
//       criteria.addCriterion(Criterion(key, value));
//     }
//
//     // Apply sorting if specified
//     final sortBy = query.getParameters()['sortBy'] as String?;
//     final sortDirection = query.getParameters()['sortDirection'] as String?;
//
//     if (sortBy != null) {
//       criteria.orderBy(
//         sortBy,
//         ascending: sortDirection != 'desc',
//       );
//     }
//
//     // Execute query
//     final results = await repository.findByCriteria(criteria);
//
//     return EntityQueryResult.success(
//       results,
//       concept: concept,
//     );
//   }
// }
//
// /// Format query results for display
// String _formatResult(EntityQueryResult<Task> result) {
//   if (!result.isSuccess) {
//     return "Error: ${result.errorMessage}";
//   }
//
//   final tasks = result.data ?? [];
//   return "${tasks.length} tasks: ${tasks.map((t) => t.title).join(', ')}";
// }
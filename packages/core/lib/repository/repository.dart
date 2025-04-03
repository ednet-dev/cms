// part of ednet_core;
//
// /// Base repository interface for all EDNet repositories.
// ///
// /// This interface defines the standard operations that all repositories
// /// should support, regardless of their backend implementation.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// abstract class Repository<T extends Entity> {
//   /// Finds an entity by its id.
//   ///
//   /// Parameters:
//   /// - [id]: The id of the entity to find
//   ///
//   /// Returns:
//   /// A Future with the entity, or null if not found
//   Future<T?> findById(dynamic id);
//
//   /// Finds all entities managed by this repository.
//   ///
//   /// Returns:
//   /// A Future with a list of all entities
//   Future<List<T>> findAll();
//
//   /// Finds entities matching the specified criteria.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria to match
//   /// - [skip]: Optional number of entities to skip (for pagination)
//   /// - [take]: Optional number of entities to take (for pagination)
//   ///
//   /// Returns:
//   /// A Future with a list of matching entities
//   Future<List<T>> findByCriteria(FilterCriteria<T> criteria, {int? skip, int? take});
//
//   /// Counts entities matching the specified criteria.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria to match
//   ///
//   /// Returns:
//   /// A Future with the count
//   Future<int> countByCriteria(FilterCriteria<T> criteria);
//
//   /// Saves an entity.
//   ///
//   /// This method will insert a new entity or update an existing one.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to save
//   ///
//   /// Returns:
//   /// A Future that completes when the operation is done
//   Future<void> save(T entity);
//
//   /// Deletes an entity.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to delete
//   ///
//   /// Returns:
//   /// A Future that completes when the operation is done
//   Future<void> delete(T entity);
//
//   /// Gets all entities in memory.
//   ///
//   /// This method is primarily for internal use and testing.
//   /// It may not be implemented by all repository types.
//   ///
//   /// Returns:
//   /// An Iterable of entities
//   Iterable<T> getEntities();
// }
//
// /// Extended repository interface for aggregate roots.
// ///
// /// This interface adds CQRS and event sourcing capabilities
// /// to the standard repository interface.
// ///
// /// Type parameters:
// /// - [T]: The aggregate root type this repository manages
// abstract class AggregateRepository<T extends AggregateRoot> extends Repository<T> {
//   /// Executes a command on the aggregate.
//   ///
//   /// Parameters:
//   /// - [id]: The id of the aggregate to execute the command on
//   /// - [command]: The command to execute
//   ///
//   /// Returns:
//   /// A Future with the command result
//   Future<CommandResult> executeCommand(dynamic id, ICommand command);
//
//   /// Finds aggregates by executing a query.
//   ///
//   /// Parameters:
//   /// - [query]: The query to execute
//   ///
//   /// Returns:
//   /// A Future with the query result
//   Future<QueryResult> executeQuery(IQuery query);
//
//   /// Gets the event history for an aggregate.
//   ///
//   /// Parameters:
//   /// - [id]: The id of the aggregate
//   ///
//   /// Returns:
//   /// A Future with a list of events
//   Future<List<IDomainEvent>> getHistory(dynamic id);
//
//   /// Gets the query dispatcher used by this repository.
//   ///
//   /// Returns:
//   /// The query dispatcher or null if not available
//   QueryDispatcher? getQueryDispatcher();
//
//   /// Gets the domain session used by this repository.
//   ///
//   /// Returns:
//   /// The domain session or null if not available
//   IDomainSession? getDomainSession();
// }
//
// /// Query-capable repository interface.
// ///
// /// This interface adds query capabilities to the standard
// /// repository interface using the unified query system.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// abstract class QueryableRepository<T extends Entity> extends Repository<T> {
//   /// Executes a query against this repository.
//   ///
//   /// Parameters:
//   /// - [query]: The query to execute
//   ///
//   /// Returns:
//   /// A Future with the query result
//   Future<IQueryResult> executeQuery(IQuery query);
//
//   /// Executes a concept query against this repository.
//   ///
//   /// Parameters:
//   /// - [queryName]: The name of the query
//   /// - [parameters]: Optional parameters for the query
//   ///
//   /// Returns:
//   /// A Future with the query result
//   Future<IQueryResult> executeConceptQuery(String queryName, [Map<String, dynamic>? parameters]);
//
//   /// Gets the query dispatcher used by this repository.
//   ///
//   /// Returns:
//   /// The query dispatcher or null if not available
//   QueryDispatcher? getQueryDispatcher();
//
//   /// Gets the concept associated with this repository.
//   ///
//   /// Returns:
//   /// The concept
//   Concept getConcept();
// }
//
// /// Multi-tenant repository interface.
// ///
// /// This interface adds multi-tenancy capabilities to repositories,
// /// ensuring that data is properly isolated between tenants.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// abstract class MultiTenantRepository<T extends Entity> extends Repository<T> {
//   /// Gets the current tenant ID.
//   ///
//   /// Returns:
//   /// The current tenant ID
//   String getCurrentTenantId();
//
//   /// Sets the current tenant ID.
//   ///
//   /// Parameters:
//   /// - [tenantId]: The tenant ID to set
//   void setCurrentTenantId(String tenantId);
//
//   /// Finds entities for a specific tenant.
//   ///
//   /// Parameters:
//   /// - [tenantId]: The tenant ID
//   /// - [criteria]: Optional criteria to match
//   ///
//   /// Returns:
//   /// A Future with a list of matching entities
//   Future<List<T>> findByTenant(String tenantId, [FilterCriteria<T>? criteria]);
// }
//
// /// Audit-capable repository interface.
// ///
// /// This interface adds auditing capabilities to repositories,
// /// tracking changes made to entities.
// ///
// /// Type parameters:
// /// - [T]: The entity type this repository manages
// abstract class AuditableRepository<T extends Entity> extends Repository<T> {
//   /// Gets the audit trail for an entity.
//   ///
//   /// Parameters:
//   /// - [id]: The id of the entity
//   ///
//   /// Returns:
//   /// A Future with a list of audit records
//   Future<List<AuditRecord>> getAuditTrail(dynamic id);
//
//   /// Gets the current user ID for auditing.
//   ///
//   /// Returns:
//   /// The current user ID
//   String getCurrentUserId();
//
//   /// Sets the current user ID for auditing.
//   ///
//   /// Parameters:
//   /// - [userId]: The user ID to set
//   void setCurrentUserId(String userId);
// }
//
// /// Audit record for tracking changes to entities.
// ///
// /// This class represents a record of a change made to an entity,
// /// including who made the change, when, and what changed.
// class AuditRecord {
//   /// The ID of this audit record.
//   final String id;
//
//   /// The ID of the entity that was changed.
//   final String entityId;
//
//   /// The type of entity that was changed.
//   final String entityType;
//
//   /// The ID of the user who made the change.
//   final String userId;
//
//   /// The timestamp when the change was made.
//   final DateTime timestamp;
//
//   /// The type of change (e.g., 'create', 'update', 'delete').
//   final String action;
//
//   /// The changes made, as a JSON-serializable map.
//   final Map<String, dynamic> changes;
//
//   /// Creates a new audit record.
//   ///
//   /// Parameters:
//   /// - [id]: The ID of this audit record
//   /// - [entityId]: The ID of the entity that was changed
//   /// - [entityType]: The type of entity that was changed
//   /// - [userId]: The ID of the user who made the change
//   /// - [timestamp]: The timestamp when the change was made
//   /// - [action]: The type of change
//   /// - [changes]: The changes made
//   AuditRecord({
//     required this.id,
//     required this.entityId,
//     required this.entityType,
//     required this.userId,
//     required this.timestamp,
//     required this.action,
//     required this.changes,
//   });
//
//   /// Creates an audit record from a JSON map.
//   ///
//   /// Parameters:
//   /// - [json]: The JSON map to create from
//   ///
//   /// Returns:
//   /// A new audit record
//   factory AuditRecord.fromJson(Map<String, dynamic> json) {
//     return AuditRecord(
//       id: json['id'] as String,
//       entityId: json['entityId'] as String,
//       entityType: json['entityType'] as String,
//       userId: json['userId'] as String,
//       timestamp: DateTime.parse(json['timestamp'] as String),
//       action: json['action'] as String,
//       changes: json['changes'] as Map<String, dynamic>,
//     );
//   }
//
//   /// Converts this audit record to a JSON map.
//   ///
//   /// Returns:
//   /// A JSON-serializable map
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'entityId': entityId,
//       'entityType': entityType,
//       'userId': userId,
//       'timestamp': timestamp.toIso8601String(),
//       'action': action,
//       'changes': changes,
//     };
//   }
// }
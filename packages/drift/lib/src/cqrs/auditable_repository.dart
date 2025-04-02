part of cqrs_drift;

/// Interface for audit logging services.
///
/// This interface allows for different audit logging implementations,
/// such as:
/// - Database logging
/// - File logging
/// - External service logging
///
/// Example usage:
/// ```dart
/// class DatabaseAuditLogger implements AuditLogger {
///   final EDNetDriftDatabase _db;
///   
///   DatabaseAuditLogger(this._db);
///   
///   @override
///   Future<void> logAction({
///     required String entityType,
///     required dynamic entityId,
///     required String action,
///     required String userId,
///     required Map<String, dynamic> changes,
///     required DateTime timestamp,
///   }) async {
///     await _db.customInsert(
///       'INSERT INTO audit_log (...) VALUES (...)',
///       variables: [...],
///     );
///   }
/// }
/// ```
abstract class AuditLogger {
  /// Logs an entity action in the audit trail.
  ///
  /// Parameters:
  /// - [entityType]: The type of entity (e.g., 'Task')
  /// - [entityId]: The ID of the entity
  /// - [action]: The action performed (e.g., 'CREATE', 'UPDATE', 'DELETE')
  /// - [userId]: The ID of the user who performed the action
  /// - [changes]: The changes made to the entity
  /// - [timestamp]: When the action occurred
  ///
  /// Returns:
  /// Future that completes when the action is logged
  Future<void> logAction({
    required String entityType,
    required dynamic entityId,
    required String action,
    required String userId,
    required Map<String, dynamic> changes,
    required DateTime timestamp,
  });
}

/// Interface for providing the current user context.
///
/// This interface allows for different strategies to determine
/// the current user, such as:
/// - From HTTP request context
/// - From environment configuration
/// - From session information
///
/// Example usage:
/// ```dart
/// class HttpRequestUserProvider implements UserContextProvider {
///   final HttpRequest request;
///   
///   HttpRequestUserProvider(this.request);
///   
///   @override
///   String get currentUserId => 
///     request.session['userId'] ?? 'anonymous';
/// }
/// ```
abstract class UserContextProvider {
  /// Gets the current user ID.
  ///
  /// Returns:
  /// The ID of the current user
  String get currentUserId;
}

/// Repository that tracks changes for audit purposes.
///
/// This repository enhances any other repository with audit capabilities:
/// - Automatically logs all entity actions
/// - Records who made each change
/// - Tracks what changed in each operation
/// - Records timestamps for all actions
///
/// This is essential for compliance, security, and traceability.
///
/// Example usage:
/// ```dart
/// final repository = AuditableRepository<Task>(
///   baseRepository,
///   auditLogger,
///   userContextProvider
/// );
/// 
/// // Will automatically log this creation
/// await repository.save(task);
/// ```
class AuditableRepository<T extends Entity<T>> implements Repository<T> {
  /// The underlying repository
  final Repository<T> _repository;
  
  /// The audit logger
  final AuditLogger _auditLogger;
  
  /// Provider for the current user context
  final UserContextProvider _userContext;
  
  /// Creates a new auditable repository.
  ///
  /// Parameters:
  /// - [repository]: The underlying repository to delegate to
  /// - [auditLogger]: The audit logger for recording changes
  /// - [userContext]: Provider for the current user context
  AuditableRepository(
    this._repository,
    this._auditLogger,
    this._userContext,
  );
  
  /// Finds an entity by ID.
  ///
  /// This method simply delegates to the underlying repository.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The entity, or null if not found
  @override
  Future<T?> findById(dynamic id) async {
    return _repository.findById(id);
  }
  
  /// Saves an entity with audit logging.
  ///
  /// This method:
  /// 1. Determines if this is a create or update operation
  /// 2. Captures the changes made to the entity
  /// 3. Saves the entity using the underlying repository
  /// 4. Logs the action in the audit trail
  ///
  /// Parameters:
  /// - [entity]: The entity to save
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> save(T entity) async {
    // Determine if this is a create or update operation
    final isCreate = entity.getAttribute('id') == null;
    
    // For updates, load the existing entity to capture changes
    T? oldEntity;
    if (!isCreate && entity.id != null) {
      oldEntity = await _repository.findById(entity.id!);
    }
    
    // Capture changes before saving
    final changes = _captureChanges(entity, oldEntity);
    
    // Save the entity
    final result = await _repository.save(entity);
    
    if (result.isSuccess) {
      // Get the entity ID (might be generated during save)
      final entityId = entity.id?.toString() ?? result.data?['id']?.toString();
      
      if (entityId != null) {
        // Log the action
        await _auditLogger.logAction(
          entityType: entity.concept.code,
          entityId: entityId,
          action: isCreate ? 'CREATE' : 'UPDATE',
          userId: _userContext.currentUserId,
          changes: changes,
          timestamp: DateTime.now(),
        );
      }
    }
    
    return result;
  }
  
  /// Deletes an entity with audit logging.
  ///
  /// This method:
  /// 1. Deletes the entity using the underlying repository
  /// 2. Logs the deletion in the audit trail
  ///
  /// Parameters:
  /// - [entity]: The entity to delete
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> delete(T entity) async {
    // Capture entity data before deletion
    final snapshot = _captureEntitySnapshot(entity);
    
    // Delete the entity
    final result = await _repository.delete(entity);
    
    if (result.isSuccess) {
      // Log the deletion
      await _auditLogger.logAction(
        entityType: entity.concept.code,
        entityId: entity.id?.toString() ?? '',
        action: 'DELETE',
        userId: _userContext.currentUserId,
        changes: snapshot,
        timestamp: DateTime.now(),
      );
    }
    
    return result;
  }
  
  /// Captures changes between two versions of an entity.
  ///
  /// This method compares the new entity with the old one
  /// and returns a map of changed fields.
  ///
  /// Parameters:
  /// - [newEntity]: The new version of the entity
  /// - [oldEntity]: The old version of the entity (null for creates)
  ///
  /// Returns:
  /// A map of changed fields and their values
  Map<String, dynamic> _captureChanges(T newEntity, T? oldEntity) {
    final changes = <String, dynamic>{};
    
    if (oldEntity == null) {
      // For creates, capture all attributes
      return _captureEntitySnapshot(newEntity);
    }
    
    // For updates, compare old and new values
    for (final attribute in newEntity.concept.attributes) {
      final newValue = newEntity.getAttribute(attribute.code);
      final oldValue = oldEntity.getAttribute(attribute.code);
      
      // Only include changed attributes
      if (newValue != oldValue) {
        changes[attribute.code] = {
          'old': oldValue,
          'new': newValue,
        };
      }
    }
    
    return changes;
  }
  
  /// Captures a snapshot of an entity's current state.
  ///
  /// This method creates a map of all attribute values.
  ///
  /// Parameters:
  /// - [entity]: The entity to snapshot
  ///
  /// Returns:
  /// A map of all attribute values
  Map<String, dynamic> _captureEntitySnapshot(T entity) {
    final snapshot = <String, dynamic>{};
    
    for (final attribute in entity.concept.attributes) {
      snapshot[attribute.code] = entity.getAttribute(attribute.code);
    }
    
    return snapshot;
  }
}

/// Enhances a DriftQueryRepository with audit capabilities.
///
/// This repository extends the standard [DriftQueryRepository] with
/// comprehensive auditing:
/// - Logs all entity operations
/// - Tracks which user performed each action
/// - Records detailed change history
///
/// Example usage:
/// ```dart
/// final repository = AuditableDriftRepository<Task>(
///   db,
///   taskConcept,
///   auditLogger,
///   userContextProvider
/// );
/// 
/// // Will automatically log this action with all details
/// await repository.save(task);
/// ```
class AuditableDriftRepository<T extends Entity<T>> extends DriftQueryRepository<T> {
  /// The audit logger
  final AuditLogger _auditLogger;
  
  /// Provider for the current user context
  final UserContextProvider _userContext;
  
  /// Creates a new auditable Drift repository.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [concept]: The concept for this repository
  /// - [auditLogger]: The audit logger for recording changes
  /// - [userContext]: Provider for the current user context
  AuditableDriftRepository(
    EDNetDriftDatabase db,
    Concept concept,
    this._auditLogger,
    this._userContext,
  ) : super(db, concept);
  
  /// Saves an entity with audit logging.
  ///
  /// This method:
  /// 1. Determines if this is a create or update operation
  /// 2. For updates, loads the existing entity to capture changes
  /// 3. Saves the entity to the database
  /// 4. Logs the action in the audit trail
  ///
  /// Parameters:
  /// - [entity]: The entity to save
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> save(T entity) async {
    // Determine if this is a create or update operation
    final isCreate = entity.getAttribute('id') == null;
    
    // For updates, load the existing entity to capture changes
    T? oldEntity;
    if (!isCreate && entity.id != null) {
      oldEntity = await findById(entity.id!);
    }
    
    // Capture changes before saving
    final changes = _captureChanges(entity, oldEntity);
    
    // Save the entity
    final result = await super.save(entity);
    
    if (result.isSuccess) {
      // Get the entity ID (might be generated during save)
      final entityId = entity.id?.toString() ?? result.data?['id']?.toString();
      
      if (entityId != null) {
        // Log the action
        await _auditLogger.logAction(
          entityType: _concept.code,
          entityId: entityId,
          action: isCreate ? 'CREATE' : 'UPDATE',
          userId: _userContext.currentUserId,
          changes: changes,
          timestamp: DateTime.now(),
        );
      }
    }
    
    return result;
  }
  
  /// Deletes an entity with audit logging.
  ///
  /// This method:
  /// 1. Captures a snapshot of the entity before deletion
  /// 2. Deletes the entity from the database
  /// 3. Logs the deletion in the audit trail
  ///
  /// Parameters:
  /// - [entity]: The entity to delete
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> delete(T entity) async {
    // Capture entity data before deletion
    final snapshot = _captureEntitySnapshot(entity);
    
    // Delete the entity
    final result = await super.delete(entity);
    
    if (result.isSuccess) {
      // Log the deletion
      await _auditLogger.logAction(
        entityType: _concept.code,
        entityId: entity.id?.toString() ?? '',
        action: 'DELETE',
        userId: _userContext.currentUserId,
        changes: snapshot,
        timestamp: DateTime.now(),
      );
    }
    
    return result;
  }
  
  /// Captures changes between two versions of an entity.
  ///
  /// This method compares the new entity with the old one
  /// and returns a map of changed fields.
  ///
  /// Parameters:
  /// - [newEntity]: The new version of the entity
  /// - [oldEntity]: The old version of the entity (null for creates)
  ///
  /// Returns:
  /// A map of changed fields and their values
  Map<String, dynamic> _captureChanges(T newEntity, T? oldEntity) {
    final changes = <String, dynamic>{};
    
    if (oldEntity == null) {
      // For creates, capture all attributes
      return _captureEntitySnapshot(newEntity);
    }
    
    // For updates, compare old and new values
    for (final attribute in _concept.attributes) {
      final newValue = newEntity.getAttribute(attribute.code);
      final oldValue = oldEntity.getAttribute(attribute.code);
      
      // Only include changed attributes
      if (newValue != oldValue) {
        changes[attribute.code] = {
          'old': oldValue,
          'new': newValue,
        };
      }
    }
    
    return changes;
  }
  
  /// Captures a snapshot of an entity's current state.
  ///
  /// This method creates a map of all attribute values.
  ///
  /// Parameters:
  /// - [entity]: The entity to snapshot
  ///
  /// Returns:
  /// A map of all attribute values
  Map<String, dynamic> _captureEntitySnapshot(T entity) {
    final snapshot = <String, dynamic>{};
    
    for (final attribute in _concept.attributes) {
      snapshot[attribute.code] = entity.getAttribute(attribute.code);
    }
    
    return snapshot;
  }
}

/// Factory for creating auditable repositories.
///
/// This factory simplifies the creation of auditable repositories
/// by handling the common setup and configuration details.
class AuditableRepositoryFactory {
  /// The Drift database
  final EDNetDriftDatabase _db;
  
  /// The domain model
  final Domain _domain;
  
  /// The audit logger
  final AuditLogger _auditLogger;
  
  /// Provider for the current user context
  final UserContextProvider _userContext;
  
  /// Creates a new auditable repository factory.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [domain]: The domain model
  /// - [auditLogger]: The audit logger for recording changes
  /// - [userContext]: Provider for the current user context
  AuditableRepositoryFactory(
    this._db,
    this._domain,
    this._auditLogger,
    this._userContext,
  );
  
  /// Creates an auditable repository for a specific entity type.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept
  ///
  /// Type parameters:
  /// - [T]: The entity type
  ///
  /// Returns:
  /// An auditable repository for the specified entity type
  AuditableDriftRepository<T> createRepository<T extends Entity<T>>(
    String conceptCode
  ) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    
    return AuditableDriftRepository<T>(
      _db,
      concept,
      _auditLogger,
      _userContext,
    );
  }
  
  /// Wraps an existing repository with audit capabilities.
  ///
  /// This method is useful when you have existing repositories
  /// that you want to enhance with auditing.
  ///
  /// Parameters:
  /// - [repository]: The repository to wrap
  ///
  /// Type parameters:
  /// - [T]: The entity type
  ///
  /// Returns:
  /// An auditable wrapper around the specified repository
  AuditableRepository<T> wrapRepository<T extends Entity<T>>(
    Repository<T> repository
  ) {
    return AuditableRepository<T>(
      repository,
      _auditLogger,
      _userContext,
    );
  }
  
  /// Ensures that the necessary database table exists for audit logging.
  ///
  /// Returns:
  /// Future that completes when the table is ready
  Future<void> ensureAuditTable() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS audit_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        action TEXT NOT NULL,
        user_id TEXT NOT NULL,
        changes TEXT NOT NULL, -- JSON
        timestamp INTEGER NOT NULL,
        
        -- Indices for efficient querying
        INDEX idx_audit_entity (entity_type, entity_id),
        INDEX idx_audit_user (user_id),
        INDEX idx_audit_time (timestamp)
      )
    ''');
  }
  
  /// Creates a database-based audit logger.
  ///
  /// This method creates an audit logger that stores audit records
  /// in the database, which is useful for keeping the audit trail
  /// alongside the entity data.
  ///
  /// Returns:
  /// A database audit logger
  AuditLogger createDatabaseAuditLogger() {
    return _DatabaseAuditLogger(_db);
  }
}

/// Database implementation of the AuditLogger interface.
///
/// This class stores audit records in the database.
class _DatabaseAuditLogger implements AuditLogger {
  /// The Drift database
  final EDNetDriftDatabase _db;
  
  /// Creates a new database audit logger.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  _DatabaseAuditLogger(this._db);
  
  @override
  Future<void> logAction({
    required String entityType,
    required dynamic entityId,
    required String action,
    required String userId,
    required Map<String, dynamic> changes,
    required DateTime timestamp,
  }) async {
    await _db.customInsert(
      '''
      INSERT INTO audit_log (
        entity_type,
        entity_id,
        action,
        user_id,
        changes,
        timestamp
      ) VALUES (?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable(entityType),
        Variable(entityId.toString()),
        Variable(action),
        Variable(userId),
        Variable(jsonEncode(changes)),
        Variable(timestamp.millisecondsSinceEpoch),
      ],
    );
  }
} 
/// CQRS adapter for Drift integration with EDNet Core
/// 
/// This library provides:
/// - Query adapters for EDNet Core model queries to Drift queries
/// - Command adapters for EDNet Core commands to Drift operations
/// - Event sourcing for aggregate persistence
/// - Multi-level caching for repository performance
/// - Multi-tenant architecture for SaaS applications
/// - Comprehensive audit trails for compliance
/// - REST-compatible query interfaces
/// - Query result mapping to domain entities
///
/// It connects the domain model CQRS components with Drift persistence layer.
library cqrs_drift;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

// External packages
import 'package:drift/drift.dart';

// EDNet Core imports
import 'package:ednet_core/domain/model.dart' as model;
import 'package:ednet_core/domain/application.dart' as app;
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core/domain/model/queries/expression_query.dart' as model;
import 'package:ednet_core/domain/model/queries/query.dart' as model;
import 'package:ednet_core/domain/model/entity/entity.dart';
import 'package:ednet_core/domain/model/queries/query_result.dart' as model;
import 'package:ednet_core/domain/model/queries/entity_query_result.dart' as model;
import 'package:ednet_core/domain/application/command.dart' as app;
import 'package:ednet_core/domain/application/command_result.dart' as app;
import 'package:ednet_core/domain/application/query_handler/concept_query_handler.dart' as app;
import 'package:ednet_core/domain/application/query_handler/default_concept_query_handler.dart' as app;
import 'package:ednet_core/domain/application/query_dispatcher.dart' as app;
import 'package:ednet_core/i_repository.dart';
import 'package:ednet_core/domain/domain_models.dart';

// Local imports
import 'ednet_drift_repository.dart';

// Core components
part 'src/cqrs/value_converter.dart';
part 'src/cqrs/query_adapter.dart';
part 'src/cqrs/command_adapter.dart';

// Specialized components
part 'src/cqrs/drift_query_repository.dart';
part 'src/cqrs/expression_query_adapter.dart';
part 'src/cqrs/query_handler.dart';
part 'src/cqrs/rest_query_adapter.dart';
part 'src/cqrs/drift_repository_extension.dart';

// Event sourcing components
part 'src/cqrs/event_sourced_repository.dart';

// Performance components
part 'src/cqrs/caching_repository.dart';

// Multi-tenant components
part 'src/cqrs/multi_tenant_repository.dart';

// Auditing components
part 'src/cqrs/auditable_repository.dart';

/// Creates a CQRS-enabled repository with all enterprise features.
///
/// This function creates a repository configured with:
/// - Event sourcing for tracking all state changes
/// - Multi-level caching for performance
/// - Multi-tenant isolation for SaaS applications
/// - Comprehensive audit trails for compliance
/// - Support for aggregate root semantics
/// - Type-safe repository operations
///
/// Parameters:
/// - [domain]: The domain model
/// - [sqlitePath]: Path to the SQLite database file
/// - [schemaVersion]: Optional schema version
/// - [enableEventSourcing]: Whether to enable event sourcing
/// - [enableCaching]: Whether to enable caching
/// - [enableMultiTenancy]: Whether to enable multi-tenancy
/// - [enableAuditing]: Whether to enable audit trails
/// - [persistentCache]: Optional persistent cache implementation
/// - [tenantContextProvider]: Optional tenant context provider (required if enableMultiTenancy is true)
/// - [userContextProvider]: Optional user context provider (required if enableAuditing is true)
/// - [tenantIdField]: Name of the tenant ID field (defaults to 'tenantId')
///
/// Returns:
/// An EDNetDriftCqrsRepository with the requested features
EDNetDriftCqrsRepository createEnterpriseRepository({
  required Domain domain,
  required String sqlitePath,
  int? schemaVersion,
  bool enableEventSourcing = false,
  bool enableCaching = false,
  bool enableMultiTenancy = false,
  bool enableAuditing = false,
  PersistentCache? persistentCache,
  TenantContextProvider? tenantContextProvider,
  UserContextProvider? userContextProvider,
  String tenantIdField = 'tenantId',
}) {
  // Create the base repository
  final repository = EDNetDriftCqrsRepository(
    domain: domain,
    sqlitePath: sqlitePath,
    schemaVersion: schemaVersion,
  );
  
  // Initialize components
  if (enableEventSourcing) {
    // Create event sourcing components
    final eventPublisher = EventPublisher();
    final eventStore = EventStore(repository.database, eventPublisher);
    
    // Register with service locator for dependency injection
    ServiceLocator.instance.register<EventPublisher>(eventPublisher);
    ServiceLocator.instance.register<EventStore>(eventStore);
    
    // Create factory for event-sourced repositories
    final eventSourcedRepositoryFactory = EventSourcedRepositoryFactory(
      repository.database,
      domain,
      eventStore,
    );
    
    // Initialize event sourcing tables
    eventSourcedRepositoryFactory.ensureEventSourcingTables();
    
    // Register with service locator
    ServiceLocator.instance.register<EventSourcedRepositoryFactory>(
      eventSourcedRepositoryFactory
    );
  }
  
  if (enableCaching) {
    // Create factory for caching repositories
    final cachingRepositoryFactory = CachingRepositoryFactory(
      repository.database,
      domain,
      persistentCache: persistentCache,
    );
    
    // Register with service locator
    ServiceLocator.instance.register<CachingRepositoryFactory>(
      cachingRepositoryFactory
    );
  }
  
  if (enableMultiTenancy) {
    // Validate tenant context provider
    if (tenantContextProvider == null) {
      throw ArgumentError(
        'tenantContextProvider is required when enableMultiTenancy is true'
      );
    }
    
    // Create factory for multi-tenant repositories
    final multiTenantRepositoryFactory = MultiTenantRepositoryFactory(
      repository.database,
      domain,
      tenantContextProvider,
      tenantIdField: tenantIdField,
    );
    
    // Register with service locator
    ServiceLocator.instance.register<MultiTenantRepositoryFactory>(
      multiTenantRepositoryFactory
    );
    
    // Register tenant context provider
    ServiceLocator.instance.register<TenantContextProvider>(
      tenantContextProvider
    );
  }
  
  if (enableAuditing) {
    // Validate user context provider
    if (userContextProvider == null) {
      throw ArgumentError(
        'userContextProvider is required when enableAuditing is true'
      );
    }
    
    // Create auditable repository factory
    final auditableRepositoryFactory = AuditableRepositoryFactory(
      repository.database,
      domain,
      _createAuditLogger(repository.database),
      userContextProvider,
    );
    
    // Initialize audit table
    auditableRepositoryFactory.ensureAuditTable();
    
    // Register with service locator
    ServiceLocator.instance.register<AuditableRepositoryFactory>(
      auditableRepositoryFactory
    );
    
    // Register user context provider
    ServiceLocator.instance.register<UserContextProvider>(
      userContextProvider
    );
  }
  
  return repository;
}

/// Creates an audit logger based on the repository configuration.
///
/// This is a helper function for the createEnterpriseRepository function.
AuditLogger _createAuditLogger(EDNetDriftDatabase db) {
  // Create a database audit logger by default
  return _DatabaseAuditLogger(db);
}

/// Simple dependency injection container for EDNet.
///
/// This service locator provides a way to register and retrieve
/// global services and components.
class ServiceLocator {
  /// Singleton instance
  static final ServiceLocator instance = ServiceLocator._();
  
  /// Private constructor
  ServiceLocator._();
  
  /// Map of services by type
  final _services = <Type, dynamic>{};
  
  /// Registers a service with the locator.
  ///
  /// Parameters:
  /// - [service]: The service instance
  void register<T>(T service) {
    _services[T] = service;
  }
  
  /// Gets a service from the locator.
  ///
  /// Type parameters:
  /// - [T]: The type of service to retrieve
  ///
  /// Returns:
  /// The service instance
  ///
  /// Throws:
  /// ArgumentError if the service is not registered
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw ArgumentError('Service not registered: $T');
    }
    return service as T;
  }
  
  /// Checks if a service is registered.
  ///
  /// Type parameters:
  /// - [T]: The type of service to check
  ///
  /// Returns:
  /// True if the service is registered, false otherwise
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }
  
  /// Clears all registered services.
  ///
  /// This is primarily useful for testing.
  void clear() {
    _services.clear();
  }
} 
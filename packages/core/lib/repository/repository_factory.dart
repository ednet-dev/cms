// part of ednet_core;
//
// /// Factory interface for creating repositories.
// ///
// /// This interface defines methods for creating different types of repositories
// /// based on domain concepts, allowing for consistent repository creation
// /// across different storage implementations.
// abstract class RepositoryFactory {
//   /// Creates a standard repository for a concept.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   ///
//   /// Returns:
//   /// A repository for entities of the concept
//   Repository<Entity> createRepository(Concept concept);
//
//   /// Creates a generic repository for an entity type.
//   ///
//   /// Type parameters:
//   /// - [T]: The entity type this repository manages
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   ///
//   /// Returns:
//   /// A repository for entities of type T
//   Repository<T> createGenericRepository<T extends Entity>(Concept concept);
//
//   /// Creates an aggregate repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept representing the aggregate root
//   /// - [queryDispatcher]: Optional query dispatcher
//   /// - [session]: Optional domain session
//   ///
//   /// Returns:
//   /// An aggregate repository
//   AggregateRepository<AggregateRoot> createAggregateRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//     IDomainSession? session,
//   });
//
//   /// Creates a queryable repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   /// - [queryDispatcher]: Optional query dispatcher
//   ///
//   /// Returns:
//   /// A queryable repository
//   QueryableRepository<Entity> createQueryableRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//   });
//
//   /// Creates a multi-tenant repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   /// - [tenantId]: The initial tenant ID
//   /// - [tenantField]: The field name used for tenant ID (default: 'tenantId')
//   ///
//   /// Returns:
//   /// A multi-tenant repository
//   MultiTenantRepository<Entity> createMultiTenantRepository(
//     Concept concept, {
//     required String tenantId,
//     String tenantField = 'tenantId',
//   });
//
//   /// Creates an auditable repository.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   /// - [userId]: The initial user ID for auditing
//   ///
//   /// Returns:
//   /// An auditable repository
//   AuditableRepository<Entity> createAuditableRepository(
//     Concept concept, {
//     required String userId,
//   });
//
//   /// Creates a repository enhanced with all enterprise features.
//   ///
//   /// This method creates a repository with CQRS, event sourcing,
//   /// multi-tenancy, and auditing capabilities.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to create a repository for
//   /// - [queryDispatcher]: Optional query dispatcher
//   /// - [session]: Optional domain session
//   /// - [tenantId]: Optional tenant ID for multi-tenancy
//   /// - [userId]: Optional user ID for auditing
//   ///
//   /// Returns:
//   /// A fully-featured repository
//   Repository<Entity> createEnterpriseRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//     IDomainSession? session,
//     String? tenantId,
//     String? userId,
//   });
//
//   /// Gets the domain model this factory works with.
//   ///
//   /// Returns:
//   /// The domain model
//   Domain getDomain();
// }
//
// /// Registry of repository factories.
// ///
// /// This registry keeps track of available repository factories,
// /// allowing code to obtain the appropriate factory for a given
// /// storage mechanism.
// class RepositoryFactoryRegistry {
//   /// The singleton instance.
//   static final RepositoryFactoryRegistry instance = RepositoryFactoryRegistry._();
//
//   /// Private constructor.
//   RepositoryFactoryRegistry._();
//
//   /// Map of registered factories by storage type.
//   final Map<String, RepositoryFactory> _factories = {};
//
//   /// Registers a repository factory.
//   ///
//   /// Parameters:
//   /// - [storageType]: The storage type identifier (e.g., 'drift', 'openapi')
//   /// - [factory]: The factory to register
//   void registerFactory(String storageType, RepositoryFactory factory) {
//     _factories[storageType] = factory;
//   }
//
//   /// Gets a factory for a storage type.
//   ///
//   /// Parameters:
//   /// - [storageType]: The storage type identifier
//   ///
//   /// Returns:
//   /// The factory for the storage type, or null if not found
//   RepositoryFactory? getFactory(String storageType) {
//     return _factories[storageType];
//   }
//
//   /// Checks if a factory is registered for a storage type.
//   ///
//   /// Parameters:
//   /// - [storageType]: The storage type identifier
//   ///
//   /// Returns:
//   /// True if a factory is registered, false otherwise
//   bool hasFactory(String storageType) {
//     return _factories.containsKey(storageType);
//   }
//
//   /// Gets a list of all registered storage types.
//   ///
//   /// Returns:
//   /// A list of registered storage type identifiers
//   List<String> getRegisteredStorageTypes() {
//     return _factories.keys.toList();
//   }
// }
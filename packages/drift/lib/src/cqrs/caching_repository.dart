part of cqrs_drift;

/// Multi-level cache system for entity repositories.
///
/// This class implements a two-level caching strategy:
/// - L1: In-memory cache for fastest access
/// - L2: Persistent cache for retention between app sessions
///
/// It provides:
/// - Efficient cache retrieval
/// - Cache invalidation
/// - Configurable expiration policies
///
/// Example usage:
/// ```dart
/// final cache = EntityCache<Task>(
///   inMemoryCacheDuration: Duration(minutes: 10),
///   persistentCacheDuration: Duration(hours: 1)
/// );
/// ```
class EntityCache<T extends Entity<T>> {
  /// In-memory cache (fastest, but volatile)
  final Map<String, _CacheEntry<T>> _memoryCache = {};
  
  /// Duration for which items remain valid in the memory cache
  final Duration _memoryCacheDuration;
  
  /// Duration for which items remain valid in the persistent cache
  final Duration _persistentCacheDuration;
  
  /// Interface to the persistent cache storage
  final PersistentCache? _persistentCache;
  
  /// Creates a new entity cache.
  ///
  /// Parameters:
  /// - [inMemoryCacheDuration]: How long items remain valid in memory
  /// - [persistentCacheDuration]: How long items remain valid in persistent storage
  /// - [persistentCache]: Optional persistent cache implementation
  EntityCache({
    Duration? inMemoryCacheDuration,
    Duration? persistentCacheDuration,
    PersistentCache? persistentCache,
  }) : _memoryCacheDuration = inMemoryCacheDuration ?? Duration(minutes: 5),
       _persistentCacheDuration = persistentCacheDuration ?? Duration(hours: 1),
       _persistentCache = persistentCache;
  
  /// Gets an entity from the cache.
  ///
  /// This method checks first the memory cache, then the persistent cache.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The cached entity, or null if not found or expired
  Future<T?> get(String id) async {
    // Try memory cache first (fastest)
    final memoryEntry = _memoryCache[id];
    if (memoryEntry != null && !memoryEntry.isExpired) {
      return memoryEntry.entity;
    }
    
    // If expired, remove from memory cache
    if (memoryEntry != null) {
      _memoryCache.remove(id);
    }
    
    // Try persistent cache if available
    if (_persistentCache != null) {
      final cachedJson = await _persistentCache!.get(
        _getCacheKey(id),
        maxAge: _persistentCacheDuration,
      );
      
      if (cachedJson != null) {
        try {
          // Deserialize the entity
          final entity = _deserializeEntity(cachedJson);
          
          // Cache it in memory for faster future access
          put(id, entity);
          
          return entity;
        } catch (e) {
          // If deserialization fails, invalidate the cache entry
          await _persistentCache!.remove(_getCacheKey(id));
        }
      }
    }
    
    return null;
  }
  
  /// Puts an entity in the cache.
  ///
  /// This method stores the entity in both the memory and persistent caches.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  /// - [entity]: The entity to cache
  ///
  /// Returns:
  /// Future that completes when the entity is cached
  Future<void> put(String id, T entity) async {
    // Store in memory cache
    _memoryCache[id] = _CacheEntry(
      entity: entity,
      expiration: DateTime.now().add(_memoryCacheDuration),
    );
    
    // Store in persistent cache if available
    if (_persistentCache != null) {
      try {
        final serialized = _serializeEntity(entity);
        await _persistentCache!.put(
          _getCacheKey(id),
          serialized,
          maxAge: _persistentCacheDuration,
        );
      } catch (e) {
        // Serialization or storage failure - log but don't crash
        print('Error storing entity in persistent cache: $e');
      }
    }
  }
  
  /// Invalidates an entity in the cache.
  ///
  /// This method removes the entity from both the memory and persistent caches.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// Future that completes when the entity is invalidated
  Future<void> invalidate(String id) async {
    // Remove from memory cache
    _memoryCache.remove(id);
    
    // Remove from persistent cache if available
    if (_persistentCache != null) {
      await _persistentCache!.remove(_getCacheKey(id));
    }
  }
  
  /// Clears all entities from the cache.
  ///
  /// Returns:
  /// Future that completes when the cache is cleared
  Future<void> clear() async {
    // Clear memory cache
    _memoryCache.clear();
    
    // Clear persistent cache if available
    if (_persistentCache != null) {
      await _persistentCache!.clear();
    }
  }
  
  /// Gets the cache key for an entity ID.
  ///
  /// This method prefixes the ID with the entity type to avoid
  /// conflicts with other entity types in the same cache.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The cache key
  String _getCacheKey(String id) {
    return 'entity:${T.toString()}:$id';
  }
  
  /// Serializes an entity to JSON.
  ///
  /// Parameters:
  /// - [entity]: The entity to serialize
  ///
  /// Returns:
  /// The serialized entity as a JSON string
  String _serializeEntity(T entity) {
    final map = entity.toJson();
    return jsonEncode(map);
  }
  
  /// Deserializes an entity from JSON.
  ///
  /// This requires the entity type to have a factory method
  /// that can create an entity from a map.
  ///
  /// Parameters:
  /// - [json]: The JSON string to deserialize
  ///
  /// Returns:
  /// The deserialized entity
  ///
  /// Throws:
  /// Exception if deserialization fails
  T _deserializeEntity(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    
    // This assumes the entity has a fromJson factory
    // In a real implementation, you would need a registry
    // of entity factories similar to the event type registry
    throw UnimplementedError(
      'Entity deserialization requires a factory registry. ' +
      'Implement a proper deserialization strategy for your entity type.'
    );
  }
}

/// Interface for persistent cache implementations.
///
/// This interface allows different persistent cache backends
/// to be used with the EntityCache.
abstract class PersistentCache {
  /// Gets an item from the cache.
  ///
  /// Parameters:
  /// - [key]: The cache key
  /// - [maxAge]: The maximum age of the cache entry
  ///
  /// Returns:
  /// The cached value, or null if not found or expired
  Future<String?> get(String key, {Duration? maxAge});
  
  /// Puts an item in the cache.
  ///
  /// Parameters:
  /// - [key]: The cache key
  /// - [value]: The value to cache
  /// - [maxAge]: The maximum age of the cache entry
  ///
  /// Returns:
  /// Future that completes when the item is cached
  Future<void> put(String key, String value, {Duration? maxAge});
  
  /// Removes an item from the cache.
  ///
  /// Parameters:
  /// - [key]: The cache key
  ///
  /// Returns:
  /// Future that completes when the item is removed
  Future<void> remove(String key);
  
  /// Clears all items from the cache.
  ///
  /// Returns:
  /// Future that completes when the cache is cleared
  Future<void> clear();
}

/// Repository that implements multi-level caching.
///
/// This repository extends the standard [DriftQueryRepository] with
/// caching capabilities:
/// - Checks cache before database access
/// - Automatically updates cache on entity changes
/// - Provides cache invalidation control
///
/// Example usage:
/// ```dart
/// final repository = CachingRepository<Task>(
///   db,
///   taskConcept,
///   EntityCache<Task>()
/// );
/// 
/// // Entity will be cached after this call
/// final task = await repository.findById(1);
/// 
/// // Subsequent calls will use the cache
/// final cachedTask = await repository.findById(1);
/// ```
class CachingRepository<T extends Entity<T>> extends DriftQueryRepository<T> {
  /// The entity cache
  final EntityCache<T> _cache;
  
  /// Creates a new caching repository.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [concept]: The concept for this repository
  /// - [cache]: The entity cache
  CachingRepository(
    EDNetDriftDatabase db,
    Concept concept,
    this._cache,
  ) : super(db, concept);
  
  /// Gets an entity by its ID, using the cache if available.
  ///
  /// This method first checks the cache, and only accesses
  /// the database if the entity is not found in the cache.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The entity, or null if not found
  @override
  Future<T?> findById(dynamic id) async {
    final stringId = id.toString();
    
    // Try to get from cache first
    final cachedEntity = await _cache.get(stringId);
    if (cachedEntity != null) {
      return cachedEntity;
    }
    
    // Not in cache, query database
    final entity = await super.findById(id);
    
    // Cache the entity if found
    if (entity != null) {
      await _cache.put(stringId, entity);
    }
    
    return entity;
  }
  
  /// Finds entities using a query builder, bypassing the cache.
  ///
  /// This method is not cached because query results represent
  /// collections that may change frequently and have complex
  /// cache invalidation requirements.
  ///
  /// Parameters:
  /// - [buildQuery]: Function to build the query
  ///
  /// Returns:
  /// The query result
  @override
  Future<EntityQueryResult<T>> findWhere(
    void Function(QueryBuilder builder) buildQuery
  ) async {
    // Execute the query without caching
    return super.findWhere(buildQuery);
  }
  
  /// Saves an entity, updating the cache.
  ///
  /// This method saves the entity to the database and updates
  /// the cache with the latest version.
  ///
  /// Parameters:
  /// - [entity]: The entity to save
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> save(T entity) async {
    // Save to database
    final result = await super.save(entity);
    
    if (result.isSuccess) {
      // Update cache with latest version
      final entityId = entity.id?.toString() ?? result.data?['id']?.toString();
      if (entityId != null) {
        await _cache.put(entityId, entity);
      }
    }
    
    return result;
  }
  
  /// Deletes an entity, invalidating the cache.
  ///
  /// This method deletes the entity from the database and
  /// removes it from the cache.
  ///
  /// Parameters:
  /// - [entity]: The entity to delete
  ///
  /// Returns:
  /// The command result
  @override
  Future<CommandResult> delete(T entity) async {
    // Delete from database
    final result = await super.delete(entity);
    
    if (result.isSuccess) {
      // Invalidate cache
      final entityId = entity.id?.toString();
      if (entityId != null) {
        await _cache.invalidate(entityId);
      }
    }
    
    return result;
  }
  
  /// Invalidates an entity in the cache.
  ///
  /// This method is useful when you know an entity has changed
  /// but don't need to update it yourself.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// Future that completes when the cache is invalidated
  Future<void> invalidateCache(dynamic id) async {
    await _cache.invalidate(id.toString());
  }
  
  /// Clears the entire cache.
  ///
  /// This method is useful for testing or when major data
  /// changes require a complete cache refresh.
  ///
  /// Returns:
  /// Future that completes when the cache is cleared
  Future<void> clearCache() async {
    await _cache.clear();
  }
}

/// Factory for creating caching repositories.
///
/// This factory simplifies the creation of caching repositories
/// by handling the common setup and configuration details.
class CachingRepositoryFactory {
  /// The Drift database
  final EDNetDriftDatabase _db;
  
  /// The domain model
  final Domain _domain;
  
  /// Optional persistent cache implementation
  final PersistentCache? _persistentCache;
  
  /// Creates a new caching repository factory.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [domain]: The domain model
  /// - [persistentCache]: Optional persistent cache implementation
  CachingRepositoryFactory(
    this._db,
    this._domain, {
    PersistentCache? persistentCache,
  }) : _persistentCache = persistentCache;
  
  /// Creates a caching repository for a specific entity type.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept
  /// - [inMemoryCacheDuration]: How long entities remain in memory
  /// - [persistentCacheDuration]: How long entities remain in persistent storage
  ///
  /// Type parameters:
  /// - [T]: The entity type
  ///
  /// Returns:
  /// A caching repository for the specified entity type
  CachingRepository<T> createRepository<T extends Entity<T>>(
    String conceptCode, {
    Duration? inMemoryCacheDuration,
    Duration? persistentCacheDuration,
  }) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    
    final cache = EntityCache<T>(
      inMemoryCacheDuration: inMemoryCacheDuration,
      persistentCacheDuration: persistentCacheDuration,
      persistentCache: _persistentCache,
    );
    
    return CachingRepository<T>(
      _db,
      concept,
      cache,
    );
  }
}

/// Entry in the memory cache.
///
/// This class tracks an entity and its expiration time.
class _CacheEntry<T> {
  /// The cached entity
  final T entity;
  
  /// When this cache entry expires
  final DateTime expiration;
  
  /// Creates a new cache entry.
  ///
  /// Parameters:
  /// - [entity]: The entity to cache
  /// - [expiration]: When the cache entry expires
  _CacheEntry({
    required this.entity,
    required this.expiration,
  });
  
  /// Whether this cache entry has expired.
  bool get isExpired => DateTime.now().isAfter(expiration);
} 
part of ednet_core_flutter;

/// ShellPersistence handles saving and loading entities through the ShellApp.
///
/// This class provides a lightweight persistence layer for managing entity data
/// in the Shell app, supporting both in-memory and file-based persistence options.
class ShellPersistence {
  /// The domain containing the concepts and models
  final Domain domain;

  /// Map of concept codes to repository instances
  final Map<String, dynamic> _repositories = {};

  /// Domain session for managing domain operations
  DomainSession? _domainSession;

  /// Constructor
  ShellPersistence(this.domain);

  /// Returns true if a domain session exists
  bool get hasDomainSession => _domainSession != null;

  /// Gets the domain session, creating one if necessary
  DomainSession getDomainSession() {
    // Return existing session if available
    if (_domainSession != null) {
      return _domainSession!;
    }

    // Create domain models and session
    final domainModels = DomainModels(domain);
    _domainSession = DomainSession(domainModels);
    return _domainSession!;
  }

  /// Finds a concept in the domain by its code
  Concept? findConcept(String conceptCode) {
    for (final model in domain.models) {
      for (final concept in model.concepts) {
        if (concept.code == conceptCode) {
          return concept;
        }
      }
    }
    return null;
  }

  /// Get a repository for a specific concept
  dynamic _getRepository(String conceptCode) {
    // If repository doesn't exist, create it
    if (!_repositories.containsKey(conceptCode)) {
      // Try to find the concept in the domain
      final concept = findConcept(conceptCode);

      // If concept is found, try to use domain session if available
      if (concept != null && hasDomainSession) {
        try {
          // Try to access repository through session
          // Note: This is a placeholder for future implementation
          // The actual implementation depends on the DomainSession API
          // _repositories[conceptCode] = new DomainRepository(session, concept);
          // return _repositories[conceptCode];
        } catch (e) {
          debugPrint('Error getting repository from session: $e');
        }
      }

      // Fallback to memory repository if domain session doesn't provide one
      _repositories[conceptCode] = MemoryRepository(conceptCode);
    }

    return _repositories[conceptCode];
  }

  /// Save an entity to the repository
  Future<bool> saveEntity(
      String conceptCode, Map<String, dynamic> entityData) async {
    try {
      // First check if we can get a valid domain session
      DomainSession? session;
      try {
        session = getDomainSession();
      } catch (e) {
        // Session creation failed
        debugPrint('Failed to create domain session: $e');
        return false;
      }

      // Find the concept in the domain
      final concept = findConcept(conceptCode);
      if (concept == null) {
        // Cannot persist entity without a matching concept
        return false;
      }

      // Get repository for this concept
      final repository = _getRepository(conceptCode);
      if (repository == null) {
        return false;
      }

      if (repository is MemoryRepository) {
        // For memory repository, use simplified approach
        final id = entityData['id'] ??
            '${conceptCode}-${DateTime.now().millisecondsSinceEpoch}';
        entityData['id'] = id;
        return await repository.save(id, entityData);
      } else {
        // For domain repository implementation
        debugPrint('Domain repository implementation not available');
        return false;
      }
    } catch (e) {
      debugPrint('Error saving entity: $e');
      return false;
    }
  }

  /// Load entities from the repository
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) async {
    try {
      // First check if we can get a valid domain session
      DomainSession? session;
      try {
        session = getDomainSession();
      } catch (e) {
        // Session creation failed
        debugPrint('Failed to create domain session: $e');
        return [];
      }

      // Find the concept in the domain
      final concept = findConcept(conceptCode);
      if (concept == null) {
        // Cannot load entities without a matching concept
        return [];
      }

      // Get repository for this concept
      final repository = _getRepository(conceptCode);
      if (repository == null) return [];

      if (repository is MemoryRepository) {
        // For memory repository, use simplified approach
        return await repository.findAll();
      } else {
        // For domain repository implementation
        // This is a placeholder for future implementation with actual Domain API
        return [];
      }
    } catch (e) {
      debugPrint('Error loading entities: $e');
      return [];
    }
  }
}

/// In-memory repository implementation
class MemoryRepository {
  final String conceptCode;
  final Map<String, Map<String, dynamic>> _entities = {};

  MemoryRepository(this.conceptCode);

  Future<bool> save(String id, Map<String, dynamic> data) async {
    _entities[id] = Map.from(data);
    return true;
  }

  Future<Map<String, dynamic>?> findById(String id) async {
    return _entities[id] != null ? Map.from(_entities[id]!) : null;
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    return _entities.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}

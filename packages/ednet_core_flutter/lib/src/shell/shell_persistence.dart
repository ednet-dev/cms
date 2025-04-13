part of ednet_core_flutter;

/// Abstract repository adapter that allows switching between different repository implementations
abstract class RepositoryAdapter {
  /// Get a repository for a specific concept
  dynamic getRepository(String conceptCode, Concept? concept);

  /// Check if this adapter can handle the given concept
  bool canHandle(String conceptCode, Concept? concept);
}

/// Development repository adapter that provides sample data for testing and demonstration
class DevelopmentRepositoryAdapter implements RepositoryAdapter {
  final Domain domain;
  final Map<String, dynamic> _domainRepositories = {};

  DevelopmentRepositoryAdapter(this.domain);

  @override
  dynamic getRepository(String conceptCode, Concept? concept) {
    if (_domainRepositories.containsKey(conceptCode)) {
      return _domainRepositories[conceptCode];
    }

    // Create development repository with sample data
    final devRepository = DevelopmentRepository(conceptCode, concept);
    _domainRepositories[conceptCode] = devRepository;
    return devRepository;
  }

  @override
  bool canHandle(String conceptCode, Concept? concept) {
    // Development adapter can handle any concept
    return true;
  }
}

/// Production repository adapter that connects to real domain models and persistence
class ProductionRepositoryAdapter implements RepositoryAdapter {
  final Domain domain;
  final DomainSession? domainSession;
  final Map<String, dynamic> _repositories = {};

  ProductionRepositoryAdapter(this.domain, this.domainSession);

  @override
  dynamic getRepository(String conceptCode, Concept? concept) {
    if (_repositories.containsKey(conceptCode)) {
      return _repositories[conceptCode];
    }

    // Try to get a repository from the domain session if available
    if (domainSession != null && concept != null) {
      try {
        // This would be the actual production repository implementation
        // Currently defaulting to in-memory implementation
        final repository = MemoryRepository(conceptCode);
        _repositories[conceptCode] = repository;
        return repository;
      } catch (e) {
        debugPrint('Error getting repository from domain session: $e');
      }
    }

    // Fallback to memory repository if domain session doesn't provide one
    final memoryRepo = MemoryRepository(conceptCode);
    _repositories[conceptCode] = memoryRepo;
    return memoryRepo;
  }

  @override
  bool canHandle(String conceptCode, Concept? concept) {
    // In a real implementation, we might check if the concept is supported
    return true;
  }
}

/// Repository implementation that provides sample data for development/demo purposes
class DevelopmentRepository {
  final String conceptCode;
  final Concept? concept;
  final Map<String, Map<String, dynamic>> _sampleEntities = {};

  DevelopmentRepository(this.conceptCode, this.concept) {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Create appropriate sample data based on concept code
    if (conceptCode == 'Task') {
      _addSampleTask(
          'task-1', 'Complete user interface', 'high', 'in_progress');
      _addSampleTask('task-2', 'Fix persistence bugs', 'medium', 'not_started');
      _addSampleTask('task-3', 'Write documentation', 'low', 'completed');
    } else if (conceptCode == 'Project') {
      _addSampleProject(
          'project-1', 'EDNet Core Refactoring', 'Improve core architecture');
      _addSampleProject('project-2', 'Mobile App Development',
          'Create cross-platform mobile application');
    } else if (conceptCode == 'Team') {
      _addSampleTeam('team-1', 'Backend Team');
      _addSampleTeam('team-2', 'Frontend Team');
    } else if (conceptCode == 'Resource') {
      _addSampleResource('resource-1', 'Senior Developer', 100.0);
      _addSampleResource('resource-2', 'Designer', 85.0);
    } else if (conceptCode == 'Budget') {
      _addSampleBudget('budget-1', 10000.0, 'USD');
      _addSampleBudget('budget-2', 5000.0, 'EUR');
    }
    // Add more sample data for other concepts as needed
  }

  void _addSampleTask(String id, String title, String priority, String status) {
    _sampleEntities[id] = {
      'id': id,
      'title': title,
      'priority': priority,
      'status': status,
      'dueDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }

  void _addSampleProject(String id, String name, String description) {
    _sampleEntities[id] = {
      'id': id,
      'name': name,
      'description': description,
      'startDate': DateTime.now().toIso8601String(),
      'endDate': DateTime.now().add(const Duration(days: 90)).toIso8601String(),
      'budget': 50000.0,
    };
  }

  void _addSampleTeam(String id, String name) {
    _sampleEntities[id] = {
      'id': id,
      'name': name,
    };
  }

  void _addSampleResource(String id, String name, double cost) {
    _sampleEntities[id] = {
      'id': id,
      'name': name,
      'type': 'human',
      'cost': cost,
    };
  }

  void _addSampleBudget(String id, double amount, String currency) {
    _sampleEntities[id] = {
      'id': id,
      'amount': amount,
      'currency': currency,
    };
  }

  Future<bool> save(String id, Map<String, dynamic> data) async {
    _sampleEntities[id] = Map.from(data);
    return true;
  }

  Future<Map<String, dynamic>?> findById(String id) async {
    return _sampleEntities[id] != null ? Map.from(_sampleEntities[id]!) : null;
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    return _sampleEntities.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}

/// Adapter Chain implementation using Chain of Responsibility pattern
class RepositoryAdapterChain {
  final List<RepositoryAdapter> _adapters = [];

  void addAdapter(RepositoryAdapter adapter) {
    _adapters.add(adapter);
  }

  dynamic getRepository(String conceptCode, Concept? concept) {
    for (final adapter in _adapters) {
      if (adapter.canHandle(conceptCode, concept)) {
        return adapter.getRepository(conceptCode, concept);
      }
    }
    // Fallback to memory repository
    return MemoryRepository(conceptCode);
  }
}

/// ShellPersistence handles saving and loading entities through the ShellApp.
///
/// This class provides a lightweight persistence layer for managing entity data
/// in the Shell app, supporting both in-memory and file-based persistence options.
class ShellPersistence {
  /// The domain containing the concepts and models
  final Domain domain;

  /// Domain session for managing domain operations
  DomainSession? _domainSession;

  /// Repository adapter chain
  late final RepositoryAdapterChain _adapterChain;

  /// Constructor
  ShellPersistence(this.domain, {bool useDevelopmentMode = false}) {
    _adapterChain = RepositoryAdapterChain();

    // Configure adapter chain based on mode
    if (useDevelopmentMode) {
      // First try development repositories (higher priority)
      _adapterChain.addAdapter(DevelopmentRepositoryAdapter(domain));

      // Then try production repositories
      try {
        _initializeDomainSession();
        _adapterChain
            .addAdapter(ProductionRepositoryAdapter(domain, _domainSession));
      } catch (e) {
        debugPrint('Could not initialize production adapter: $e');
      }
    } else {
      // Production mode: use production repositories first
      try {
        _initializeDomainSession();
        _adapterChain
            .addAdapter(ProductionRepositoryAdapter(domain, _domainSession));
      } catch (e) {
        debugPrint('Could not initialize production adapter: $e');
      }

      // Only fall back to development repositories if explicitly set
      if (const bool.fromEnvironment('ALLOW_DEV_FALLBACK',
          defaultValue: false)) {
        _adapterChain.addAdapter(DevelopmentRepositoryAdapter(domain));
      }
    }
  }

  /// Initialize the domain session
  void _initializeDomainSession() {
    final domainModels = DomainModels(domain);
    _domainSession = DomainSession(domainModels);
  }

  /// Returns true if a domain session exists
  bool get hasDomainSession => _domainSession != null;

  /// Gets the domain session, creating one if necessary
  DomainSession getDomainSession() {
    // Return existing session if available
    if (_domainSession != null) {
      return _domainSession!;
    }

    // Create domain models and session
    _initializeDomainSession();
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

  /// Save an entity to the repository
  Future<bool> saveEntity(
      String conceptCode, Map<String, dynamic> entityData) async {
    try {
      // Find the concept in the domain
      final concept = findConcept(conceptCode);

      // Get repository for this concept
      final repository = _adapterChain.getRepository(conceptCode, concept);
      if (repository == null) {
        return false;
      }

      // Set ID if not present
      final id = entityData['id'] ??
          '${conceptCode}-${DateTime.now().millisecondsSinceEpoch}';
      entityData['id'] = id;

      // Save using the appropriate repository
      return await repository.save(id, entityData);
    } catch (e) {
      debugPrint('Error saving entity: $e');
      return false;
    }
  }

  /// Load entities from the repository
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) async {
    try {
      // Find the concept in the domain
      final concept = findConcept(conceptCode);

      // Get repository for this concept from the adapter chain
      final repository = _adapterChain.getRepository(conceptCode, concept);
      if (repository == null) return [];

      // Return entities using the appropriate repository implementation
      return await repository.findAll();
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

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import '../extensions/one_application_persistence_extension.dart';
import '../repositories/serializable_entity_repository.dart';
import '../repositories/serializable_repository_factory.dart';

/// Service for managing domain model persistence
class PersistenceService {
  /// The application instance
  final OneApplication _app;

  /// The repository factory
  late final Future<SerializableRepositoryFactory> _repositoryFactory;

  /// Constructor
  PersistenceService(this._app) {
    _repositoryFactory = _app.getRepositoryFactory();
  }

  /// Save the current state of all domain models
  Future<bool> saveAllDomainModels() async {
    return _app.saveAllDomainModels();
  }

  /// Load all domain models from storage
  Future<bool> loadAllDomainModels() async {
    return _app.loadAllDomainModels();
  }

  /// Save a specific domain model
  Future<bool> saveDomainModel(Domain domain, Model model) async {
    return _app.saveDomainModel(domain, model);
  }

  /// Load a specific domain model
  Future<bool> loadDomainModel(Domain domain, Model model) async {
    return _app.loadDomainModel(domain, model);
  }

  /// Get a repository for a specific concept
  Future<SerializableEntityRepository<T>>
  getRepository<T extends Entity<dynamic>>({
    required Concept concept,
    required Domain domain,
    required Model model,
  }) async {
    final factory = await _repositoryFactory;
    return factory.getRepository<T>(
      concept: concept,
      domain: domain,
      model: model,
    );
  }

  /// Example of how to use the repository for a specific concept
  Future<List<T>> loadEntitiesForConcept<T extends Entity<dynamic>>(
    Concept concept,
    Domain domain,
    Model model,
  ) async {
    final repository = await getRepository<T>(
      concept: concept,
      domain: domain,
      model: model,
    );

    return repository.findAll();
  }

  /// Save an entity
  Future<bool> saveEntity<T extends Entity<dynamic>>(
    T entity,
    Concept concept,
    Domain domain,
    Model model,
  ) async {
    final repository = await getRepository<T>(
      concept: concept,
      domain: domain,
      model: model,
    );

    return repository.save(entity);
  }

  /// Create entity auto-save scheduler that periodically saves all domain models
  static Future<void> setupAutoSave(
    OneApplication app, {
    Duration interval = const Duration(minutes: 5),
  }) async {
    final service = PersistenceService(app);

    // Save initial state
    await service.saveAllDomainModels();

    // Set up periodic save
    Future.delayed(interval, () async {
      await service.saveAllDomainModels();
      await setupAutoSave(app, interval: interval);
    });
  }
}

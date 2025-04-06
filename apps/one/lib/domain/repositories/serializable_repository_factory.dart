import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'serializable_entity_repository.dart';

/// Factory for creating serializable repositories for entities
class SerializableRepositoryFactory {
  /// The shared preferences instance
  final SharedPreferences _prefs;

  /// The application instance
  final OneApplication _app;

  /// Cache of repositories to avoid creating multiple for the same concept
  final Map<String, dynamic> _repositoryCache = {};

  /// Constructor
  SerializableRepositoryFactory({
    required SharedPreferences prefs,
    required OneApplication app,
  }) : _prefs = prefs,
       _app = app;

  /// Get a repository for a specific concept
  SerializableEntityRepository<T> getRepository<T extends Entity<dynamic>>({
    required Concept concept,
    required Domain domain,
    required Model model,
  }) {
    final String key = '${domain.code}_${model.code}_${concept.code}';

    if (!_repositoryCache.containsKey(key)) {
      _repositoryCache[key] = SerializableEntityRepository<T>(
        prefs: _prefs,
        concept: concept,
        domain: domain,
        model: model,
        app: _app,
      );
    }

    return _repositoryCache[key] as SerializableEntityRepository<T>;
  }

  /// Create a repository directly for a specific concept
  static Future<SerializableEntityRepository<T>>
  create<T extends Entity<dynamic>>({
    required Concept concept,
    required Domain domain,
    required Model model,
    required OneApplication app,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    return SerializableEntityRepository<T>(
      prefs: prefs,
      concept: concept,
      domain: domain,
      model: model,
      app: app,
    );
  }
}

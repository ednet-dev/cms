import 'package:ednet_core/ednet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'serializable_entity_repository.dart';

/// Factory for creating serializable repositories
class SerializableRepositoryFactory {
  /// SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// Constructor
  SerializableRepositoryFactory(this.sharedPreferences);

  /// Get a repository for a specific concept
  SerializableEntityRepository<T> getRepository<T extends Entity<T>>({
    required Concept concept,
    required Domain domain,
    required Model model,
  }) {
    // Create and return a repository
    return SerializableEntityRepository<T>(
      sharedPreferences,
      concept: concept,
      domain: domain,
      model: model,
    );
  }
}

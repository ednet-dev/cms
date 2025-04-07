import 'package:ednet_core/ednet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/serializable_repository_factory.dart';

/// Extension that adds persistence capabilities to OneApplication
extension OneApplicationPersistenceExtension on Object {
  /// Get a repository factory for OneApplication
  Future<SerializableRepositoryFactory> getRepositoryFactory() async {
    // Create a SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Create and return a repository factory
    return SerializableRepositoryFactory(prefs);
  }

  /// Save all domain models
  Future<bool> saveAllDomainModels() async {
    // In a real implementation, this would iterate through domains and models
    return true;
  }

  /// Load all domain models
  Future<bool> loadAllDomainModels() async {
    // In a real implementation, this would iterate through domains and models
    return true;
  }

  /// Save a specific domain model
  Future<bool> saveDomainModel(Domain domain, Model model) async {
    // In a real implementation, this would serialize and save the model
    return true;
  }

  /// Load a specific domain model
  Future<bool> loadDomainModel(Domain domain, Model model) async {
    // In a real implementation, this would load and deserialize the model
    return true;
  }
}

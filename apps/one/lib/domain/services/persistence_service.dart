import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/foundation.dart';

/// Service for managing domain model persistence
class PersistenceService {
  /// The application instance
  final IOneApplication _app;

  /// Constructor
  PersistenceService(this._app);

  /// Save the current state of all domain models
  Future<bool> saveAllDomainModels() async {
    bool success = true;

    try {
      // Save each domain and its models
      for (final domain in _app.domains) {
        for (final model in domain.models) {
          final result = await saveDomainModel(domain, model);
          success = success && result;
        }
      }
    } catch (e) {
      debugPrint('Error saving all domain models: $e');
      success = false;
    }

    return success;
  }

  /// Load all domain models from storage
  Future<bool> loadAllDomainModels() async {
    bool success = true;

    try {
      // Load each domain and its models
      for (final domain in _app.domains) {
        for (final model in domain.models) {
          final result = await loadDomainModel(domain, model);
          success = success && result;
        }
      }
    } catch (e) {
      debugPrint('Error loading all domain models: $e');
      success = false;
    }

    return success;
  }

  /// Save a specific domain model
  Future<bool> saveDomainModel(Domain domain, Model model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getModelKey(domain, model);

      // Convert domain model to JSON
      final modelData = _modelToJson(domain, model);
      final jsonString = jsonEncode(modelData);

      return await prefs.setString(key, jsonString);
    } catch (e) {
      debugPrint('Error saving domain model: $e');
      return false;
    }
  }

  /// Load a specific domain model
  Future<bool> loadDomainModel(Domain domain, Model model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getModelKey(domain, model);

      final jsonString = prefs.getString(key);
      if (jsonString == null) return false;

      // Parse and load model data
      final modelData = jsonDecode(jsonString) as Map<String, dynamic>;
      _updateModelFromJson(domain, model, modelData);

      return true;
    } catch (e) {
      debugPrint('Error loading domain model: $e');
      return false;
    }
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

  /// Save a configuration object to shared preferences
  Future<bool> saveConfiguration(String key, dynamic configData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (configData is String) {
        return await prefs.setString('ednet_config_$key', configData);
      } else {
        final jsonData = jsonEncode(configData);
        return await prefs.setString('ednet_config_$key', jsonData);
      }
    } catch (e) {
      print('Error saving configuration: $e');
      return false;
    }
  }

  /// Load a configuration object from shared preferences
  Future<String?> loadConfiguration(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('ednet_config_$key');
    } catch (e) {
      print('Error loading configuration: $e');
      return null;
    }
  }

  // Helper methods

  /// Generate a key for storing the model
  String _getModelKey(Domain domain, Model model) {
    return 'ednet_model_${domain.code}_${model.code}';
  }

  /// Convert a model to JSON representation
  Map<String, dynamic> _modelToJson(Domain domain, Model model) {
    // This is a simplified representation
    final modelData = <String, dynamic>{
      'code': model.code,
      'description': model.description,
      'concepts': <Map<String, dynamic>>[],
    };

    // Add concepts
    for (final concept in model.concepts) {
      final conceptData = <String, dynamic>{
        'code': concept.code,
        'description': concept.description,
        'attributes': <Map<String, dynamic>>[],
      };

      // Add attributes
      for (final attribute in concept.attributes) {
        conceptData['attributes'].add({
          'code': attribute.code,
          'description': attribute.description,
          'type': attribute.type?.code,
          'required': attribute.required,
        });
      }

      modelData['concepts'].add(conceptData);
    }

    return modelData;
  }

  /// Update a model from JSON data
  void _updateModelFromJson(
    Domain domain,
    Model model,
    Map<String, dynamic> data,
  ) {
    // This would be a more complex implementation in a real app
    // For now, we'll just handle the very basics

    // Update model properties
    if (data.containsKey('description')) {
      model.description = data['description'];
    }

    // Process concepts if available
    if (data.containsKey('concepts') && data['concepts'] is List) {
      // Implementation would depend on specific requirements
    }
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

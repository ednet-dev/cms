import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'persistence_service.dart';

/// Configuration for a model instance
/// TODO: use ednet_core for modeling
class ModelInstanceConfig {
  /// Unique identifier for this configuration
  final String id;

  /// Display name of the configuration
  final String name;

  /// Description of what this configuration does
  final String description;

  /// Domain to use
  final String domainCode;

  /// Model to use
  final String modelCode;

  /// External data source type (API, file, etc.)
  final String sourceType;

  /// URL or path to the data source
  final String sourceLocation;

  /// Authentication if needed
  final Map<String, String> authentication;

  /// Field mappings from external data to model
  final List<FieldMapping> mappings;

  /// Constructor
  ModelInstanceConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.domainCode,
    required this.modelCode,
    required this.sourceType,
    required this.sourceLocation,
    this.authentication = const {},
    this.mappings = const [],
  });

  /// Create a configuration from JSON
  factory ModelInstanceConfig.fromJson(Map<String, dynamic> json) {
    return ModelInstanceConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      domainCode: json['domainCode'] as String,
      modelCode: json['modelCode'] as String,
      sourceType: json['sourceType'] as String,
      sourceLocation: json['sourceLocation'] as String,
      authentication: Map<String, String>.from(json['authentication'] as Map),
      mappings: (json['mappings'] as List)
          .map((m) => FieldMapping.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert configuration to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'domainCode': domainCode,
      'modelCode': modelCode,
      'sourceType': sourceType,
      'sourceLocation': sourceLocation,
      'authentication': authentication,
      'mappings': mappings.map((m) => m.toJson()).toList(),
    };
  }
}

/// Field mapping between external data source and domain model
class FieldMapping {
  /// Field name in the source data
  final String sourceField;

  /// Field name in the target model
  final String targetField;

  /// Optional transformation to apply
  final String? transformation;

  /// Constructor
  const FieldMapping({
    required this.sourceField,
    required this.targetField,
    this.transformation,
  });

  /// Create from JSON
  factory FieldMapping.fromJson(Map<String, dynamic> json) {
    return FieldMapping(
      sourceField: json['sourceField'] as String,
      targetField: json['targetField'] as String,
      transformation: json['transformation'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceField': sourceField,
      'targetField': targetField,
      'transformation': transformation,
    };
  }
}

/// Result of executing a model instance
class ModelInstanceResult {
  /// Whether the operation was successful
  final bool success;

  /// Data returned from the operation
  final dynamic data;

  /// Error message if unsuccessful
  final String? error;

  /// Constructor
  const ModelInstanceResult({required this.success, this.data, this.error});

  /// Create a success result
  factory ModelInstanceResult.success(dynamic data) {
    return ModelInstanceResult(success: true, data: data);
  }

  /// Create an error result
  factory ModelInstanceResult.error(String errorMessage) {
    return ModelInstanceResult(success: false, error: errorMessage);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data, 'error': error};
  }
}

/// Service for managing model instances
class ModelInstanceService {
  /// Reference to the persistence service
  final PersistenceService _persistenceService;

  /// Storage of available configurations
  final List<ModelInstanceConfig> _configurations = [];

  /// Constructor
  ModelInstanceService(this._persistenceService);

  /// Get all available configurations
  List<ModelInstanceConfig> get allConfigurations => _configurations;

  /// Load all configurations from storage
  Future<bool> loadConfigurations() async {
    try {
      final configsJson = await _persistenceService.loadConfiguration(
        'model_instances',
      );
      if (configsJson == null) return false;

      final List<dynamic> configsData = jsonDecode(configsJson);

      _configurations.clear();
      for (final configData in configsData) {
        _configurations.add(
          ModelInstanceConfig.fromJson(configData as Map<String, dynamic>),
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error loading configurations: $e');
      return false;
    }
  }

  /// Save all configurations to storage
  Future<bool> saveConfigurations() async {
    try {
      final configsData = _configurations.map((c) => c.toJson()).toList();
      final configsJson = jsonEncode(configsData);

      return await _persistenceService.saveConfiguration(
        'model_instances',
        configsJson,
      );
    } catch (e) {
      debugPrint('Error saving configurations: $e');
      return false;
    }
  }

  /// Add a new configuration
  Future<bool> addConfiguration(ModelInstanceConfig config) async {
    _configurations.add(config);
    return await saveConfigurations();
  }

  /// Update an existing configuration
  Future<bool> updateConfiguration(ModelInstanceConfig config) async {
    final index = _configurations.indexWhere((c) => c.id == config.id);
    if (index < 0) return false;

    _configurations[index] = config;
    return await saveConfigurations();
  }

  /// Delete a configuration
  Future<bool> deleteConfiguration(String configId) async {
    final initialCount = _configurations.length;
    _configurations.removeWhere((c) => c.id == configId);
    final removed = initialCount > _configurations.length;

    if (removed) {
      return await saveConfigurations();
    }
    return false;
  }

  /// Execute a model instance with the given configuration
  Future<ModelInstanceResult> executeModelInstance(String configId) async {
    try {
      final config = _configurations.firstWhere(
        (c) => c.id == configId,
        orElse: () => throw Exception('Configuration not found'),
      );

      // This would normally fetch data from the source
      // For now, we'll return a mock result
      return ModelInstanceResult.success({
        'status': 'success',
        'message': 'Model instance executed successfully',
        'config': config.toJson(),
      });
    } catch (e) {
      return ModelInstanceResult.error(e.toString());
    }
  }
}

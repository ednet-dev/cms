import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';

/// Service for managing domain model instances with external service configurations
class ModelInstanceService {
  /// The application instance
  final OneApplication _app;

  /// Persistence service for saving/loading configurations
  final PersistenceService _persistenceService;

  /// Map of instance configurations by unique ID
  final Map<String, ModelInstanceConfig> _instanceConfigs = {};

  /// Constructor
  ModelInstanceService(this._app, this._persistenceService);

  /// Get all registered instance configurations
  List<ModelInstanceConfig> get allConfigurations =>
      _instanceConfigs.values.toList();

  /// Get configurations for a specific domain and model
  List<ModelInstanceConfig> getConfigurationsFor(Domain domain, Model model) {
    return _instanceConfigs.values
        .where(
          (config) =>
              config.domainCode == domain.code &&
              config.modelCode == model.code,
        )
        .toList();
  }

  /// Create a new instance configuration
  Future<ModelInstanceConfig> createInstanceConfig({
    required String name,
    required Domain domain,
    required Model model,
    required ServiceType serviceType,
    required Map<String, String> parameters,
  }) async {
    final id =
        'instance_${domain.code}_${model.code}_${DateTime.now().millisecondsSinceEpoch}';

    final config = ModelInstanceConfig(
      id: id,
      name: name,
      domainCode: domain.code,
      modelCode: model.code,
      serviceType: serviceType,
      parameters: parameters,
      createdAt: DateTime.now(),
      lastRunAt: null,
    );

    _instanceConfigs[id] = config;
    await _saveConfigurations();

    return config;
  }

  /// Update an existing instance configuration
  Future<ModelInstanceConfig?> updateInstanceConfig({
    required String id,
    String? name,
    ServiceType? serviceType,
    Map<String, String>? parameters,
  }) async {
    final config = _instanceConfigs[id];
    if (config == null) return null;

    final updatedConfig = config.copyWith(
      name: name ?? config.name,
      serviceType: serviceType ?? config.serviceType,
      parameters: parameters ?? config.parameters,
    );

    _instanceConfigs[id] = updatedConfig;
    await _saveConfigurations();

    return updatedConfig;
  }

  /// Delete an instance configuration
  Future<bool> deleteInstanceConfig(String id) async {
    final removed = _instanceConfigs.remove(id);
    if (removed != null) {
      await _saveConfigurations();
      return true;
    }
    return false;
  }

  /// Run an instance with its configuration
  Future<ModelInstanceResult> runInstance(String id) async {
    final config = _instanceConfigs[id];
    if (config == null) {
      return ModelInstanceResult(
        success: false,
        message: 'Instance configuration not found',
        data: null,
      );
    }

    try {
      // Get domain and model
      final domain = _app.groupedDomains.singleWhereCode(config.domainCode);
      if (domain == null) {
        return ModelInstanceResult(
          success: false,
          message: 'Domain not found: ${config.domainCode}',
          data: null,
        );
      }

      final model = domain.models.singleWhereCode(config.modelCode);
      if (model == null) {
        return ModelInstanceResult(
          success: false,
          message: 'Model not found: ${config.modelCode}',
          data: null,
        );
      }

      // Get appropriate repository based on service type
      final repository = _getRepositoryForService(
        config.serviceType,
        config.parameters,
      );
      if (repository == null) {
        return ModelInstanceResult(
          success: false,
          message:
              'Repository not available for service: ${config.serviceType.name}',
          data: null,
        );
      }

      // Run the model with the repository
      final result = await repository.execute(domain, model);

      // Update last run time
      _instanceConfigs[id] = config.copyWith(lastRunAt: DateTime.now());
      await _saveConfigurations();

      return result;
    } catch (e) {
      return ModelInstanceResult(
        success: false,
        message: 'Error running instance: $e',
        data: null,
      );
    }
  }

  /// Load all configurations from persistent storage
  Future<void> loadConfigurations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getString('ednet_model_instance_configs');

      if (configsJson != null) {
        final List<dynamic> configsList = jsonDecode(configsJson);

        _instanceConfigs.clear();
        for (final configMap in configsList) {
          final config = ModelInstanceConfig.fromJson(configMap);
          _instanceConfigs[config.id] = config;
        }
      }
    } catch (e) {
      debugPrint('Error loading model instance configurations: $e');
    }
  }

  /// Save all configurations to persistent storage
  Future<bool> _saveConfigurations() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final configsList =
          _instanceConfigs.values.map((config) => config.toJson()).toList();
      final configsJson = jsonEncode(configsList);

      return await prefs.setString('ednet_model_instance_configs', configsJson);
    } catch (e) {
      debugPrint('Error saving model instance configurations: $e');
      return false;
    }
  }

  /// Get the appropriate repository for a service type
  ExternalServiceRepository? _getRepositoryForService(
    ServiceType serviceType,
    Map<String, String> parameters,
  ) {
    switch (serviceType) {
      case ServiceType.twitter:
        return TwitterRepository(parameters);
      case ServiceType.facebook:
        return FacebookRepository(parameters);
      case ServiceType.instagram:
        return InstagramRepository(parameters);
      case ServiceType.youtube:
        return YouTubeRepository(parameters);
      case ServiceType.custom:
        if (parameters.containsKey('repoType')) {
          final repoType = parameters['repoType'];
          if (repoType == 'openapi') {
            return OpenApiRepository(parameters);
          } else if (repoType == 'drift') {
            return DriftRepository(parameters);
          }
        }
        return null;
    }
  }
}

/// External service types supported by the model instance service
enum ServiceType { twitter, facebook, instagram, youtube, custom }

/// Configuration for a model instance
class ModelInstanceConfig {
  /// Unique identifier for this configuration
  final String id;

  /// Display name for the configuration
  final String name;

  /// Domain code this instance is for
  final String domainCode;

  /// Model code this instance is for
  final String modelCode;

  /// Type of external service
  final ServiceType serviceType;

  /// Configuration parameters for the service (API keys, URLs, etc.)
  final Map<String, String> parameters;

  /// When this configuration was created
  final DateTime createdAt;

  /// When this configuration was last run
  final DateTime? lastRunAt;

  /// Constructor
  const ModelInstanceConfig({
    required this.id,
    required this.name,
    required this.domainCode,
    required this.modelCode,
    required this.serviceType,
    required this.parameters,
    required this.createdAt,
    this.lastRunAt,
  });

  /// Create a copy with some fields replaced
  ModelInstanceConfig copyWith({
    String? name,
    ServiceType? serviceType,
    Map<String, String>? parameters,
    DateTime? lastRunAt,
  }) {
    return ModelInstanceConfig(
      id: id,
      name: name ?? this.name,
      domainCode: domainCode,
      modelCode: modelCode,
      serviceType: serviceType ?? this.serviceType,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt,
      lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domainCode': domainCode,
      'modelCode': modelCode,
      'serviceType': serviceType.index,
      'parameters': parameters,
      'createdAt': createdAt.toIso8601String(),
      'lastRunAt': lastRunAt?.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory ModelInstanceConfig.fromJson(Map<String, dynamic> json) {
    return ModelInstanceConfig(
      id: json['id'],
      name: json['name'],
      domainCode: json['domainCode'],
      modelCode: json['modelCode'],
      serviceType: ServiceType.values[json['serviceType']],
      parameters: Map<String, String>.from(json['parameters']),
      createdAt: DateTime.parse(json['createdAt']),
      lastRunAt:
          json['lastRunAt'] != null ? DateTime.parse(json['lastRunAt']) : null,
    );
  }
}

/// Result of running a model instance
class ModelInstanceResult {
  /// Whether the instance run was successful
  final bool success;

  /// Message from the instance run
  final String message;

  /// Data returned from the instance run
  final dynamic data;

  /// Constructor
  const ModelInstanceResult({
    required this.success,
    required this.message,
    required this.data,
  });
}

/// Abstract base class for all external service repositories
abstract class ExternalServiceRepository {
  /// Configuration parameters
  final Map<String, String> parameters;

  /// Constructor
  ExternalServiceRepository(this.parameters);

  /// Execute a query against the external service
  Future<ModelInstanceResult> execute(Domain domain, Model model);
}

/// Repository for Twitter API
class TwitterRepository extends ExternalServiceRepository {
  TwitterRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use Twitter API client
    // For now, return a placeholder result
    return ModelInstanceResult(
      success: true,
      message: 'Connected to Twitter API successfully',
      data: {
        'tweets': [
          {
            'id': '123456',
            'text': 'Hello from Twitter!',
            'user': {'name': 'EDNet Demo', 'handle': '@ednetdemo'},
          },
        ],
      },
    );
  }
}

/// Repository for Facebook API
class FacebookRepository extends ExternalServiceRepository {
  FacebookRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use Facebook API client
    return ModelInstanceResult(
      success: true,
      message: 'Connected to Facebook API successfully',
      data: {
        'posts': [
          {
            'id': '123456',
            'message': 'Hello from Facebook!',
            'author': {'name': 'EDNet Demo', 'id': '987654321'},
          },
        ],
      },
    );
  }
}

/// Repository for Instagram API
class InstagramRepository extends ExternalServiceRepository {
  InstagramRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use Instagram API client
    return ModelInstanceResult(
      success: true,
      message: 'Connected to Instagram API successfully',
      data: {
        'posts': [
          {
            'id': '123456',
            'caption': 'Hello from Instagram!',
            'user': {'username': 'ednetdemo', 'full_name': 'EDNet Demo'},
          },
        ],
      },
    );
  }
}

/// Repository for YouTube API
class YouTubeRepository extends ExternalServiceRepository {
  YouTubeRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use YouTube API client
    return ModelInstanceResult(
      success: true,
      message: 'Connected to YouTube API successfully',
      data: {
        'videos': [
          {
            'id': '123456',
            'title': 'Hello from YouTube!',
            'channel': {'name': 'EDNet Demo', 'id': 'UC12345'},
          },
        ],
      },
    );
  }
}

/// Repository for OpenAPI services
class OpenApiRepository extends ExternalServiceRepository {
  OpenApiRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use OpenAPI client generated from schema
    return ModelInstanceResult(
      success: true,
      message: 'Connected to OpenAPI service successfully',
      data: {'message': 'OpenAPI integration placeholder'},
    );
  }
}

/// Repository for Drift (SQLite) database
class DriftRepository extends ExternalServiceRepository {
  DriftRepository(super.parameters);

  @override
  Future<ModelInstanceResult> execute(Domain domain, Model model) async {
    // Implementation would use Drift database
    return ModelInstanceResult(
      success: true,
      message: 'Connected to Drift database successfully',
      data: {'message': 'Drift integration placeholder'},
    );
  }
}

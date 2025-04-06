import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import '../repositories/serializable_repository_factory.dart';

/// Extension for OneApplication that adds persistence capabilities
extension OneApplicationPersistence on OneApplication {
  /// Key prefix for domain model storage
  static const String _domainModelKeyPrefix = 'ednet_domain_model_';

  /// Key for the domains index
  static const String _domainsIndexKey = 'ednet_domains_index';

  /// Get a serializable repository factory
  Future<SerializableRepositoryFactory> getRepositoryFactory() async {
    final prefs = await SharedPreferences.getInstance();
    return SerializableRepositoryFactory(prefs: prefs, app: this);
  }

  /// Save a specific domain model to persistent storage
  Future<bool> saveDomainModel(Domain domain, Model model) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Build the domain model ID
      final domainCode = domain.code.toLowerCase();
      final modelCode = model.code.toLowerCase();
      final domainModelId = '${domainCode}_${modelCode}';

      // Find the domain model
      final domainModel = _getDomainModel(domain, model);
      if (domainModel == null) {
        throw Exception('Domain model not found: $domainModelId');
      }

      // Check if the domain model can be serialized
      if (!_canSerializeDomainModel(domainModel)) {
        throw Exception('Domain model cannot be serialized: $domainModelId');
      }

      // Serialize the domain model
      final modelState = _serializeDomainModel(domainModel);
      final jsonString = jsonEncode(modelState);

      // Save the domain model
      final result = await prefs.setString(
        '$_domainModelKeyPrefix$domainModelId',
        jsonString,
      );

      // Update the domains index
      if (result) {
        final List<String> index = prefs.getStringList(_domainsIndexKey) ?? [];
        if (!index.contains(domainModelId)) {
          index.add(domainModelId);
          await prefs.setStringList(_domainsIndexKey, index);
        }
      }

      return result;
    } catch (e) {
      print('Error saving domain model: $e');
      return false;
    }
  }

  /// Save all domain models to persistent storage
  Future<bool> saveAllDomainModels() async {
    bool success = true;

    // Save each domain separately
    for (final domain in groupedDomains) {
      for (final model in domain.models) {
        final result = await saveDomainModel(domain, model);
        success = success && result;
      }
    }

    return success;
  }

  /// Load a specific domain model from persistent storage
  Future<bool> loadDomainModel(Domain domain, Model model) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Build the domain model ID
      final domainCode = domain.code.toLowerCase();
      final modelCode = model.code.toLowerCase();
      final domainModelId = '${domainCode}_${modelCode}';

      // Check if the domain model exists in storage
      final jsonString = prefs.getString(
        '$_domainModelKeyPrefix$domainModelId',
      );
      if (jsonString == null) {
        print('Domain model not found in storage: $domainModelId');
        return false;
      }

      // Find the domain model in the application
      final domainModel = _getDomainModel(domain, model);
      if (domainModel == null) {
        throw Exception(
          'Domain model not found in application: $domainModelId',
        );
      }

      // Deserialize the domain model
      final modelState = jsonDecode(jsonString) as Map<String, dynamic>;

      // Load the model state into the domain model
      return _deserializeDomainModel(domainModel, modelState);
    } catch (e) {
      print('Error loading domain model: $e');
      return false;
    }
  }

  /// Load all domain models from persistent storage
  Future<bool> loadAllDomainModels() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get the domains index
      final List<String> index = prefs.getStringList(_domainsIndexKey) ?? [];
      if (index.isEmpty) {
        print('No domain models found in storage');
        return false;
      }

      bool success = true;

      // Load each domain model
      for (final domainModelId in index) {
        final parts = domainModelId.split('_');
        if (parts.length < 2) continue;

        final domainCode = parts[0];
        final modelCode = parts[1];

        // Find the domain and model
        Domain? domain;
        Model? model;

        try {
          domain = groupedDomains.firstWhere(
            (d) => d.code.toLowerCase() == domainCode,
          );
          model = domain.models.firstWhere(
            (m) => m.code.toLowerCase() == modelCode,
          );

          final result = await loadDomainModel(domain, model);
          success = success && result;
        } catch (e) {
          print('Error finding domain model: $e');
          success = false;
        }
      }

      return success;
    } catch (e) {
      print('Error loading all domain models: $e');
      return false;
    }
  }

  /// Check if a domain model can be serialized
  bool _canSerializeDomainModel(dynamic domainModel) {
    // Check if the domain model has a toJson method
    try {
      final methods = domainModel.runtimeType.toString();
      return true; // For now, assume all models can be serialized
    } catch (e) {
      return false;
    }
  }

  /// Serialize a domain model to a Map
  Map<String, dynamic> _serializeDomainModel(dynamic domainModel) {
    final Map<String, dynamic> result = {};

    // If the domain model has a toJson method, use it
    if (domainModel is Map<String, dynamic> Function()) {
      return domainModel();
    }

    // Get all entry concepts and their entities
    try {
      // Reflect on the domain model to extract entities
      final entryConcepts = _getEntryConcepts(domainModel);

      for (final concept in entryConcepts) {
        final entities = domainModel.entities(concept.code);
        if (entities == null || entities.isEmpty) continue;

        final conceptEntities = <Map<String, dynamic>>[];

        for (final entity in entities) {
          final Map<String, dynamic> entityMap = {'oid': entity.oid.toString()};

          // Add all attributes
          for (final attribute in concept.attributes) {
            try {
              var value = entity.getAttribute(attribute.code);

              // Handle special types
              if (value is DateTime) {
                value = value.toIso8601String();
              }

              entityMap[attribute.code] = value;
            } catch (e) {
              // Skip attributes that aren't found
            }
          }

          conceptEntities.add(entityMap);
        }

        result[concept.code] = conceptEntities;
      }
    } catch (e) {
      print('Error serializing domain model: $e');
    }

    return result;
  }

  /// Deserialize a Map into a domain model
  bool _deserializeDomainModel(dynamic domainModel, Map<String, dynamic> data) {
    try {
      // Get all entry concepts
      final entryConcepts = _getEntryConcepts(domainModel);

      // Process each concept in the data
      for (final conceptCode in data.keys) {
        // Find the concept
        final concept = entryConcepts.firstWhere(
          (c) => c.code == conceptCode,
          orElse: () => throw Exception('Concept not found: $conceptCode'),
        );

        // Clear existing entities for this concept
        // Note: This is destructive - in a real app, consider a merging strategy
        // domainModel.clearEntities(conceptCode);

        // Load the entities
        final entities = data[conceptCode] as List<dynamic>;
        for (final entityMap in entities) {
          final map = entityMap as Map<String, dynamic>;

          // Create the entity
          Entity? entity;
          if (map.containsKey('oid')) {
            final oid = map['oid'];
            // Try to find existing entity
            try {
              final existingEntities = domainModel.entities(conceptCode);
              entity = existingEntities.firstWhere(
                (e) => e.oid.toString() == oid.toString(),
              );
            } catch (e) {
              // Create new if not found
              entity = domainModel.newEntity(conceptCode);
            }
          } else {
            entity = domainModel.newEntity(conceptCode);
          }

          if (entity == null) continue;

          // Set attributes
          for (final attribute in concept.attributes) {
            if (map.containsKey(attribute.code)) {
              var value = map[attribute.code];

              // Handle type conversions
              final type = attribute.type?.toString().toLowerCase();
              if (type == 'datetime' && value is String) {
                value = DateTime.parse(value);
              } else if (type == 'int' && value is String) {
                value = int.parse(value);
              } else if (type == 'double' && value is String) {
                value = double.parse(value);
              } else if (type == 'bool' && value is String) {
                value = value.toLowerCase() == 'true';
              }

              entity.setAttribute(attribute.code, value);
            }
          }
        }
      }

      // Save the domain model to persist changes
      domainModel.save();

      return true;
    } catch (e) {
      print('Error deserializing domain model: $e');
      return false;
    }
  }

  /// Get all entry concepts for a domain model
  List<Concept> _getEntryConcepts(dynamic domainModel) {
    final List<Concept> result = [];

    // Try to extract from the model's metadata
    try {
      final codeModel = domainModel.model as Model;
      return codeModel.concepts.where((c) => c.entry).toList();
    } catch (e) {
      // If that fails, try to enumerate concepts directly
      try {
        final concepts = domainModel.concepts;
        for (final concept in concepts) {
          if (concept.entry) {
            result.add(concept);
          }
        }
      } catch (e) {
        print('Error getting entry concepts: $e');
      }
    }

    return result;
  }

  /// Helper method to get the domain model
  dynamic _getDomainModel(Domain domain, Model model) {
    try {
      // Access the domain from app's groupedDomains
      final targetDomain = groupedDomains.firstWhere(
        (d) => d.code == domain.code,
        orElse: () => throw Exception('Domain not found: ${domain.code}'),
      );

      // Find the model within this domain
      final domainModel = targetDomain.models.firstWhere(
        (m) => m.code == model.code,
        orElse:
            () =>
                throw Exception(
                  'Model not found: ${model.code} in domain ${domain.code}',
                ),
      );

      return domainModel;
    } catch (e) {
      print('Error getting domain model for ${domain.code}_${model.code}: $e');
      return null;
    }
  }
}

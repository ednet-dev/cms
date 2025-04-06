import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';

/// A repository that can serialize and deserialize entities for a specific concept
class SerializableEntityRepository<T extends Entity<dynamic>> {
  /// The shared preferences instance for persistent storage
  final SharedPreferences _prefs;

  /// The concept this repository manages
  final Concept _concept;

  /// The domain containing the concept
  final Domain _domain;

  /// The model containing the concept
  final Model _model;

  /// The application instance
  final OneApplication _app;

  /// Constructor
  SerializableEntityRepository({
    required SharedPreferences prefs,
    required Concept concept,
    required Domain domain,
    required Model model,
    required OneApplication app,
  }) : _prefs = prefs,
       _concept = concept,
       _domain = domain,
       _model = model,
       _app = app;

  /// Key prefix for storing entities
  String get _keyPrefix =>
      'entity_${_domain.code.toLowerCase()}_${_model.code.toLowerCase()}_${_concept.code.toLowerCase()}';

  /// Key for storing the index of entity IDs
  String get _indexKey => '${_keyPrefix}_index';

  /// Get entity key for a specific ID
  String _getEntityKey(int oid) => '${_keyPrefix}_$oid';

  /// Save an entity to storage
  Future<bool> save(T entity) async {
    try {
      // Get the serialized form of the entity
      final Map<String, dynamic> entityMap = _serializeEntity(entity);
      final String jsonString = jsonEncode(entityMap);

      // Save to SharedPreferences
      final oid = entity.oid;
      if (oid == null) {
        throw ArgumentError('Entity must have an OID to be saved');
      }
      final oidValue = int.parse(oid.toString());

      // Save the entity
      final bool saved = await _prefs.setString(
        _getEntityKey(oidValue),
        jsonString,
      );
      if (!saved) return false;

      // Update the index
      final List<String> index = _getIndex();
      if (!index.contains(oidValue.toString())) {
        index.add(oidValue.toString());
        await _prefs.setStringList(_indexKey, index);
      }

      return true;
    } catch (e) {
      print('Error saving entity: $e');
      return false;
    }
  }

  /// Save multiple entities in a batch
  Future<bool> saveAll(Iterable<T> entities) async {
    bool allSaved = true;
    for (final entity in entities) {
      final success = await save(entity);
      if (!success) allSaved = false;
    }
    return allSaved;
  }

  /// Load an entity by its ID
  Future<T?> findById(int oid) async {
    try {
      final String? jsonString = _prefs.getString(_getEntityKey(oid));
      if (jsonString == null) return null;

      final Map<String, dynamic> entityMap = jsonDecode(jsonString);
      return _deserializeEntity(entityMap);
    } catch (e) {
      print('Error loading entity with ID $oid: $e');
      return null;
    }
  }

  /// Load all entities of this concept
  Future<List<T>> findAll() async {
    final List<String> index = _getIndex();
    final List<T> entities = [];

    for (final idString in index) {
      try {
        final id = int.parse(idString);
        final entity = await findById(id);
        if (entity != null) {
          entities.add(entity);
        }
      } catch (e) {
        print('Error loading entity with ID $idString: $e');
      }
    }

    return entities;
  }

  /// Remove an entity by ID
  Future<bool> remove(int oid) async {
    try {
      // Remove from storage
      final bool removed = await _prefs.remove(_getEntityKey(oid));

      // Update the index
      final List<String> index = _getIndex();
      index.remove(oid.toString());
      await _prefs.setStringList(_indexKey, index);

      return removed;
    } catch (e) {
      print('Error removing entity with ID $oid: $e');
      return false;
    }
  }

  /// Clear all entities for this concept
  Future<bool> clear() async {
    try {
      final List<String> index = _getIndex();

      // Remove all entities
      for (final idString in index) {
        final id = int.parse(idString);
        await _prefs.remove(_getEntityKey(id));
      }

      // Clear the index
      await _prefs.remove(_indexKey);

      return true;
    } catch (e) {
      print('Error clearing entities: $e');
      return false;
    }
  }

  /// Get the index of all entity IDs
  List<String> _getIndex() {
    return _prefs.getStringList(_indexKey) ?? [];
  }

  /// Serialize an entity to a Map
  Map<String, dynamic> _serializeEntity(T entity) {
    final Map<String, dynamic> result = {'oid': entity.oid.toString()};

    // Add all attributes from the concept
    for (final attribute in _concept.attributes) {
      try {
        final value = entity.getAttribute(attribute.code);
        // Handle special types like DateTime which need custom serialization
        if (value is DateTime) {
          result[attribute.code] = value.toIso8601String();
        } else {
          result[attribute.code] = value;
        }
      } catch (e) {
        // Skip attributes that don't exist on this entity
        print(
          'Warning: Attribute ${attribute.code} not found on entity ${entity.oid}',
        );
      }
    }

    return result;
  }

  /// Deserialize a map to an entity
  T? _deserializeEntity(Map<String, dynamic> data) {
    try {
      // Get the domain model
      final domainCode = _domain.code.toLowerCase();
      final modelCode = _model.code.toLowerCase();
      final conceptCode = _concept.code;

      final domainModelId = '${domainCode}_${modelCode}';

      // Find the domain model in the application
      final domainModel = _getDomainModel(_domain, _model);
      if (domainModel == null) {
        throw Exception('Domain model not found: $domainModelId');
      }

      // Create a new entity or get existing if ID is provided
      Entity<dynamic>? entity;
      if (data.containsKey('oid')) {
        final oid = int.parse(data['oid'].toString());
        // Try to find existing entity first
        try {
          final entities = domainModel.entities(conceptCode);
          entity = entities.firstWhere((e) => e.oid == oid);
        } catch (e) {
          // If not found, create a new one
          entity = domainModel.newEntity(conceptCode);
        }
      } else {
        // Create a new entity if no OID
        entity = domainModel.newEntity(conceptCode);
      }

      // If we couldn't create an entity, return null
      if (entity == null) {
        print('Unable to create or find entity');
        return null;
      }

      // Populate the attributes
      for (final attribute in _concept.attributes) {
        if (data.containsKey(attribute.code)) {
          var value = data[attribute.code];

          // Handle special type conversions
          final attributeType = attribute.type?.toString().toLowerCase();
          if (attributeType == 'datetime' && value is String) {
            value = DateTime.parse(value);
          } else if (attributeType == 'int' && value is String) {
            value = int.parse(value);
          } else if (attributeType == 'double' && value is String) {
            value = double.parse(value);
          } else if (attributeType == 'bool' && value is String) {
            value = value.toLowerCase() == 'true';
          }

          entity.setAttribute(attribute.code, value);
        }
      }

      return entity as T;
    } catch (e) {
      print('Error deserializing entity: $e');
      return null;
    }
  }

  /// Helper method to get the domain model
  dynamic _getDomainModel(Domain domain, Model model) {
    try {
      // Access the domain from app's groupedDomains
      final targetDomain = _app.groupedDomains.firstWhere(
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

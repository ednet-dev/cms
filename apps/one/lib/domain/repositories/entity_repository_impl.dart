import 'dart:convert';
import 'package:ednet_core/ednet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entity_repository.dart';

/// Implementation of [SerializableRepository] using in-memory storage
class InMemoryRepository<T extends Entity<dynamic>>
    implements SerializableRepository<T> {
  /// The concept code
  @override
  final String conceptCode;

  /// In-memory storage for entities
  final Map<dynamic, T> _entities = {};

  /// Constructor
  InMemoryRepository(this.conceptCode);

  @override
  Future<T?> findById(dynamic id) async {
    return _entities[id];
  }

  @override
  Future<Iterable<T>> findAll() async {
    return _entities.values;
  }

  @override
  Future<bool> save(T entity) async {
    _entities[entity.oid] = entity;
    return true;
  }

  @override
  Future<bool> saveAll(Iterable<T> entities) async {
    for (final entity in entities) {
      _entities[entity.oid] = entity;
    }
    return true;
  }

  @override
  Future<bool> remove(T entity) {
    return removeById(entity.oid);
  }

  @override
  Future<bool> removeById(dynamic id) async {
    _entities.remove(id);
    return true;
  }

  @override
  Future<bool> clear() async {
    _entities.clear();
    return true;
  }

  @override
  Map<String, dynamic> serialize(T entity) {
    // This would be implemented for each specific entity type
    return {'id': entity.oid};
  }

  @override
  T deserialize(Map<String, dynamic> data) {
    // This would be implemented for each specific entity type
    throw UnimplementedError('Deserialize must be implemented by subclasses');
  }
}

/// Implementation of [SerializableRepository] using SharedPreferences
class EntityRepositoryImpl<T extends Entity<dynamic>>
    implements SerializableRepository<T> {
  /// SharedPreferences instance
  final SharedPreferences _prefs;

  /// The concept code
  @override
  final String conceptCode;

  /// Domain code
  final String _domainCode;

  /// Model code
  final String _modelCode;

  /// Function to deserialize entity
  final T Function(Map<String, dynamic>) _deserializer;

  /// Function to serialize entity
  final Map<String, dynamic> Function(T) _serializer;

  /// Constructor
  EntityRepositoryImpl(
    this._prefs,
    this.conceptCode,
    this._domainCode,
    this._modelCode,
    this._deserializer,
    this._serializer,
  );

  /// Get the key prefix for all entities of this type
  String get _keyPrefix => 'ednet_${_domainCode}_${_modelCode}_$conceptCode';

  /// Get the key for a specific entity
  String _getEntityKey(dynamic id) => '${_keyPrefix}_$id';

  /// Get the key for the index of all entity IDs
  String get _indexKey => '${_keyPrefix}_index';

  @override
  Future<T?> findById(dynamic id) async {
    final key = _getEntityKey(id);
    final data = _prefs.getString(key);
    if (data == null) return null;

    try {
      final entityMap = jsonDecode(data) as Map<String, dynamic>;
      return deserialize(entityMap);
    } catch (e) {
      print('Error deserializing entity: $e');
      return null;
    }
  }

  @override
  Future<Iterable<T>> findAll() async {
    final index = _getIndex();
    final List<T> result = [];

    for (final id in index) {
      final entity = await findById(id);
      if (entity != null) {
        result.add(entity);
      }
    }

    return result;
  }

  @override
  Future<bool> save(T entity) async {
    final key = _getEntityKey(entity.oid);
    final data = serialize(entity);
    final json = jsonEncode(data);

    // Add to the index
    final List<String> index = _getIndex();
    final idString = entity.oid.toString();
    if (!index.contains(idString)) {
      index.add(idString);
      await _prefs.setStringList(_indexKey, index);
    }

    // Save the entity
    return await _prefs.setString(key, json);
  }

  @override
  Future<bool> saveAll(Iterable<T> entities) async {
    bool success = true;
    for (final entity in entities) {
      final result = await save(entity);
      success = success && result;
    }
    return success;
  }

  @override
  Future<bool> remove(T entity) {
    return removeById(entity.oid);
  }

  @override
  Future<bool> removeById(dynamic id) async {
    final key = _getEntityKey(id);
    final List<String> index = _getIndex();
    final idString = id.toString();

    // Remove from index
    if (index.contains(idString)) {
      index.remove(idString);
      await _prefs.setStringList(_indexKey, index);
    }

    // Remove the entity
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    final index = _getIndex();
    bool success = true;

    // Remove all entity entries
    for (final id in index) {
      final result = await _prefs.remove(_getEntityKey(id));
      success = success && result;
    }

    // Clear the index
    final indexResult = await _prefs.remove(_indexKey);
    return success && indexResult;
  }

  @override
  Map<String, dynamic> serialize(T entity) {
    return _serializer(entity);
  }

  @override
  T deserialize(Map<String, dynamic> data) {
    return _deserializer(data);
  }

  /// Get the index of all entity IDs
  List<String> _getIndex() {
    return _prefs.getStringList(_indexKey) ?? [];
  }
}

import 'dart:convert';
import 'package:ednet_core/ednet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entity_repository.dart';

/// Implementation of [SerializableRepository] for domain entities
class SerializableEntityRepository<T extends Entity<T>>
    implements SerializableRepository<T> {
  /// SharedPreferences instance
  final SharedPreferences _sharedPreferences;

  /// Concept for this repository
  final Concept _concept;

  /// Domain for this repository
  final Domain _domain;

  /// Model for this repository
  final Model _model;

  /// Constructor
  SerializableEntityRepository(
    this._sharedPreferences, {
    required Concept concept,
    required Domain domain,
    required Model model,
  }) : _concept = concept,
       _domain = domain,
       _model = model;

  @override
  String get conceptCode => _concept.code;

  /// Get storage key prefix for entities
  String get _keyPrefix =>
      'ednet_${_domain.code}_${_model.code}_${_concept.code}';

  /// Get the key for a specific entity
  String _getEntityKey(dynamic id) => '${_keyPrefix}_$id';

  /// Get the key for the index of all entity IDs
  String get _indexKey => '${_keyPrefix}_index';

  @override
  Future<T?> findById(dynamic id) async {
    final key = _getEntityKey(id);
    final json = _sharedPreferences.getString(key);
    if (json == null) return null;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return deserialize(data);
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
      await _sharedPreferences.setStringList(_indexKey, index);
    }

    // Save the entity
    return await _sharedPreferences.setString(key, json);
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
      await _sharedPreferences.setStringList(_indexKey, index);
    }

    // Remove the entity
    return await _sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() async {
    final index = _getIndex();
    bool success = true;

    // Remove all entity entries
    for (final id in index) {
      final result = await _sharedPreferences.remove(_getEntityKey(id));
      success = success && result;
    }

    // Clear the index
    final indexResult = await _sharedPreferences.remove(_indexKey);
    return success && indexResult;
  }

  @override
  Map<String, dynamic> serialize(T entity) {
    // This is a placeholder implementation
    // In a real app, this would properly serialize the entity
    return {'id': entity.oid.toString(), 'conceptCode': conceptCode};
  }

  @override
  T deserialize(Map<String, dynamic> data) {
    // This is a placeholder implementation
    // In a real app, this would properly deserialize the entity
    throw UnimplementedError('Deserialize must be implemented by subclasses');
  }

  /// Get the index of all entity IDs
  List<String> _getIndex() {
    return _sharedPreferences.getStringList(_indexKey) ?? [];
  }
}

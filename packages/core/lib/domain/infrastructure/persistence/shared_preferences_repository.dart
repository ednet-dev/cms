import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import '../repository.dart';

/// Implementation of [SerializableRepository] using SharedPreferences
abstract class SharedPreferencesRepository<T extends Entity<dynamic>>
    implements SerializableRepository<T> {
  /// The SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// The prefix to use for all keys in SharedPreferences
  final String keyPrefix;

  /// Constructor requiring SharedPreferences instance
  SharedPreferencesRepository(
    this.sharedPreferences, {
    this.keyPrefix = 'ednet_',
  });

  /// Gets the domain and model IDs for key generation
  String get domainAndModelId;

  /// Gets the full key prefix including domain and model info
  String get fullKeyPrefix => '$keyPrefix${domainAndModelId}_$conceptCode';

  /// Gets the key for a specific entity ID
  String _getEntityKey(dynamic id) => '$fullKeyPrefix:$id';

  /// Gets the key for the index of all entity IDs
  String get _indexKey => '${fullKeyPrefix}_index';

  @override
  Future<bool> save(T entity) async {
    final key = _getEntityKey(entity.oid);
    final data = serialize(entity);
    final json = jsonEncode(data);

    // Add to the index
    final List<String> index = await _getIndex();
    final idString = entity.oid.toString();
    if (!index.contains(idString)) {
      index.add(idString);
      await sharedPreferences.setStringList(_indexKey, index);
    }

    // Save the entity
    return await sharedPreferences.setString(key, json);
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
  Future<T?> findById(dynamic id) async {
    final key = _getEntityKey(id);
    final json = sharedPreferences.getString(key);
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
    final index = await _getIndex();
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
  Future<bool> remove(T entity) {
    return removeById(entity.oid);
  }

  @override
  Future<bool> removeById(dynamic id) async {
    final key = _getEntityKey(id);
    final List<String> index = await _getIndex();
    final idString = id.toString();

    // Remove from index
    if (index.contains(idString)) {
      index.remove(idString);
      await sharedPreferences.setStringList(_indexKey, index);
    }

    // Remove the entity
    return await sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() async {
    final index = await _getIndex();
    bool success = true;

    // Remove all entity entries
    for (final id in index) {
      final result = await sharedPreferences.remove(_getEntityKey(id));
      success = success && result;
    }

    // Clear the index
    final indexResult = await sharedPreferences.remove(_indexKey);
    return success && indexResult;
  }

  /// Gets the index of all entity IDs
  Future<List<String>> _getIndex() async {
    return sharedPreferences.getStringList(_indexKey) ?? [];
  }
}

/// Implementation of [DomainModelRepository] using SharedPreferences
class SharedPreferencesDomainModelRepository implements DomainModelRepository {
  /// The SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// The prefix to use for all keys in SharedPreferences
  final String keyPrefix;

  /// Constructor requiring SharedPreferences instance
  SharedPreferencesDomainModelRepository(
    this.sharedPreferences, {
    this.keyPrefix = 'ednet_domain_',
  });

  @override
  Future<bool> saveDomainModel(
    dynamic domainModel,
    String domainModelId,
  ) async {
    try {
      // Extract model state to JSON
      final modelState = domainModel.toJson();
      final jsonString = jsonEncode(modelState);

      // Save to SharedPreferences
      return await sharedPreferences.setString(
        '$keyPrefix$domainModelId',
        jsonString,
      );
    } catch (e) {
      print('Error saving domain model: $e');
      return false;
    }
  }

  @override
  Future<dynamic> loadDomainModel(String domainModelId) async {
    try {
      final jsonString = sharedPreferences.getString(
        '$keyPrefix$domainModelId',
      );
      if (jsonString == null) return null;

      // Parse JSON to model state
      final modelState = jsonDecode(jsonString) as Map<String, dynamic>;

      // Return the raw state - caller needs to handle reconstruction
      return modelState;
    } catch (e) {
      print('Error loading domain model: $e');
      return null;
    }
  }

  @override
  Future<bool> domainModelExists(String domainModelId) async {
    return sharedPreferences.containsKey('$keyPrefix$domainModelId');
  }

  @override
  Future<bool> clearDomainModel(String domainModelId) async {
    return await sharedPreferences.remove('$keyPrefix$domainModelId');
  }
}

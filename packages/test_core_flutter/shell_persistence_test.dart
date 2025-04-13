import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Simple in-memory repository implementation for tests
class TestRepository {
  final String conceptCode;
  final Map<String, Map<String, dynamic>> _entities = {};

  TestRepository(this.conceptCode);

  Future<bool> save(String id, Map<String, dynamic> data) async {
    _entities[id] = Map.from(data);
    return true;
  }

  Future<Map<String, dynamic>?> findById(String id) async {
    return _entities[id] != null ? Map.from(_entities[id]!) : null;
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    return _entities.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}

/// Test persistence service implementation
class TestPersistenceService {
  final Map<String, TestRepository> _repositories = {};

  /// Save an entity to the repository
  Future<bool> saveEntity(
      String conceptCode, Map<String, dynamic> entityData) async {
    try {
      // Get or create repository for this concept
      final repo = _getRepository(conceptCode);

      // Generate ID if not provided
      final id = entityData['id'] ??
          '${conceptCode}-${DateTime.now().millisecondsSinceEpoch}';
      entityData['id'] = id;

      // Save entity
      final success = await repo.save(id, entityData);
      return success;
    } catch (e) {
      debugPrint('Error saving entity: $e');
      return false;
    }
  }

  /// Load entities from the repository
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) async {
    try {
      // Get repository for this concept
      final repo = _getRepository(conceptCode);

      // Load all entities
      return await repo.findAll();
    } catch (e) {
      debugPrint('Error loading entities: $e');
      return [];
    }
  }

  /// Get or create a repository for the concept
  TestRepository _getRepository(String conceptCode) {
    // Create repository if it doesn't exist
    if (!_repositories.containsKey(conceptCode)) {
      _repositories[conceptCode] = TestRepository(conceptCode);
    }

    return _repositories[conceptCode]!;
  }
}

void main() {
  // Using TDD approach - write the tests first, then implement
  group('Persistence Service Tests', () {
    late TestPersistenceService service;
    const userConceptCode = 'User';

    setUp(() {
      // Create a new test persistence service for each test
      service = TestPersistenceService();
    });

    test('Save entity and verify persistence', () async {
      // Arrange - Set up test data
      final entityData = {
        'username': 'testuser',
        'email': 'test@example.com',
        'isActive': true
      };

      // Act - Save entity
      final result = await service.saveEntity(userConceptCode, entityData);

      // Assert - Verify successful save
      expect(result, isTrue);
      expect(entityData['id'], isNotNull);

      // Act - Load entities
      final loadedEntities = await service.loadEntities(userConceptCode);

      // Assert - Verify loaded entity matches saved one
      expect(loadedEntities, isNotEmpty);
      expect(loadedEntities.length, 1);
      expect(loadedEntities.first['username'], equals('testuser'));
      expect(loadedEntities.first['email'], equals('test@example.com'));
      expect(loadedEntities.first['isActive'], equals(true));
    });

    test('Update existing entity', () async {
      // Arrange - Save initial entity
      final entityData = {
        'username': 'initialuser',
        'email': 'initial@example.com',
        'isActive': true
      };
      await service.saveEntity(userConceptCode, entityData);
      final id = entityData['id'];

      // Act - Update entity
      final updatedData = {
        'id': id,
        'username': 'updateduser',
        'email': 'updated@example.com',
        'isActive': false
      };
      final updateResult =
          await service.saveEntity(userConceptCode, updatedData);

      // Assert - Verify update was successful
      expect(updateResult, isTrue);

      // Act - Load entities
      final loadedEntities = await service.loadEntities(userConceptCode);

      // Assert - Verify entity was updated
      expect(loadedEntities.length, 1);
      expect(loadedEntities.first['id'], equals(id));
      expect(loadedEntities.first['username'], equals('updateduser'));
      expect(loadedEntities.first['email'], equals('updated@example.com'));
      expect(loadedEntities.first['isActive'], equals(false));
    });

    test('Handle multiple entities properly', () async {
      // Arrange - Save multiple entities
      final entity1 = {
        'username': 'user1',
        'email': 'user1@example.com',
        'isActive': true,
        'id': 'user-1' // Add explicit ID to ensure uniqueness
      };

      final entity2 = {
        'username': 'user2',
        'email': 'user2@example.com',
        'isActive': false,
        'id': 'user-2' // Add explicit ID to ensure uniqueness
      };

      // Act - Save both entities
      await service.saveEntity(userConceptCode, entity1);
      await service.saveEntity(userConceptCode, entity2);

      // Act - Load entities
      final loadedEntities = await service.loadEntities(userConceptCode);

      // Assert - Verify both entities were saved
      expect(loadedEntities.length, 2);

      // Verify entities can be found by attributes
      expect(loadedEntities.any((e) => e['username'] == 'user1'), isTrue);
      expect(loadedEntities.any((e) => e['username'] == 'user2'), isTrue);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import '../services/persistence_service.dart';

/// A provider that manages entities for a specific concept
class EntityProvider<T extends Entity<dynamic>> extends ChangeNotifier {
  /// The persistence service
  final PersistenceService _persistenceService;

  /// The concept
  final Concept _concept;

  /// The domain
  final Domain _domain;

  /// The model
  final Model _model;

  /// The entities
  List<T> _entities = [];

  /// Loading state
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Constructor
  EntityProvider({
    required PersistenceService persistenceService,
    required Concept concept,
    required Domain domain,
    required Model model,
  }) : _persistenceService = persistenceService,
       _concept = concept,
       _domain = domain,
       _model = model {
    // Load entities initially
    loadEntities();
  }

  /// Get the entities
  List<T> get entities => _entities;

  /// Get the loading state
  bool get isLoading => _isLoading;

  /// Get the error message
  String? get errorMessage => _errorMessage;

  /// Load entities from the repository
  Future<void> loadEntities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final repository = await _persistenceService.getRepository<T>(
        concept: _concept,
        domain: _domain,
        model: _model,
      );

      final loadedEntities = await repository.findAll();
      _entities = loadedEntities;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load entities: $e';x
      notifyListeners();
    }
  }

  /// Save an entity
  Future<bool> saveEntity(T entity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final saved = await _persistenceService.saveEntity<T>(
        entity,
        _concept,
        _domain,
        _model,
      );

      if (saved) {
        // Refresh entities
        await loadEntities();
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to save entity';
        notifyListeners();
      }

      return saved;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save entity: $e';
      notifyListeners();
      return false;
    }
  }

  /// Create a new entity
  Future<T?> createEntity(Map<String, dynamic> attributeValues) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get domain model
      final domainModel = _getDomainModel();
      if (domainModel == null) {
        _isLoading = false;
        _errorMessage = 'Domain model not found';
        notifyListeners();
        return null;
      }

      // Create a new entity
      final entity = domainModel.newEntity(_concept.code);

      // Set attributes
      for (final entry in attributeValues.entries) {
        entity.setAttribute(entry.key, entry.value);
      }

      // Save to the repository
      final repository = await _persistenceService.getRepository<T>(
        concept: _concept,
        domain: _domain,
        model: _model,
      );

      final saved = await repository.save(entity as T);

      if (saved) {
        // Refresh entities
        await loadEntities();
        return entity as T;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to create entity';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to create entity: $e';
      notifyListeners();
      return null;
    }
  }

  /// Delete an entity
  Future<bool> deleteEntity(T entity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get entity ID
      final id = int.parse(entity.oid.toString());

      // Delete from repository
      final repository = await _persistenceService.getRepository<T>(
        concept: _concept,
        domain: _domain,
        model: _model,
      );

      final deleted = await repository.remove(id);

      if (deleted) {
        // Refresh entities
        await loadEntities();
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to delete entity';
        notifyListeners();
      }

      return deleted;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete entity: $e';
      notifyListeners();
      return false;
    }
  }

  /// Helper method to get the domain model
  dynamic _getDomainModel() {
    try {
      // Get the OneApplication
      final oneApp = _persistenceService as dynamic;
      final app = oneApp._app as OneApplication;

      // Access the domain from app's groupedDomains
      final targetDomain = app.groupedDomains.firstWhere(
        (d) => d.code == _domain.code,
        orElse: () => throw Exception('Domain not found: ${_domain.code}'),
      );

      // Find the model within this domain
      final domainModel = targetDomain.models.firstWhere(
        (m) => m.code == _model.code,
        orElse:
            () =>
                throw Exception(
                  'Model not found: ${_model.code} in domain ${_domain.code}',
                ),
      );

      return domainModel;
    } catch (e) {
      print(
        'Error getting domain model for ${_domain.code}_${_model.code}: $e',
      );
      return null;
    }
  }

  /// Example usage of an EntityProvider
  static Widget createEntityWidgetExample({
    required BuildContext context,
    required Concept concept,
    required Domain domain,
    required Model model,
    required PersistenceService persistenceService,
  }) {
    return ChangeNotifierProvider<EntityProvider<Entity<dynamic>>>(
      create:
          (_) => EntityProvider<Entity<dynamic>>(
            persistenceService: persistenceService,
            concept: concept,
            domain: domain,
            model: model,
          ),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<EntityProvider<Entity<dynamic>>>(
            context,
          );

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          if (provider.entities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No entities found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Create a sample entity with some data
                      await provider.createEntity({
                        'name': 'Sample Entity',
                        'description':
                            'This is a sample entity created using the EntityProvider',
                        'createdAt': DateTime.now(),
                      });
                    },
                    child: const Text('Create Sample Entity'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.entities.length,
            itemBuilder: (context, index) {
              final entity = provider.entities[index];

              return ListTile(
                title: Text('Entity ${entity.oid}'),
                subtitle: Text('Tap to view details'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await provider.deleteEntity(entity);
                  },
                ),
                onTap: () {
                  // Show entity details
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Entity ${entity.oid}'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                for (final attribute in concept.attributes)
                                  ListTile(
                                    title: Text(attribute.code),
                                    subtitle: Text(
                                      _getAttributeValueString(
                                        entity,
                                        attribute.code,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Helper method to get attribute value as a string
  static String _getAttributeValueString(
    Entity<dynamic> entity,
    String attributeCode,
  ) {
    try {
      final value = entity.getAttribute(attributeCode);
      if (value == null) return 'null';
      if (value is DateTime) return value.toString();
      return value.toString();
    } catch (e) {
      return 'N/A';
    }
  }
}

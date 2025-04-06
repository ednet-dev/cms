import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'entity_repository.dart';

/// Implementation of EntityRepository using OneApplication
class EntityRepositoryImpl implements EntityRepository {
  final OneApplication _app;

  /// Constructor requiring the OneApplication instance
  EntityRepositoryImpl(this._app);

  @override
  Future<List<Entity<dynamic>>> getEntities(
    Domain domain,
    Model model,
    Concept concept,
  ) async {
    try {
      // Get the domain model
      final domainModel = _getDomainModel(domain, model);

      if (concept.entry) {
        // If the concept is an entry point, we can get entities directly
        final entities = domainModel.entities(concept.code);
        return entities.toList();
      } else {
        // For non-entry concepts, we need a different approach
        // This is likely domain-specific and might require a custom solution
        throw UnimplementedError(
          'Getting entities for non-entry concepts is not implemented',
        );
      }
    } catch (e) {
      print('Error getting entities: $e');
      return [];
    }
  }

  @override
  Future<Entity<dynamic>?> getEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
  ) async {
    try {
      // Get the domain model
      final domainModel = _getDomainModel(domain, model);

      if (concept.entry) {
        // Get all entities for this concept
        final entities = domainModel.entities(concept.code);

        // Find the entity with matching OID
        return entities.firstWhere((entity) => entity.oid == oid);
      } else {
        throw UnimplementedError(
          'Getting entity for non-entry concepts is not implemented',
        );
      }
    } catch (e) {
      print('Error getting entity: $e');
      return null;
    }
  }

  @override
  Future<Entity<dynamic>> createEntity(
    Domain domain,
    Model model,
    Concept concept,
    Map<String, dynamic> attributeValues,
  ) async {
    try {
      // Get the domain model
      final domainModel = _getDomainModel(domain, model);

      if (!concept.entry) {
        throw ArgumentError('Cannot create entity for non-entry concept');
      }

      // Create a new entity through the domain model
      final entity = domainModel.newEntity(concept.code);

      // Set attribute values
      for (final entry in attributeValues.entries) {
        entity.setAttribute(entry.key, entry.value);
      }

      // Save the entity
      domainModel.save();

      return entity;
    } catch (e) {
      print('Error creating entity: $e');
      rethrow;
    }
  }

  @override
  Future<Entity<dynamic>> updateEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
    Map<String, dynamic> attributeValues,
  ) async {
    try {
      // Get the entity
      final entity = await getEntity(domain, model, concept, oid);
      if (entity == null) {
        throw Exception('Entity not found');
      }

      // Update attribute values
      for (final entry in attributeValues.entries) {
        entity.setAttribute(entry.key, entry.value);
      }

      // Save changes
      final domainModel = _getDomainModel(domain, model);
      domainModel.save();

      return entity;
    } catch (e) {
      print('Error updating entity: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteEntity(
    Domain domain,
    Model model,
    Concept concept,
    int oid,
  ) async {
    try {
      // Get the domain model
      final domainModel = _getDomainModel(domain, model);

      if (!concept.entry) {
        throw ArgumentError('Cannot delete entity for non-entry concept');
      }

      // Get all entities for this concept
      final entities = domainModel.entities(concept.code);

      // Find the entity with matching OID
      final entity = entities.firstWhere((entity) => entity.oid == oid);

      // Remove the entity
      // Note: Implementation depends on the actual API of ednet_core
      // This is a simplified example
      domainModel.removeEntity(concept.code, entity);

      // Save changes
      domainModel.save();

      return true;
    } catch (e) {
      print('Error deleting entity: $e');
      return false;
    }
  }

  /// Helper method to get the domain model
  dynamic _getDomainModel(Domain domain, Model model) {
    try {
      // Access the domain directly from app's groupedDomains
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
      rethrow;
    }
  }
}

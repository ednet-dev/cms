import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart' show oneApplication;

/// Domain model provider for the Holy Trinity architecture
///
/// This file contains extensions and utilities that connect the domain model
/// (managed by OneApplication) with the semantic concepts used in the UI layer.
///
/// This is the third pillar of our "Holy Trinity" architecture:
/// 1. Layout Strategy - How components are arranged visually
/// 2. Theme Strategy - How components are styled visually
/// 3. Domain Model - The underlying business concepts represented in the UI

/// Extension methods for IOneApplication to support semantic concepts
extension DomainModelProviderExtension on IOneApplication {
  /// Get the concept type for a domain entity
  ///
  /// This maps domain entities to their corresponding semantic concept types
  /// that can be used with SemanticConceptContainer and theme/layout strategies.
  ///
  /// [entity] - The domain entity to get the concept type for
  ///
  /// Returns a string representing the semantic concept type
  String getConceptTypeForEntity(Entity entity) {
    // The concept type is typically the concept code from the domain model
    return entity.concept.code;
  }

  /// Get the concept type for a domain concept
  ///
  /// This maps domain concepts to their corresponding semantic concept types
  /// that can be used with SemanticConceptContainer and theme/layout strategies.
  ///
  /// [concept] - The domain concept to get the concept type for
  ///
  /// Returns a string representing the semantic concept type
  String getConceptTypeForConcept(Concept concept) {
    return 'Concept';
  }

  /// Get the concept type for a domain model
  ///
  /// This maps domain models to their corresponding semantic concept types
  /// that can be used with SemanticConceptContainer and theme/layout strategies.
  ///
  /// [model] - The domain model to get the concept type for
  ///
  /// Returns a string representing the semantic concept type
  String getConceptTypeForModel(Model model) {
    return 'Model';
  }

  /// Get the concept type for a domain
  ///
  /// This maps domains to their corresponding semantic concept types
  /// that can be used with SemanticConceptContainer and theme/layout strategies.
  ///
  /// [domain] - The domain to get the concept type for
  ///
  /// Returns a string representing the semantic concept type
  String getConceptTypeForDomain(Domain domain) {
    return 'Domain';
  }

  /// Get a semantic role for an entity property
  ///
  /// This determines the appropriate semantic role for a property of an entity,
  /// which can be used with theme and layout strategies to apply appropriate styling.
  ///
  /// [entity] - The entity containing the property
  /// [propertyName] - The name of the property
  ///
  /// Returns a string representing the semantic role
  String getRoleForEntityProperty(Entity entity, String propertyName) {
    // Default mapping based on common property patterns
    switch (propertyName) {
      case 'id':
      case 'code':
      case 'oid':
        return 'identifier';
      case 'name':
      case 'title':
        return 'title';
      case 'description':
        return 'description';
      case 'createdAt':
      case 'updatedAt':
      case 'timestamp':
        return 'metadata';
      default:
        return 'attribute';
    }
  }
}

/// Extension methods to add to BuildContext for accessing domain model from UI
extension DomainModelContextExtension on BuildContext {
  /// Get the OneApplication instance from the context
  ///
  /// This provides convenient access to the domain model from within the UI.
  /// Note: This requires the OneApplication to be accessible in the widget tree.
  ///
  /// Example:
  /// ```dart
  /// final app = context.domainModelProvider;
  /// final domains = app.groupedDomains;
  /// ```
  IOneApplication get domainModelProvider {
    // This will be implemented when we integrate with the widget tree
    // For now, we can use the global instance from main.dart
    return oneApplication;
  }

  /// Get the concept type for a domain entity
  ///
  /// Convenience method to get the semantic concept type for an entity.
  ///
  /// Example:
  /// ```dart
  /// final conceptType = context.conceptTypeForEntity(task);
  /// ```
  String conceptTypeForEntity(Entity entity) {
    return domainModelProvider.getConceptTypeForEntity(entity);
  }

  /// Get the concept type for a domain concept
  ///
  /// Convenience method to get the semantic concept type for a concept.
  ///
  /// Example:
  /// ```dart
  /// final conceptType = context.conceptTypeForConcept(taskConcept);
  /// ```
  String conceptTypeForConcept(Concept concept) {
    return domainModelProvider.getConceptTypeForConcept(concept);
  }

  /// Get the concept type for a domain model
  ///
  /// Convenience method to get the semantic concept type for a model.
  ///
  /// Example:
  /// ```dart
  /// final conceptType = context.conceptTypeForModel(coreModel);
  /// ```
  String conceptTypeForModel(Model model) {
    return domainModelProvider.getConceptTypeForModel(model);
  }

  /// Get the concept type for a domain
  ///
  /// Convenience method to get the semantic concept type for a domain.
  ///
  /// Example:
  /// ```dart
  /// final conceptType = context.conceptTypeForDomain(projectDomain);
  /// ```
  String conceptTypeForDomain(Domain domain) {
    return domainModelProvider.getConceptTypeForDomain(domain);
  }
}

/// Provider for domain model state
class DomainModelProvider extends ChangeNotifier {
  /// Reference to the application instance
  final OneApplication _application;

  /// Currently selected domain
  Domain? _selectedDomain;

  /// Currently selected model
  Model? _selectedModel;

  /// Currently selected concept
  Concept? _selectedConcept;

  /// Constructor
  DomainModelProvider(this._application) {
    // Default selection if domains exist
    if (_application.domains.isNotEmpty) {
      _selectedDomain = _application.domains.first;

      if (_selectedDomain!.models.isNotEmpty) {
        _selectedModel = _selectedDomain!.models.first;

        if (_selectedModel!.concepts.isNotEmpty) {
          _selectedConcept = _selectedModel!.concepts.first;
        }
      }
    }
  }

  /// Get all domains
  List<Domain> get domains => _application.domains;

  /// Get the currently selected domain
  Domain? get selectedDomain => _selectedDomain;

  /// Get all models for the selected domain
  List<Model> get models => _selectedDomain?.models.toList() ?? [];

  /// Get the currently selected model
  Model? get selectedModel => _selectedModel;

  /// Get all concepts for the selected model
  List<Concept> get concepts => _selectedModel?.concepts.toList() ?? [];

  /// Get the currently selected concept
  Concept? get selectedConcept => _selectedConcept;

  /// Select a domain
  void selectDomain(Domain domain) {
    _selectedDomain = domain;

    // Reset model and concept selections
    if (domain.models.isNotEmpty) {
      _selectedModel = domain.models.first;

      if (_selectedModel!.concepts.isNotEmpty) {
        _selectedConcept = _selectedModel!.concepts.first;
      } else {
        _selectedConcept = null;
      }
    } else {
      _selectedModel = null;
      _selectedConcept = null;
    }

    notifyListeners();
  }

  /// Select a model
  void selectModel(Model model) {
    if (_selectedDomain == null) return;

    _selectedModel = model;

    // Reset concept selection
    if (model.concepts.isNotEmpty) {
      _selectedConcept = model.concepts.first;
    } else {
      _selectedConcept = null;
    }

    notifyListeners();
  }

  /// Select a concept
  void selectConcept(Concept concept) {
    if (_selectedModel == null) return;

    _selectedConcept = concept;
    notifyListeners();
  }
}

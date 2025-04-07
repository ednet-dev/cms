import 'package:ednet_core/ednet_core.dart';

/// Extensions for Domain to enable runtime manipulation
extension DomainExtensions on Domain {
  /// Get all models in this domain
  List<Model> getAllModels() {
    return models.toList();
  }
}

/// Extensions for Model to enable runtime manipulation
extension ModelExtensions on Model {
  /// Get all concepts in this model
  List<Concept> getAllConcepts() {
    return concepts.toList();
  }

  /// Get all entry concepts in this model
  List<Concept> getEntryConcepts() {
    return concepts.where((c) => c.entry).toList();
  }
}

/// Extensions for Concept to enable runtime manipulation
extension ConceptExtensions on Concept {
  /// Get all attributes of this concept
  List<Property> getAllAttributes() {
    return attributes.toList();
  }

  /// Get all parent concepts
  List<Concept> getAllParents() {
    final List<Concept> parentConcepts = [];
    for (final parent in parents) {
      if (parent is Parent) {
        parentConcepts.add(parent.destinationConcept);
      }
    }
    return parentConcepts;
  }
}

/// Extensions for OneApplication to enable domain model manipulation

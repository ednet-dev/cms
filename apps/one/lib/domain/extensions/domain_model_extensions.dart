import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';

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
    return parents.toList();
  }
}

/// Extensions for OneApplication to enable domain model manipulation
extension OneApplicationExtensions on OneApplication {
  /// Get all available domains
  List<Domain> getAllDomains() {
    return groupedDomains.toList();
  }

  /// Find a domain by code
  Domain? findDomain(String domainCode) {
    try {
      return groupedDomains.firstWhere((d) => d.code == domainCode);
    } catch (e) {
      return null;
    }
  }

  /// Find a model by domain and model code
  Model? findModel(String domainCode, String modelCode) {
    final domain = findDomain(domainCode);
    if (domain == null) return null;

    try {
      return domain.models.firstWhere((m) => m.code == modelCode);
    } catch (e) {
      return null;
    }
  }

  /// Find a concept by domain, model, and concept code
  Concept? findConcept(
    String domainCode,
    String modelCode,
    String conceptCode,
  ) {
    final model = findModel(domainCode, modelCode);
    if (model == null) return null;

    try {
      return model.concepts.firstWhere((c) => c.code == conceptCode);
    } catch (e) {
      return null;
    }
  }

  /// Internal method to get a domain model
  dynamic getDomainModelInstance(Domain domain, Model model) {
    try {
      // Simplified algorithm to find domain model by domain and model codes
      final domainCode = domain.code.toLowerCase();
      final modelCode = model.code.toLowerCase();
      final domainModelId = '${domainCode}_${modelCode}';

      // This is just a placeholder - real implementation would depend on the actual API
      return domain;
    } catch (e) {
      print('Error getting domain model: $e');
      return null;
    }
  }
}

import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';

/// Service for domain-related operations
class DomainService {
  final OneApplication _app;

  /// Creates a new domain service
  DomainService(this._app);

  /// Get all domains
  Domains getAllDomains() {
    return _app.groupedDomains;
  }

  /// Get a domain by code
  Domain? getDomainByCode(String code) {
    for (var domain in _app.groupedDomains) {
      if (domain.code == code) {
        return domain;
      }
    }
    return null;
  }

  /// Get models for a domain
  Models getModelsForDomain(Domain domain) {
    return domain.models;
  }

  /// Get concepts for a model
  Concepts getConceptsForModel(Model model) {
    Concepts concepts = Concepts();
    var entryConcepts = model.getOrderedEntryConcepts();
    for (var concept in entryConcepts) {
      concepts.add(concept);
    }
    return concepts;
  }

  /// Get entities for a concept in a model
  Entities? getEntitiesForConcept(Domain domain, Model model, Concept concept) {
    var domainModel = _app.getDomainModels(
      domain.codeFirstLetterLower,
      model.codeFirstLetterLower,
    );

    var modelEntries = domainModel.getModelEntries(model.code);
    return modelEntries?.getEntry(concept.code);
  }

  /// Generate DSL for a domain model
  String generateDSL(Domain domain, Model model) {
    // Implementation would depend on the specific requirements
    return 'DSL for ${domain.code}.${model.code}';
  }

  /// Load domain data from storage or API
  Future<void> loadDomainData() async {
    // The application already initializes domains in its constructor
    // No additional initialization needed here
  }

  /// Save domain data to storage
  Future<void> saveDomainData() async {
    // Implementation would save domain data to persistent storage
  }
}

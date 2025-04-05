import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/models/model_registry.dart';

/// Application that coordinates domain models and provides access to them.
/// This serves as a bridge between ednet_core and the UI layer.
class OneApplication implements IOneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};

  OneApplication() {
    _initializeDomains();
    _groupDomains();
  }

  /// Initializes all domain models used in the application
  void _initializeDomains() {
    // Load domain models from registry
    final domainModelPairs = ModelRegistry.getDomainModels();

    for (final pair in domainModelPairs) {
      final domain = pair.domain;
      final domainModels = pair.domainModels;

      // Add domain to domains collection
      _domains.add(domain);

      // Register domain models in lookup table
      final key =
          '${domain.codeFirstLetterLower}_${pair.modelCode.toLowerCase()}';
      _domainModelsTable[key] = domainModels;
    }
  }

  @override
  DomainModels getDomainModels(String domain, String model) {
    final domainModel = _domainModelsTable['${domain}_$model'];

    if (domainModel == null) {
      throw Exception('Domain model not found: $domain, $model');
    }

    return domainModel;
  }

  /// Groups domains by name to present a consolidated view
  void _groupDomains() {
    for (var domain in _domains) {
      var existingDomain = _groupedDomains.singleWhereCode(domain.code);
      if (existingDomain == null) {
        _groupedDomains.add(domain);
      } else {
        _mergeDomainModels(existingDomain, domain);
      }
    }
  }

  /// Merges models from source domain into target domain
  void _mergeDomainModels(Domain targetDomain, Domain sourceDomain) {
    for (var model in sourceDomain.models) {
      if (!targetDomain.models.any((m) => m.code == model.code)) {
        targetDomain.models.add(model);
      } else {
        var targetModel = targetDomain.models.singleWhere(
          (m) => m.code == model.code,
        );
        _mergeModelEntries(targetModel, model);
      }
    }
  }

  /// Merges concepts from source model into target model
  void _mergeModelEntries(Model targetModel, Model sourceModel) {
    for (var concept in sourceModel.concepts) {
      if (!targetModel.concepts.any((c) => c.code == concept.code)) {
        targetModel.concepts.add(concept);
      }
    }
  }

  @override
  Domains get domains => _domains;

  @override
  Domains get groupedDomains => _groupedDomains;

  Map<String, DomainModels> get domainModels => _domainModelsTable;
}

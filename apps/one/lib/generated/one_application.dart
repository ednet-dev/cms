import 'package:ednet_core/ednet_core.dart';

import 'package:ednet_one/generated/democracy/electoral/lib/democracy_electoral.dart' as dyel;
// IMPORTS PLACEHOLDER

class OneApplication implements IOneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};

  OneApplication() {
    _initializeDomains();
    _groupDomains();
  }

  void _initializeDomains() {
        // democracy electoral
    final democracyElectoralRepo = dyel.DemocracyElectoralRepo();
    dyel.DemocracyDomain democracyElectoralDomain = democracyElectoralRepo
        .getDomainModels("Democracy") as dyel.DemocracyDomain;
    dyel.ElectoralModel electoralModel =
        democracyElectoralDomain.getModelEntries("Electoral") as dyel.ElectoralModel;
    electoralModel.init();

    _domains..add(democracyElectoralDomain.domain);
    _domainModelsTable['democracy_electoral'] = democracyElectoralDomain;

// INIT PLACEHOLDER
  }
  
  @override
  DomainModels getDomainModels(String domain, String model) {
    final domainModel = _domainModelsTable['${domain}_$model'];
  
    if (domainModel == null) {
      throw Exception('Domain model not found: $domain, $model');
    }
  
    return domainModel;
  }

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

  void _mergeDomainModels(Domain targetDomain, Domain sourceDomain) {
    for (var model in sourceDomain.models) {
      if (!targetDomain.models.any((m) => m.code == model.code)) {
        targetDomain.models.add(model);
      } else {
        var targetModel =
            targetDomain.models.singleWhere((m) => m.code == model.code);
        _mergeModelEntries(targetModel, model);
      }
    }
  }

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

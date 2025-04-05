import 'package:ednet_core/ednet_core.dart';

// Import production models
import 'package:ednet_one_interpreter/generated/production/project/core/lib/project_core.dart'
    as prodcore;

// Import staging models if needed
import 'package:ednet_one_interpreter/generated/staging/project/core/lib/project_core.dart'
    as stagingcore;
// Add other staging imports as needed

/// Application that coordinates domain models and provides access to them.
/// This serves as a bridge between ednet_core and the UI layer.
class OneApplication implements IOneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};
  final bool useStaging;

  OneApplication({this.useStaging = false}) {
    _initializeDomains();
    _groupDomains();
  }

  void _initializeDomains() {
    // PRODUCTION MODELS
    // Project core from production
    try {
      final projectCoreRepo = prodcore.ProjectCoreRepo();
      prodcore.ProjectDomain projectCoreDomain =
          projectCoreRepo.getDomainModels("Project") as prodcore.ProjectDomain;
      prodcore.CoreModel coreModel =
          projectCoreDomain.getModelEntries("Core") as prodcore.CoreModel;
      coreModel.init();

      // Add to domain registry
      _domains.add(projectCoreDomain.domain);
      _domainModelsTable['project_core'] = projectCoreDomain;

      print('✅ Successfully loaded Project Core domain from production');
    } catch (e) {
      print('❌ Error loading Project Core from production: $e');
    }

    // STAGING MODELS (if useStaging is true)
    if (useStaging) {
      try {
        // Project core from staging
        final stagingProjectCoreRepo = stagingcore.ProjectCoreRepo();
        stagingcore.ProjectDomain stagingProjectCoreDomain =
            stagingProjectCoreRepo.getDomainModels("Project")
                as stagingcore.ProjectDomain;
        stagingcore.CoreModel stagingCoreModel =
            stagingProjectCoreDomain.getModelEntries("Core")
                as stagingcore.CoreModel;
        stagingCoreModel.init();

        // Add to domain registry with staging indicator
        _domains.add(stagingProjectCoreDomain.domain);
        _domainModelsTable['staging_project_core'] = stagingProjectCoreDomain;

        print('✅ Successfully loaded Project Core domain from staging');
      } catch (e) {
        print('❌ Error loading Project Core from staging: $e');
      }
    }

    // If no domains were loaded, create a sample domain for demonstration
    if (_domains.isEmpty) {
      print('⚠️ No domains loaded, creating sample domain...');
      _createSampleDomains();
    }
  }

  @override
  DomainModels getDomainModels(String domain, String model) {
    // Try with or without staging prefix
    final stagingKey = 'staging_${domain}_$model';
    final regularKey = '${domain}_$model';

    final domainModel =
        _domainModelsTable[useStaging ? stagingKey : regularKey] ??
        _domainModelsTable[regularKey];

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
        var targetModel = targetDomain.models.singleWhere(
          (m) => m.code == model.code,
        );
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

  /// Creates sample domains and models if no real ones are found
  void _createSampleDomains() {
    try {
      // Create a simple Project domain with Task model
      final projectDomain = Domain('Project');
      projectDomain.description = 'Sample Project Domain';

      final taskModel = Model(projectDomain, 'Task');
      taskModel.description = 'Task Management Model';

      final taskConcept = Concept(taskModel, 'Task');
      taskConcept.entry = true;
      taskConcept.description = 'A task to be completed';

      // Add to domain registry
      _domains.add(projectDomain);

      print('✅ Created sample Project domain with Task model');

      // Create a simple Customer domain
      final customerDomain = Domain('Customer');
      customerDomain.description = 'Sample Customer Domain';

      final profileModel = Model(customerDomain, 'Profile');
      profileModel.description = 'Customer Profile Model';

      final customerConcept = Concept(profileModel, 'Customer');
      customerConcept.entry = true;
      customerConcept.description = 'A customer profile';

      // Add to domain registry
      _domains.add(customerDomain);

      print('✅ Created sample Customer domain with Profile model');
    } catch (e) {
      print('❌ Error creating sample domains: $e');
    }
  }

  @override
  Domains get domains => _domains;

  @override
  Domains get groupedDomains => _groupedDomains;

  Map<String, DomainModels> get domainModels => _domainModelsTable;
}

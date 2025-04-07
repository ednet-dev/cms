import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/foundation.dart';

import 'package:ednet_one/generated/project/core/lib/project_core.dart' as ptce;
import 'package:ednet_one/generated/direct/lib/democracy_direct.dart' as dydt;
import 'package:ednet_one/generated/household/finance/lib/household_finance.dart'
    as hdfe;
import 'package:ednet_one/generated/household/member/lib/household_member.dart'
    as hdmr;
import 'package:ednet_one/generated/project/brainstorming/lib/project_brainstorming.dart'
    as ptbg;
import 'package:ednet_one/generated/project/gtd/lib/project_gtd.dart' as ptgd;
import 'package:ednet_one/generated/project/kanban/lib/project_kanban.dart'
    as ptkn;
import 'package:ednet_one/generated/project/planning/lib/project_planning.dart'
    as ptpg;
import 'package:ednet_one/generated/project/scheduling/lib/project_scheduling.dart'
    as ptsg;
import 'package:ednet_one/generated/project/user/lib/project_user.dart' as ptur;
import 'package:ednet_one/generated/settings/application/lib/settings_application.dart'
    as ssan;
// IMPORTS PLACEHOLDER

/// OneApplication class representing the entire application
class OneApplication implements IOneApplication {
  /// All domains in the application
  final Domains _domains = Domains();

  /// Get a list of all domains
  @override
  Domains get domains => _domains;

  /// Constructor
  OneApplication();

  /// Add a domain to the application
  void addDomain(Domain domain) {
    _domains.add(domain);
  }

  /// Create a simple domain
  Domain createDomain(String code) {
    // Create a new domain
    final domain = Domain(code);

    // Add it to the list
    _domains.add(domain);

    return domain;
  }

  /// Find a domain by its code
  Domain? findDomain(String code) {
    try {
      return _domains.firstWhere((d) => d.code == code);
    } catch (e) {
      return null;
    }
  }

  // Implementation of IOneApplication interface
  @override
  DomainModels getDomainModels(String domain, String model) {
    final key = '${domain}_$model';
    if (!_domainModelsTable.containsKey(key)) {
      throw Exception('Domain model not found: $domain, $model');
    }
    return _domainModelsTable[key]!;
  }

  // Storage for domain models
  final Map<String, DomainModels> _domainModelsTable = {};
  final Domains _groupedDomains = Domains();

  /// Access to grouped domains for backward compatibility
  @override
  Domains get groupedDomains => _groupedDomains;

  /// Initialize the application and load all domains and models
  Future<void> initializeApplication() async {
    debugPrint('🔍 Initializing OneApplication');
    _initializeDomains();
    _groupDomains();

    // Log summary after initialization
    debugPrint('📊 Application initialization completed');
    debugPrint('📊 Total domains: ${_domains.length}');
    debugPrint('📊 Total grouped domains: ${_groupedDomains.length}');

    for (var domain in _groupedDomains) {
      debugPrint('📊 Domain: ${domain.code}');
      for (var model in domain.models) {
        debugPrint(
          '📊   Model: ${model.code}, Concepts: ${model.concepts.length}',
        );
      }
    }

    return Future.value();
  }

  void _initializeDomains() {
    // Initialize domain models - simplified version
    debugPrint('🔍 _initializeDomains started');
    try {
      // Add test domain
      final testDomain = createDomain('TestDomain');
      testDomain.description = 'Test domain for development';

      // Create a test model
      final testModel = Model(testDomain, 'TestModel');
      testModel.description = 'Test model for development';
      testDomain.models.add(testModel);

      // For now, we'll skip adding to domainModelsTable since we don't have a valid implementation
      // This will need to be addressed in a future update

      debugPrint('🔍 _initializeDomains completed successfully');
      debugPrint('🔍 Domains count after init: ${_domains.length}');
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _initializeDomains: $e');
      debugPrint('❌ StackTrace: $stackTrace');
    }
  }

  void _groupDomains() {
    debugPrint('🔍 _groupDomains started');
    try {
      for (var domain in _domains) {
        var existingDomain = _groupedDomains.singleWhereCode(domain.code);
        if (existingDomain == null) {
          _groupedDomains.add(domain);
        } else {
          _mergeDomainModels(existingDomain, domain);
        }
      }
      debugPrint(
        '🔍 _groupDomains completed, domains count: ${_groupedDomains.length}',
      );
    } catch (e) {
      debugPrint('❌ Error in _groupDomains: $e');
    }
  }

  void _mergeDomainModels(Domain targetDomain, Domain sourceDomain) {
    // Simplified implementation
    for (var model in sourceDomain.models) {
      if (!targetDomain.models.any((m) => m.code == model.code)) {
        targetDomain.models.add(model);
      }
    }
  }
}

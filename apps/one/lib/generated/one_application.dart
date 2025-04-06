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

class OneApplication implements IOneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};

  OneApplication() {
    debugPrint('🔍 OneApplication constructor called');
  }

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
        for (var concept in model.concepts) {
          // Just log concept details without trying to count entities
          debugPrint(
            '📊     Concept: ${concept.code}, IsEntry: ${concept.entry}',
          );
        }
      }
    }

    return Future.value();
  }

  void _initializeDomains() {
    debugPrint('🔍 _initializeDomains started');
    try {
      // settings application
      debugPrint('🔍 Creating SettingsApplicationRepo');
      final settingsApplicationRepo = ssan.SettingsApplicationRepo();

      debugPrint('🔍 Getting SettingsDomain');
      ssan.SettingsDomain settingsApplicationDomain =
          settingsApplicationRepo.getDomainModels("Settings")
              as ssan.SettingsDomain;

      debugPrint('🔍 Getting ApplicationModel');
      ssan.ApplicationModel applicationModel =
          settingsApplicationDomain.getModelEntries("Application")
              as ssan.ApplicationModel;

      debugPrint('🔍 Initializing ApplicationModel');
      applicationModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(settingsApplicationDomain.domain);
      _domainModelsTable['settings_application'] = settingsApplicationDomain;

      // project scheduling
      debugPrint('🔍 Creating ProjectSchedulingRepo');
      final projectSchedulingRepo = ptsg.ProjectSchedulingRepo();

      debugPrint('🔍 Getting ProjectDomain for Scheduling');
      ptsg.ProjectDomain projectSchedulingDomain =
          projectSchedulingRepo.getDomainModels("Project")
              as ptsg.ProjectDomain;

      debugPrint('🔍 Getting SchedulingModel');
      ptsg.SchedulingModel schedulingModel =
          projectSchedulingDomain.getModelEntries("Scheduling")
              as ptsg.SchedulingModel;

      debugPrint('🔍 Initializing SchedulingModel');
      schedulingModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectSchedulingDomain.domain);
      _domainModelsTable['project_scheduling'] = projectSchedulingDomain;

      // project core
      debugPrint('🔍 Creating ProjectCoreRepo');
      final projectCoreRepo = ptce.ProjectCoreRepo();

      debugPrint('🔍 Getting ProjectDomain');
      ptce.ProjectDomain projectCoreDomain =
          projectCoreRepo.getDomainModels("Project") as ptce.ProjectDomain;

      debugPrint('🔍 Getting CoreModel');
      ptce.CoreModel coreModel =
          projectCoreDomain.getModelEntries("Core") as ptce.CoreModel;

      debugPrint('🔍 Initializing CoreModel');
      coreModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectCoreDomain.domain);
      _domainModelsTable['project_core'] = projectCoreDomain;

      // Add detailed debug logging
      debugPrint('🔍 CoreModel initialized with:');
      debugPrint('   - ${coreModel.projects.length} projects');
      debugPrint('   - ${coreModel.tasks.length} tasks');
      debugPrint('   - ${coreModel.milestones.length} milestones');
      debugPrint('   - ${coreModel.resources.length} resources');
      debugPrint('   - ${coreModel.roles.length} roles');
      debugPrint('   - ${coreModel.teams.length} teams');
      debugPrint('   - ${coreModel.skills.length} skills');
      debugPrint('   - ${coreModel.times.length} times');
      debugPrint('   - ${coreModel.budgets.length} budgets');
      debugPrint('   - ${coreModel.initiatives.length} initiatives');

      debugPrint('🔍 Domain models: ${projectCoreDomain.domain.models.length}');
      for (var model in projectCoreDomain.domain.models) {
        debugPrint(
          '   - Model: ${model.code}, Concepts: ${model.concepts.length}',
        );
        for (var concept in model.concepts) {
          debugPrint(
            '     * Concept: ${concept.code}, Entries: ${concept.entry}',
          );
        }
      }

      // project brainstorming
      debugPrint('🔍 Creating ProjectBrainstormingRepo');
      final projectBrainstormingRepo = ptbg.ProjectBrainstormingRepo();

      debugPrint('🔍 Getting ProjectDomain for Brainstorming');
      ptbg.ProjectDomain projectBrainstormingDomain =
          projectBrainstormingRepo.getDomainModels("Project")
              as ptbg.ProjectDomain;

      debugPrint('🔍 Getting BrainstormingModel');
      ptbg.BrainstormingModel brainstormingModel =
          projectBrainstormingDomain.getModelEntries("Brainstorming")
              as ptbg.BrainstormingModel;

      debugPrint('🔍 Initializing BrainstormingModel');
      brainstormingModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectBrainstormingDomain.domain);
      _domainModelsTable['project_brainstorming'] = projectBrainstormingDomain;

      // project planning
      debugPrint('🔍 Creating ProjectPlanningRepo');
      final projectPlanningRepo = ptpg.ProjectPlanningRepo();

      debugPrint('🔍 Getting ProjectDomain for Planning');
      ptpg.ProjectDomain projectPlanningDomain =
          projectPlanningRepo.getDomainModels("Project") as ptpg.ProjectDomain;

      debugPrint('🔍 Getting PlanningModel');
      ptpg.PlanningModel planningModel =
          projectPlanningDomain.getModelEntries("Planning")
              as ptpg.PlanningModel;

      debugPrint('🔍 Initializing PlanningModel');
      planningModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectPlanningDomain.domain);
      _domainModelsTable['project_planning'] = projectPlanningDomain;

      // project kanban
      debugPrint('🔍 Creating ProjectKanbanRepo');
      final projectKanbanRepo = ptkn.ProjectKanbanRepo();

      debugPrint('🔍 Getting ProjectDomain for Kanban');
      ptkn.ProjectDomain projectKanbanDomain =
          projectKanbanRepo.getDomainModels("Project") as ptkn.ProjectDomain;

      debugPrint('🔍 Getting KanbanModel');
      ptkn.KanbanModel kanbanModel =
          projectKanbanDomain.getModelEntries("Kanban") as ptkn.KanbanModel;

      debugPrint('🔍 Initializing KanbanModel');
      kanbanModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectKanbanDomain.domain);
      _domainModelsTable['project_kanban'] = projectKanbanDomain;

      // project user
      debugPrint('🔍 Creating ProjectUserRepo');
      final projectUserRepo = ptur.ProjectUserRepo();

      debugPrint('🔍 Getting ProjectDomain for User');
      ptur.ProjectDomain projectUserDomain =
          projectUserRepo.getDomainModels("Project") as ptur.ProjectDomain;

      debugPrint('🔍 Getting UserModel');
      ptur.UserModel userModel =
          projectUserDomain.getModelEntries("User") as ptur.UserModel;

      debugPrint('🔍 Initializing UserModel');
      userModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectUserDomain.domain);
      _domainModelsTable['project_user'] = projectUserDomain;

      // project gtd
      debugPrint('🔍 Creating ProjectGtdRepo');
      final projectGtdRepo = ptgd.ProjectGtdRepo();

      debugPrint('🔍 Getting ProjectDomain for Gtd');
      ptgd.ProjectDomain projectGtdDomain =
          projectGtdRepo.getDomainModels("Project") as ptgd.ProjectDomain;

      debugPrint('🔍 Getting GtdModel');
      ptgd.GtdModel gtdModel =
          projectGtdDomain.getModelEntries("Gtd") as ptgd.GtdModel;

      debugPrint('🔍 Initializing GtdModel');
      gtdModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(projectGtdDomain.domain);
      _domainModelsTable['project_gtd'] = projectGtdDomain;

      // household finance
      debugPrint('🔍 Creating HouseholdFinanceRepo');
      final householdFinanceRepo = hdfe.HouseholdFinanceRepo();

      debugPrint('🔍 Getting HouseholdDomain for Finance');
      hdfe.HouseholdDomain householdFinanceDomain =
          householdFinanceRepo.getDomainModels("Household")
              as hdfe.HouseholdDomain;

      debugPrint('🔍 Getting FinanceModel');
      hdfe.FinanceModel financeModel =
          householdFinanceDomain.getModelEntries("Finance")
              as hdfe.FinanceModel;

      debugPrint('🔍 Initializing FinanceModel');
      financeModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(householdFinanceDomain.domain);
      _domainModelsTable['household_finance'] = householdFinanceDomain;

      // household member
      debugPrint('🔍 Creating HouseholdMemberRepo');
      final householdMemberRepo = hdmr.HouseholdMemberRepo();

      debugPrint('🔍 Getting HouseholdDomain for Member');
      hdmr.HouseholdDomain householdMemberDomain =
          householdMemberRepo.getDomainModels("Household")
              as hdmr.HouseholdDomain;

      debugPrint('🔍 Getting MemberModel');
      hdmr.MemberModel memberModel =
          householdMemberDomain.getModelEntries("Member") as hdmr.MemberModel;

      debugPrint('🔍 Initializing MemberModel');
      memberModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(householdMemberDomain.domain);
      _domainModelsTable['household_member'] = householdMemberDomain;

      // democracy direct
      debugPrint('🔍 Creating DemocracyDirectRepo');
      final democracyDirectRepo = dydt.DemocracyDirectRepo();

      debugPrint('🔍 Getting DemocracyDomain for Direct');
      dydt.DemocracyDomain democracyDirectDomain =
          democracyDirectRepo.getDomainModels("Democracy")
              as dydt.DemocracyDomain;

      debugPrint('🔍 Getting DirectModel');
      dydt.DirectModel directModel =
          democracyDirectDomain.getModelEntries("Direct") as dydt.DirectModel;

      debugPrint('🔍 Initializing DirectModel');
      directModel.init();

      debugPrint('🔍 Adding domain to _domains');
      _domains.add(democracyDirectDomain.domain);
      _domainModelsTable['democracy_direct'] = democracyDirectDomain;

      debugPrint('🔍 _initializeDomains completed successfully');
      debugPrint('🔍 Domains count after init: ${_domains.length}');
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _initializeDomains: $e');
      debugPrint('❌ StackTrace: $stackTrace');
    }

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

      // Add detailed debug for grouped domains
      for (var domain in _groupedDomains) {
        debugPrint(
          '🔍 Grouped Domain: ${domain.code}, Models: ${domain.models.length}',
        );
        for (var model in domain.models) {
          debugPrint(
            '   - Model: ${model.code}, Concepts: ${model.concepts.length}',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error in _groupDomains: $e');
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

  @override
  Domains get domains => _domains;
  @override
  Domains get groupedDomains => _groupedDomains;
  Map<String, DomainModels> get domainModels => _domainModelsTable;
}

import 'package:ednet_core/ednet_core.dart';

import 'package:ednet_one/generated/project/scheduling/lib/project_scheduling.dart' as ptsg;
import 'package:ednet_one/generated/project/core/lib/project_core.dart' as ptce;
import 'package:ednet_one/generated/project/brainstorming/lib/project_brainstorming.dart' as ptbg;
import 'package:ednet_one/generated/project/planning/lib/project_planning.dart' as ptpg;
import 'package:ednet_one/generated/project/kanban/lib/project_kanban.dart' as ptkn;
import 'package:ednet_one/generated/project/user/lib/project_user.dart' as ptur;
import 'package:ednet_one/generated/project/gtd/lib/project_gtd.dart' as ptgd;
import 'package:ednet_one/generated/household/finance/lib/household_finance.dart' as hdfe;
import 'package:ednet_one/generated/household/member/lib/household_member.dart' as hdmr;
import 'package:ednet_one/generated/communication/chat/lib/communication_chat.dart' as cnct;
import 'package:ednet_one/generated/democracy/direct/lib/democracy_direct.dart' as dydt;
// IMPORTS PLACEHOLDER

class OneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};

  OneApplication() {
    _initializeDomains();
    _groupDomains();
  }

  void _initializeDomains() {
        // project scheduling
    final projectSchedulingRepo = ptsg.ProjectSchedulingRepo();
    ptsg.ProjectDomain projectSchedulingDomain = projectSchedulingRepo
        .getDomainModels("Project") as ptsg.ProjectDomain;
    ptsg.SchedulingModel schedulingModel =
        projectSchedulingDomain.getModelEntries("Scheduling") as ptsg.SchedulingModel;
    schedulingModel.init();

    _domains..add(projectSchedulingDomain.domain);
    _domainModelsTable['project_scheduling'] = projectSchedulingDomain;

    // project core
    final projectCoreRepo = ptce.ProjectCoreRepo();
    ptce.ProjectDomain projectCoreDomain = projectCoreRepo
        .getDomainModels("Project") as ptce.ProjectDomain;
    ptce.CoreModel coreModel =
        projectCoreDomain.getModelEntries("Core") as ptce.CoreModel;
    coreModel.init();

    _domains..add(projectCoreDomain.domain);
    _domainModelsTable['project_core'] = projectCoreDomain;

    // project brainstorming
    final projectBrainstormingRepo = ptbg.ProjectBrainstormingRepo();
    ptbg.ProjectDomain projectBrainstormingDomain = projectBrainstormingRepo
        .getDomainModels("Project") as ptbg.ProjectDomain;
    ptbg.BrainstormingModel brainstormingModel =
        projectBrainstormingDomain.getModelEntries("Brainstorming") as ptbg.BrainstormingModel;
    brainstormingModel.init();

    _domains..add(projectBrainstormingDomain.domain);
    _domainModelsTable['project_brainstorming'] = projectBrainstormingDomain;

    // project planning
    final projectPlanningRepo = ptpg.ProjectPlanningRepo();
    ptpg.ProjectDomain projectPlanningDomain = projectPlanningRepo
        .getDomainModels("Project") as ptpg.ProjectDomain;
    ptpg.PlanningModel planningModel =
        projectPlanningDomain.getModelEntries("Planning") as ptpg.PlanningModel;
    planningModel.init();

    _domains..add(projectPlanningDomain.domain);
    _domainModelsTable['project_planning'] = projectPlanningDomain;

    // project kanban
    final projectKanbanRepo = ptkn.ProjectKanbanRepo();
    ptkn.ProjectDomain projectKanbanDomain = projectKanbanRepo
        .getDomainModels("Project") as ptkn.ProjectDomain;
    ptkn.KanbanModel kanbanModel =
        projectKanbanDomain.getModelEntries("Kanban") as ptkn.KanbanModel;
    kanbanModel.init();

    _domains..add(projectKanbanDomain.domain);
    _domainModelsTable['project_kanban'] = projectKanbanDomain;

    // project user
    final projectUserRepo = ptur.ProjectUserRepo();
    ptur.ProjectDomain projectUserDomain = projectUserRepo
        .getDomainModels("Project") as ptur.ProjectDomain;
    ptur.UserModel userModel =
        projectUserDomain.getModelEntries("User") as ptur.UserModel;
    userModel.init();

    _domains..add(projectUserDomain.domain);
    _domainModelsTable['project_user'] = projectUserDomain;

    // project gtd
    final projectGtdRepo = ptgd.ProjectGtdRepo();
    ptgd.ProjectDomain projectGtdDomain = projectGtdRepo
        .getDomainModels("Project") as ptgd.ProjectDomain;
    ptgd.GtdModel gtdModel =
        projectGtdDomain.getModelEntries("Gtd") as ptgd.GtdModel;
    gtdModel.init();

    _domains..add(projectGtdDomain.domain);
    _domainModelsTable['project_gtd'] = projectGtdDomain;

    // household finance
    final householdFinanceRepo = hdfe.HouseholdFinanceRepo();
    hdfe.HouseholdDomain householdFinanceDomain = householdFinanceRepo
        .getDomainModels("Household") as hdfe.HouseholdDomain;
    hdfe.FinanceModel financeModel =
        householdFinanceDomain.getModelEntries("Finance") as hdfe.FinanceModel;
    financeModel.init();

    _domains..add(householdFinanceDomain.domain);
    _domainModelsTable['household_finance'] = householdFinanceDomain;

    // household member
    final householdMemberRepo = hdmr.HouseholdMemberRepo();
    hdmr.HouseholdDomain householdMemberDomain = householdMemberRepo
        .getDomainModels("Household") as hdmr.HouseholdDomain;
    hdmr.MemberModel memberModel =
        householdMemberDomain.getModelEntries("Member") as hdmr.MemberModel;
    memberModel.init();

    _domains..add(householdMemberDomain.domain);
    _domainModelsTable['household_member'] = householdMemberDomain;

    // communication chat
    final communicationChatRepo = cnct.CommunicationChatRepo();
    cnct.CommunicationDomain communicationChatDomain = communicationChatRepo
        .getDomainModels("Communication") as cnct.CommunicationDomain;
    cnct.ChatModel chatModel =
        communicationChatDomain.getModelEntries("Chat") as cnct.ChatModel;
    chatModel.init();

    _domains..add(communicationChatDomain.domain);
    _domainModelsTable['communication_chat'] = communicationChatDomain;

    // democracy direct
    final democracyDirectRepo = dydt.DemocracyDirectRepo();
    dydt.DemocracyDomain democracyDirectDomain = democracyDirectRepo
        .getDomainModels("Democracy") as dydt.DemocracyDomain;
    dydt.DirectModel directModel =
        democracyDirectDomain.getModelEntries("Direct") as dydt.DirectModel;
    directModel.init();

    _domains..add(democracyDirectDomain.domain);
    _domainModelsTable['democracy_direct'] = democracyDirectDomain;

// INIT PLACEHOLDER
  }
  
  DomainModels getDomainModels(String domain, String model) {
    final domainModel = _domainModelsTable['${domain}_${model}'];
  
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

  Domains get domains => _domains;
  Domains get groupedDomains => _groupedDomains;
  Map<String, DomainModels> get domainModels => _domainModelsTable;
}

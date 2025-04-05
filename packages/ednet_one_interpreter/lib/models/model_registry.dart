import 'package:ednet_core/ednet_core.dart';

import 'package:ednet_one_interpreter/staging/democracy/direct/lib/democracy_direct.dart'
    as dydt;
import 'package:ednet_one_interpreter/staging/household/finance/lib/household_finance.dart'
    as hdfe;
import 'package:ednet_one_interpreter/staging/household/member/lib/household_member.dart'
    as hdmr;
import 'package:ednet_one_interpreter/staging/project/brainstorming/lib/project_brainstorming.dart'
    as ptbg;
import 'package:ednet_one_interpreter/staging/project/core/lib/project_core.dart'
    as ptce;
import 'package:ednet_one_interpreter/staging/project/gtd/lib/project_gtd.dart'
    as ptgd;
import 'package:ednet_one_interpreter/staging/project/kanban/lib/project_kanban.dart'
    as ptkn;
import 'package:ednet_one_interpreter/staging/project/planning/lib/project_planning.dart'
    as ptpg;
import 'package:ednet_one_interpreter/staging/project/scheduling/lib/project_scheduling.dart'
    as ptsg;
import 'package:ednet_one_interpreter/staging/project/user/lib/project_user.dart'
    as ptur;
import 'package:ednet_one_interpreter/staging/settings/application/lib/settings_application.dart'
    as ssan;

/// Data class to hold a domain model pair
class DomainModelPair {
  final Domain domain;
  final String modelCode;
  final DomainModels domainModels;

  const DomainModelPair({
    required this.domain,
    required this.modelCode,
    required this.domainModels,
  });
}

/// Central registry for all domain models in the application.
///
/// This class is responsible for initializing and providing access to all
/// domain models used in the application. It serves as a factory for creating
/// domain model instances and manages their lifecycle.
class ModelRegistry {
  /// Returns a list of all domain models used in the application
  static List<DomainModelPair> getDomainModels() {
    final List<DomainModelPair> models = [];

    // Settings Application
    final settingsApplicationRepo = ssan.SettingsApplicationRepo();
    final settingsApplicationDomain =
        settingsApplicationRepo.getDomainModels("Settings")
            as ssan.SettingsDomain;
    final applicationModel =
        settingsApplicationDomain.getModelEntries("Application")
            as ssan.ApplicationModel;
    applicationModel.init();
    models.add(
      DomainModelPair(
        domain: settingsApplicationDomain.domain,
        modelCode: "Application",
        domainModels: settingsApplicationDomain,
      ),
    );

    // Project Scheduling
    final projectSchedulingRepo = ptsg.ProjectSchedulingRepo();
    final projectSchedulingDomain =
        projectSchedulingRepo.getDomainModels("Project") as ptsg.ProjectDomain;
    final schedulingModel =
        projectSchedulingDomain.getModelEntries("Scheduling")
            as ptsg.SchedulingModel;
    schedulingModel.init();
    models.add(
      DomainModelPair(
        domain: projectSchedulingDomain.domain,
        modelCode: "Scheduling",
        domainModels: projectSchedulingDomain,
      ),
    );

    // Project Core
    final projectCoreRepo = ptce.ProjectCoreRepo();
    final projectCoreDomain =
        projectCoreRepo.getDomainModels("Project") as ptce.ProjectDomain;
    final coreModel =
        projectCoreDomain.getModelEntries("Core") as ptce.CoreModel;
    coreModel.init();
    models.add(
      DomainModelPair(
        domain: projectCoreDomain.domain,
        modelCode: "Core",
        domainModels: projectCoreDomain,
      ),
    );

    // Project Brainstorming
    final projectBrainstormingRepo = ptbg.ProjectBrainstormingRepo();
    final projectBrainstormingDomain =
        projectBrainstormingRepo.getDomainModels("Project")
            as ptbg.ProjectDomain;
    final brainstormingModel =
        projectBrainstormingDomain.getModelEntries("Brainstorming")
            as ptbg.BrainstormingModel;
    brainstormingModel.init();
    models.add(
      DomainModelPair(
        domain: projectBrainstormingDomain.domain,
        modelCode: "Brainstorming",
        domainModels: projectBrainstormingDomain,
      ),
    );

    // Project Planning
    final projectPlanningRepo = ptpg.ProjectPlanningRepo();
    final projectPlanningDomain =
        projectPlanningRepo.getDomainModels("Project") as ptpg.ProjectDomain;
    final planningModel =
        projectPlanningDomain.getModelEntries("Planning") as ptpg.PlanningModel;
    planningModel.init();
    models.add(
      DomainModelPair(
        domain: projectPlanningDomain.domain,
        modelCode: "Planning",
        domainModels: projectPlanningDomain,
      ),
    );

    // Project Kanban
    final projectKanbanRepo = ptkn.ProjectKanbanRepo();
    final projectKanbanDomain =
        projectKanbanRepo.getDomainModels("Project") as ptkn.ProjectDomain;
    final kanbanModel =
        projectKanbanDomain.getModelEntries("Kanban") as ptkn.KanbanModel;
    kanbanModel.init();
    models.add(
      DomainModelPair(
        domain: projectKanbanDomain.domain,
        modelCode: "Kanban",
        domainModels: projectKanbanDomain,
      ),
    );

    // Project User
    final projectUserRepo = ptur.ProjectUserRepo();
    final projectUserDomain =
        projectUserRepo.getDomainModels("Project") as ptur.ProjectDomain;
    final userModel =
        projectUserDomain.getModelEntries("User") as ptur.UserModel;
    userModel.init();
    models.add(
      DomainModelPair(
        domain: projectUserDomain.domain,
        modelCode: "User",
        domainModels: projectUserDomain,
      ),
    );

    // Project GTD
    final projectGtdRepo = ptgd.ProjectGtdRepo();
    final projectGtdDomain =
        projectGtdRepo.getDomainModels("Project") as ptgd.ProjectDomain;
    final gtdModel = projectGtdDomain.getModelEntries("Gtd") as ptgd.GtdModel;
    gtdModel.init();
    models.add(
      DomainModelPair(
        domain: projectGtdDomain.domain,
        modelCode: "Gtd",
        domainModels: projectGtdDomain,
      ),
    );

    // Household Finance
    final householdFinanceRepo = hdfe.HouseholdFinanceRepo();
    final householdFinanceDomain =
        householdFinanceRepo.getDomainModels("Household")
            as hdfe.HouseholdDomain;
    final financeModel =
        householdFinanceDomain.getModelEntries("Finance") as hdfe.FinanceModel;
    financeModel.init();
    models.add(
      DomainModelPair(
        domain: householdFinanceDomain.domain,
        modelCode: "Finance",
        domainModels: householdFinanceDomain,
      ),
    );

    // Household Member
    final householdMemberRepo = hdmr.HouseholdMemberRepo();
    final householdMemberDomain =
        householdMemberRepo.getDomainModels("Household")
            as hdmr.HouseholdDomain;
    final memberModel =
        householdMemberDomain.getModelEntries("Member") as hdmr.MemberModel;
    memberModel.init();
    models.add(
      DomainModelPair(
        domain: householdMemberDomain.domain,
        modelCode: "Member",
        domainModels: householdMemberDomain,
      ),
    );

    // Democracy Direct
    final democracyDirectRepo = dydt.DemocracyDirectRepo();
    final democracyDirectDomain =
        democracyDirectRepo.getDomainModels("Democracy")
            as dydt.DemocracyDomain;
    final directModel =
        democracyDirectDomain.getModelEntries("Direct") as dydt.DirectModel;
    directModel.init();
    models.add(
      DomainModelPair(
        domain: democracyDirectDomain.domain,
        modelCode: "Direct",
        domainModels: democracyDirectDomain,
      ),
    );

    return models;
  }
}

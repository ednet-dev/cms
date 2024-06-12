import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/hausehold/finance/lib/household_finance.dart'
    as hdfe;
import 'package:ednet_one/generated/hausehold/member/lib/household_member.dart'
    as hdmr;
import 'package:ednet_one/generated/project/brainstorming/lib/project_brainstorming.dart'
    as ptbg;
import 'package:ednet_one/generated/project/core/lib/project_core.dart' as ptce;
import 'package:ednet_one/generated/project/gtd/lib/project_gtd.dart' as ptgd;
import 'package:ednet_one/generated/project/kanban/lib/project_kanban.dart'
    as ptkn;
import 'package:ednet_one/generated/project/planning/lib/project_planning.dart'
    as ptpg;
import 'package:ednet_one/generated/project/scheduling/lib/project_scheduling.dart'
    as ptsg;
import 'package:ednet_one/generated/project/user/lib/project_user.dart' as ptur;

class OneApplication {
  final Domains _domains = Domains();

  OneApplication() {
    _initializeDomains();
  }

  void _initializeDomains() {
    // household finance
    final householdFinanceRepo = hdfe.HouseholdFinanceRepo();
    hdfe.HouseholdDomain householdFinanceDomain = householdFinanceRepo
        .getDomainModels("Household") as hdfe.HouseholdDomain;
    hdfe.FinanceModel financeModel =
        householdFinanceDomain.getModelEntries("Finance") as hdfe.FinanceModel;
    financeModel.init();

    // household member
    final householdMemberRepo = hdmr.HouseholdMemberRepo();
    hdmr.HouseholdDomain householdMemberDomain = householdMemberRepo
        .getDomainModels("Household") as hdmr.HouseholdDomain;
    hdmr.MemberModel memberModel =
        householdMemberDomain.getModelEntries("Member") as hdmr.MemberModel;
    memberModel.init();

    // project brainstorming
    final projectBrainstormingRepo = ptbg.ProjectBrainstormingRepo();
    ptbg.ProjectDomain projectBrainstormingDomain = projectBrainstormingRepo
        .getDomainModels("Project") as ptbg.ProjectDomain;
    ptbg.BrainstormingModel brainstormingModel = projectBrainstormingDomain
        .getModelEntries("Brainstorming") as ptbg.BrainstormingModel;
    brainstormingModel.init();

    // project core
    final projectCoreRepo = ptce.ProjectCoreRepo();
    ptce.ProjectDomain projectCoreDomain =
        projectCoreRepo.getDomainModels("Project") as ptce.ProjectDomain;
    ptce.CoreModel coreModel =
        projectCoreDomain.getModelEntries("Core") as ptce.CoreModel;
    coreModel.init();

    // project gtd
    final projectGtdRepo = ptgd.ProjectGtdRepo();
    ptgd.ProjectDomain projectGtdDomain =
        projectGtdRepo.getDomainModels("Project") as ptgd.ProjectDomain;
    ptgd.GtdModel gtdModel =
        projectGtdDomain.getModelEntries("Gtd") as ptgd.GtdModel;

    // project kanban
    final projectKanbanRepo = ptkn.ProjectKanbanRepo();
    ptkn.ProjectDomain projectKanbanDomain =
        projectKanbanRepo.getDomainModels("Project") as ptkn.ProjectDomain;
    ptkn.KanbanModel kanbanModel =
        projectKanbanDomain.getModelEntries("Kanban") as ptkn.KanbanModel;
    kanbanModel.init();

    // project planning
    final projectPlanningRepo = ptpg.ProjectPlanningRepo();
    ptpg.ProjectDomain projectPlanningDomain =
        projectPlanningRepo.getDomainModels("Project") as ptpg.ProjectDomain;
    ptpg.PlanningModel planningModel =
        projectPlanningDomain.getModelEntries("Planning") as ptpg.PlanningModel;
    planningModel.init();

    // project scheduling
    final projectSchedulingRepo = ptsg.ProjectSchedulingRepo();
    ptsg.ProjectDomain projectSchedulingDomain =
        projectSchedulingRepo.getDomainModels("Project") as ptsg.ProjectDomain;
    ptsg.SchedulingModel schedulingModel = projectSchedulingDomain
        .getModelEntries("Scheduling") as ptsg.SchedulingModel;
    schedulingModel.init();

    // project user
    final projectUserRepo = ptur.ProjectUserRepo();
    ptur.ProjectDomain projectUserDomain =
        projectUserRepo.getDomainModels("Project") as ptur.ProjectDomain;
    ptur.UserModel userModel =
        projectUserDomain.getModelEntries("User") as ptur.UserModel;
    userModel.init();

    _domains
      ..add(householdFinanceDomain.domain)
      ..add(householdMemberDomain.domain)
      ..add(projectBrainstormingDomain.domain)
      ..add(projectCoreDomain.domain)
      ..add(projectGtdDomain.domain)
      ..add(projectKanbanDomain.domain)
      ..add(projectPlanningDomain.domain)
      ..add(projectSchedulingDomain.domain)
      ..add(projectUserDomain.domain);
  }

  Domains get domains => _domains;
}

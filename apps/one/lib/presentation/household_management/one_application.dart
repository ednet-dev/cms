import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/hausehold/finance/lib/household_finance.dart'
    as hf;
import 'package:ednet_one/generated/hausehold/member/lib/household_member.dart'
    as hm;
import 'package:ednet_one/generated/project/brainstorming/lib/project_brainstorming.dart'
    as pb;
import 'package:ednet_one/generated/project/core/lib/project_core.dart' as pc;
import 'package:ednet_one/generated/project/gtd/lib/project_gtd.dart' as pg;
import 'package:ednet_one/generated/project/kanban/lib/project_kanban.dart'
    as pk;
import 'package:ednet_one/generated/project/planning/lib/project_planning.dart'
    as pp;
import 'package:ednet_one/generated/project/scheduling/lib/project_scheduling.dart'
    as ps;
import 'package:ednet_one/generated/project/user/lib/project_user.dart' as pu;

class OneApplication {
  final Domains _domains = Domains();

  OneApplication() {
    _initializeDomains();
  }

  void _initializeDomains() {
    // household finance
    final householdFinanceRepo = hf.HouseholdFinanceRepo();
    hf.HouseholdDomain householdFinanceDomain =
        householdFinanceRepo.getDomainModels("Household") as hf.HouseholdDomain;
    hf.FinanceModel financeModel =
        householdFinanceDomain.getModelEntries("Finance") as hf.FinanceModel;
    financeModel.init();

    // household member
    final householdMemberRepo = hm.HouseholdMemberRepo();
    hm.HouseholdDomain householdMemberDomain =
        householdMemberRepo.getDomainModels("Household") as hm.HouseholdDomain;
    hm.MemberModel memberModel =
        householdMemberDomain.getModelEntries("Member") as hm.MemberModel;
    memberModel.init();

    // project brainstorming
    final projectBrainstormingRepo = pb.ProjectBrainstormingRepo();
    pb.ProjectDomain projectBrainstormingDomain =
        projectBrainstormingRepo.getDomainModels("Project") as pb.ProjectDomain;
    pb.BrainstormingModel brainstormingModel = projectBrainstormingDomain
        .getModelEntries("Brainstorming") as pb.BrainstormingModel;
    brainstormingModel.init();

    // project core
    final projectCoreRepo = pc.ProjectCoreRepo();
    pc.ProjectDomain projectCoreDomain =
        projectCoreRepo.getDomainModels("Project") as pc.ProjectDomain;
    pc.CoreModel coreModel =
        projectCoreDomain.getModelEntries("Core") as pc.CoreModel;
    coreModel.init();

    // project gtd
    final projectGtdRepo = pg.ProjectGtdRepo();
    pg.ProjectDomain projectGtdDomain =
        projectGtdRepo.getDomainModels("Project") as pg.ProjectDomain;
    pg.GtdModel gtdModel =
        projectGtdDomain.getModelEntries("Gtd") as pg.GtdModel;

    // project kanban
    final projectKanbanRepo = pk.ProjectKanbanRepo();
    pk.ProjectDomain projectKanbanDomain =
        projectKanbanRepo.getDomainModels("Project") as pk.ProjectDomain;
    pk.KanbanModel kanbanModel =
        projectKanbanDomain.getModelEntries("Kanban") as pk.KanbanModel;
    kanbanModel.init();

    // project planning
    final projectPlanningRepo = pp.ProjectPlanningRepo();
    pp.ProjectDomain projectPlanningDomain =
        projectPlanningRepo.getDomainModels("Project") as pp.ProjectDomain;
    pp.PlanningModel planningModel =
        projectPlanningDomain.getModelEntries("Planning") as pp.PlanningModel;
    planningModel.init();

    // project scheduling
    final projectSchedulingRepo = ps.ProjectSchedulingRepo();
    ps.ProjectDomain projectSchedulingDomain =
        projectSchedulingRepo.getDomainModels("Project") as ps.ProjectDomain;
    ps.SchedulingModel schedulingModel = projectSchedulingDomain
        .getModelEntries("Scheduling") as ps.SchedulingModel;
    schedulingModel.init();

    // project user
    final projectUserRepo = pu.ProjectUserRepo();
    pu.ProjectDomain projectUserDomain =
        projectUserRepo.getDomainModels("Project") as pu.ProjectDomain;
    pu.UserModel userModel =
        projectUserDomain.getModelEntries("User") as pu.UserModel;
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

part of '../../project_core.dart';
// lib/project/core/model.dart

class CoreModel extends CoreEntries {
  CoreModel(super.model);

  void fromJsonToTaskEntry() {
    fromJsonToEntry(projectCoreTaskEntry);
  }

  void fromJsonToProjectEntry() {
    fromJsonToEntry(projectCoreProjectEntry);
  }

  void fromJsonToMilestoneEntry() {
    fromJsonToEntry(projectCoreMilestoneEntry);
  }

  void fromJsonToResourceEntry() {
    fromJsonToEntry(projectCoreResourceEntry);
  }

  void fromJsonToRoleEntry() {
    fromJsonToEntry(projectCoreRoleEntry);
  }

  void fromJsonToTeamEntry() {
    fromJsonToEntry(projectCoreTeamEntry);
  }

  void fromJsonToSkillEntry() {
    fromJsonToEntry(projectCoreSkillEntry);
  }

  void fromJsonToTimeEntry() {
    fromJsonToEntry(projectCoreTimeEntry);
  }

  void fromJsonToBudgetEntry() {
    fromJsonToEntry(projectCoreBudgetEntry);
  }

  void fromJsonToInitiativeEntry() {
    fromJsonToEntry(projectCoreInitiativeEntry);
  }

  void fromJsonToModel() {
    fromJson(projectCoreModel);
  }

  void init() {
    initProjects();
    initTasks();
    initResources();
    initTeams();
    initMilestones();
    initRoles();
    initSkills();
    initTimes();
    initBudgets();
    initInitiatives();
  }

  /// Demo Data Initialization with More Realistic Valuesclass DemoData {
  void initTasks() {
    final task1 = Task(tasks.concept)
      ..title = 'Design Marketing Campaign'
      ..dueDate = DateTime.now().add(const Duration(days: 7))
      ..status = 'In Progress'
      ..priority = 'High';
    final task1Project = projects.random();
    task1.project = task1Project;
    tasks.add(task1);
    task1Project.tasks.add(task1);

    final task2 = Task(tasks.concept)
      ..title = 'Implement Payment Integration'
      ..dueDate = DateTime.now().add(const Duration(days: 14))
      ..status = 'Open'
      ..priority = 'Critical';
    final task2Project = projects.random();
    task2.project = task2Project;
    tasks.add(task2);
    task2Project.tasks.add(task2);
  }

  void initProjects() {
    final project1 = Project(projects.concept)
      ..name = 'Alpha Platform'
      ..description = 'A next-gen platform for early adopters'
      ..startDate = DateTime.now().subtract(const Duration(days: 30))
      ..endDate = DateTime.now().add(const Duration(days: 60))
      ..budget = 125000.00;
    projects.add(project1);

    final project2 = Project(projects.concept)
      ..name = 'Beta Launch'
      ..description = 'Public launch of new product'
      ..startDate = DateTime.now()
      ..endDate = DateTime.now().add(const Duration(days: 120))
      ..budget = 300000.00;
    projects.add(project2);
  }

  void initMilestones() {
    final milestone1 = Milestone(milestones.concept)
      ..name = 'MVP Release'
      ..date = DateTime.now().add(const Duration(days: 10));
    final milestone1Project = projects.random();
    milestone1.project = milestone1Project;
    milestones.add(milestone1);
    milestone1Project.milestones.add(milestone1);

    final milestone2 = Milestone(milestones.concept)
      ..name = 'Go Live'
      ..date = DateTime.now().add(const Duration(days: 45));
    final milestone2Project = projects.random();
    milestone2.project = milestone2Project;
    milestones.add(milestone2);
    milestone2Project.milestones.add(milestone2);
  }

  void initResources() {
    final resource1 = Resource(resources.concept)
      ..name = 'Graphic Designer'
      ..type = 'Design'
      ..cost = 400.0;
    final resource1Task = tasks.random();
    resource1.task = resource1Task;
    resources.add(resource1);
    resource1Task.resources.add(resource1);

    final resource2 = Resource(resources.concept)
      ..name = 'Backend Developer'
      ..type = 'Engineering'
      ..cost = 950.0;
    final resource2Task = tasks.random();
    resource2.task = resource2Task;
    resources.add(resource2);
    resource2Task.resources.add(resource2);
  }

  void initRoles() {
    final role1 = Role(roles.concept)
      ..title = 'Project Manager'
      ..responsibility = 'Coordinate team and project tasks';
    final role1Team = teams.random();
    role1.team = role1Team;
    roles.add(role1);
    role1Team.roles.add(role1);

    final role2 = Role(roles.concept)
      ..title = 'Software Engineer'
      ..responsibility = 'Implement features and fix bugs';
    final role2Team = teams.random();
    role2.team = role2Team;
    roles.add(role2);
    role2Team.roles.add(role2);
  }

  void initTeams() {
    final team1 = Team(teams.concept)..name = 'Development Team';
    final team1Project = projects.random();
    team1.project = team1Project;
    teams.add(team1);
    team1Project.teams.add(team1);

    final team2 = Team(teams.concept)..name = 'Marketing Team';
    final team2Project = projects.random();
    team2.project = team2Project;
    teams.add(team2);
    team2Project.teams.add(team2);
  }

  void initSkills() {
    final skill1 = Skill(skills.concept)
      ..name = 'UI Design'
      ..level = 'Advanced';
    final skill1Resource = resources.random();
    skill1.resource = skill1Resource;
    skills.add(skill1);
    skill1Resource.skills.add(skill1);

    final skill2 = Skill(skills.concept)
      ..name = 'REST API Development'
      ..level = 'Intermediate';
    final skill2Resource = resources.random();
    skill2.resource = skill2Resource;
    skills.add(skill2);
    skill2Resource.skills.add(skill2);
  }

  void initTimes() {
    final time1 = Time(times.concept)..hours = 80;
    final time1Project = projects.random();
    time1.project = time1Project;
    times.add(time1);
    time1Project.times.add(time1);

    final time2 = Time(times.concept)..hours = 40;
    final time2Project = projects.random();
    time2.project = time2Project;
    times.add(time2);
    time2Project.times.add(time2);
  }

  void initBudgets() {
    final budget1 = Budget(budgets.concept)
      ..amount = 5000.0
      ..currency = 'USD';
    final budget1Project = projects.random();
    budget1.project = budget1Project;
    budgets.add(budget1);
    budget1Project.budgets.add(budget1);

    final budget2 = Budget(budgets.concept)
      ..amount = 12000.0
      ..currency = 'USD';
    final budget2Project = projects.random();
    budget2.project = budget2Project;
    budgets.add(budget2);
    budget2Project.budgets.add(budget2);
  }

  void initInitiatives() {
    final initiative1 = Initiative(initiatives.concept)
      ..name = 'Community Outreach';
    final initiative1Project = projects.random();
    initiative1.project = initiative1Project;
    initiatives.add(initiative1);
    initiative1Project.initiatives.add(initiative1);

    final initiative2 = Initiative(initiatives.concept)
      ..name = 'Security Audit';
    final initiative2Project = projects.random();
    initiative2.project = initiative2Project;
    initiatives.add(initiative2);
    initiative2Project.initiatives.add(initiative2);
  }

  // added after code gen - begin

  // added after code gen - end
}

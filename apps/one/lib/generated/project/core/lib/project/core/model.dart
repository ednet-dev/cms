 
part of project_core; 
 
// lib/project/core/model.dart 
 
class CoreModel extends CoreEntries { 
 
  CoreModel(Model model) : super(model); 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(projectCoreProjectEntry); 
  } 
 
  void fromJsonToTaskEntry() { 
    fromJsonToEntry(projectCoreTaskEntry); 
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
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    project1.name = 'sun'; 
    project1.description = 'consulting'; 
    project1.startDate = new DateTime.now(); 
    project1.endDate = new DateTime.now(); 
    project1.budget = 80.61393965577956; 
    projects.add(project1); 
 
    var project2 = Project(projects.concept); 
    project2.name = 'price'; 
    project2.description = 'tent'; 
    project2.startDate = new DateTime.now(); 
    project2.endDate = new DateTime.now(); 
    project2.budget = 16.42034977407052; 
    projects.add(project2); 
 
    var project3 = Project(projects.concept); 
    project3.name = 'series'; 
    project3.description = 'call'; 
    project3.startDate = new DateTime.now(); 
    project3.endDate = new DateTime.now(); 
    project3.budget = 38.31794000044471; 
    projects.add(project3); 
 
  } 
 
  void initTasks() { 
    var task1 = Task(tasks.concept); 
    task1.title = 'book'; 
    task1.dueDate = new DateTime.now(); 
    task1.status = 'course'; 
    task1.priority = 'place'; 
    var task1Project = projects.random(); 
    task1.project = task1Project; 
    tasks.add(task1); 
    task1Project.tasks.add(task1); 
 
    var task2 = Task(tasks.concept); 
    task2.title = 'baby'; 
    task2.dueDate = new DateTime.now(); 
    task2.status = 'big'; 
    task2.priority = 'school'; 
    var task2Project = projects.random(); 
    task2.project = task2Project; 
    tasks.add(task2); 
    task2Project.tasks.add(task2); 
 
    var task3 = Task(tasks.concept); 
    task3.title = 'small'; 
    task3.dueDate = new DateTime.now(); 
    task3.status = 'university'; 
    task3.priority = 'software'; 
    var task3Project = projects.random(); 
    task3.project = task3Project; 
    tasks.add(task3); 
    task3Project.tasks.add(task3); 
 
  } 
 
  void initMilestones() { 
    var milestone1 = Milestone(milestones.concept); 
    milestone1.name = 'house'; 
    milestone1.date = new DateTime.now(); 
    var milestone1Project = projects.random(); 
    milestone1.project = milestone1Project; 
    milestones.add(milestone1); 
    milestone1Project.milestones.add(milestone1); 
 
    var milestone2 = Milestone(milestones.concept); 
    milestone2.name = 'sun'; 
    milestone2.date = new DateTime.now(); 
    var milestone2Project = projects.random(); 
    milestone2.project = milestone2Project; 
    milestones.add(milestone2); 
    milestone2Project.milestones.add(milestone2); 
 
    var milestone3 = Milestone(milestones.concept); 
    milestone3.name = 'sun'; 
    milestone3.date = new DateTime.now(); 
    var milestone3Project = projects.random(); 
    milestone3.project = milestone3Project; 
    milestones.add(milestone3); 
    milestone3Project.milestones.add(milestone3); 
 
  } 
 
  void initResources() { 
    var resource1 = Resource(resources.concept); 
    resource1.name = 'office'; 
    resource1.type = 'slate'; 
    resource1.cost = 17.686972663453602; 
    var resource1Task = tasks.random(); 
    resource1.task = resource1Task; 
    resources.add(resource1); 
    resource1Task.resources.add(resource1); 
 
    var resource2 = Resource(resources.concept); 
    resource2.name = 'tension'; 
    resource2.type = 'music'; 
    resource2.cost = 56.02562335824586; 
    var resource2Task = tasks.random(); 
    resource2.task = resource2Task; 
    resources.add(resource2); 
    resource2Task.resources.add(resource2); 
 
    var resource3 = Resource(resources.concept); 
    resource3.name = 'place'; 
    resource3.type = 'grading'; 
    resource3.cost = 7.455310007089622; 
    var resource3Task = tasks.random(); 
    resource3.task = resource3Task; 
    resources.add(resource3); 
    resource3Task.resources.add(resource3); 
 
  } 
 
  void initRoles() { 
    var role1 = Role(roles.concept); 
    role1.title = 'top'; 
    role1.responsibility = 'word'; 
    var role1Team = teams.random(); 
    role1.team = role1Team; 
    roles.add(role1); 
    role1Team.roles.add(role1); 
 
    var role2 = Role(roles.concept); 
    role2.title = 'bird'; 
    role2.responsibility = 'restaurant'; 
    var role2Team = teams.random(); 
    role2.team = role2Team; 
    roles.add(role2); 
    role2Team.roles.add(role2); 
 
    var role3 = Role(roles.concept); 
    role3.title = 'productivity'; 
    role3.responsibility = 'tension'; 
    var role3Team = teams.random(); 
    role3.team = role3Team; 
    roles.add(role3); 
    role3Team.roles.add(role3); 
 
  } 
 
  void initTeams() { 
    var team1 = Team(teams.concept); 
    team1.name = 'room'; 
    var team1Project = projects.random(); 
    team1.project = team1Project; 
    teams.add(team1); 
    team1Project.teams.add(team1); 
 
    var team2 = Team(teams.concept); 
    team2.name = 'capacity'; 
    var team2Project = projects.random(); 
    team2.project = team2Project; 
    teams.add(team2); 
    team2Project.teams.add(team2); 
 
    var team3 = Team(teams.concept); 
    team3.name = 'left'; 
    var team3Project = projects.random(); 
    team3.project = team3Project; 
    teams.add(team3); 
    team3Project.teams.add(team3); 
 
  } 
 
  void initSkills() { 
    var skill1 = Skill(skills.concept); 
    skill1.name = 'saving'; 
    skill1.level = 'series'; 
    var skill1Resource = resources.random(); 
    skill1.resource = skill1Resource; 
    skills.add(skill1); 
    skill1Resource.skills.add(skill1); 
 
    var skill2 = Skill(skills.concept); 
    skill2.name = 'beginning'; 
    skill2.level = 'darts'; 
    var skill2Resource = resources.random(); 
    skill2.resource = skill2Resource; 
    skills.add(skill2); 
    skill2Resource.skills.add(skill2); 
 
    var skill3 = Skill(skills.concept); 
    skill3.name = 'computer'; 
    skill3.level = 'accomodation'; 
    var skill3Resource = resources.random(); 
    skill3.resource = skill3Resource; 
    skills.add(skill3); 
    skill3Resource.skills.add(skill3); 
 
  } 
 
  void initTimes() { 
    var time1 = Time(times.concept); 
    time1.hours = 3445; 
    var time1Project = projects.random(); 
    time1.project = time1Project; 
    times.add(time1); 
    time1Project.times.add(time1); 
 
    var time2 = Time(times.concept); 
    time2.hours = 43; 
    var time2Project = projects.random(); 
    time2.project = time2Project; 
    times.add(time2); 
    time2Project.times.add(time2); 
 
    var time3 = Time(times.concept); 
    time3.hours = 7446; 
    var time3Project = projects.random(); 
    time3.project = time3Project; 
    times.add(time3); 
    time3Project.times.add(time3); 
 
  } 
 
  void initBudgets() { 
    var budget1 = Budget(budgets.concept); 
    budget1.amount = 78.87845463064042; 
    budget1.currency = 'kids'; 
    var budget1Project = projects.random(); 
    budget1.project = budget1Project; 
    budgets.add(budget1); 
    budget1Project.budgets.add(budget1); 
 
    var budget2 = Budget(budgets.concept); 
    budget2.amount = 12.18814800176422; 
    budget2.currency = 'oil'; 
    var budget2Project = projects.random(); 
    budget2.project = budget2Project; 
    budgets.add(budget2); 
    budget2Project.budgets.add(budget2); 
 
    var budget3 = Budget(budgets.concept); 
    budget3.amount = 50.09503566559906; 
    budget3.currency = 'auto'; 
    var budget3Project = projects.random(); 
    budget3.project = budget3Project; 
    budgets.add(budget3); 
    budget3Project.budgets.add(budget3); 
 
  } 
 
  void initInitiatives() { 
    var initiative1 = Initiative(initiatives.concept); 
    initiative1.name = 'tag'; 
    var initiative1Project = projects.random(); 
    initiative1.project = initiative1Project; 
    initiatives.add(initiative1); 
    initiative1Project.initiatives.add(initiative1); 
 
    var initiative2 = Initiative(initiatives.concept); 
    initiative2.name = 'horse'; 
    var initiative2Project = projects.random(); 
    initiative2.project = initiative2Project; 
    initiatives.add(initiative2); 
    initiative2Project.initiatives.add(initiative2); 
 
    var initiative3 = Initiative(initiatives.concept); 
    initiative3.name = 'tape'; 
    var initiative3Project = projects.random(); 
    initiative3.project = initiative3Project; 
    initiatives.add(initiative3); 
    initiative3Project.initiatives.add(initiative3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

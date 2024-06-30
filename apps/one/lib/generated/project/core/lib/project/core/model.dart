 
part of project_core; 
 
// lib/project/core/model.dart 
 
class CoreModel extends CoreEntries { 
 
  CoreModel(Model model) : super(model); 
 
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
 
  void initTasks() { 
    var task1 = Task(tasks.concept); 
    task1.title = 'baby'; 
    task1.dueDate = new DateTime.now(); 
    task1.status = 'selfie'; 
    task1.priority = 'price'; 
    var task1Project = projects.random(); 
    task1.project = task1Project; 
    tasks.add(task1); 
    task1Project.tasks.add(task1); 
 
    var task2 = Task(tasks.concept); 
    task2.title = 'salary'; 
    task2.dueDate = new DateTime.now(); 
    task2.status = 'element'; 
    task2.priority = 'table'; 
    var task2Project = projects.random(); 
    task2.project = task2Project; 
    tasks.add(task2); 
    task2Project.tasks.add(task2); 
 
    var task3 = Task(tasks.concept); 
    task3.title = 'salary'; 
    task3.dueDate = new DateTime.now(); 
    task3.status = 'video'; 
    task3.priority = 'output'; 
    var task3Project = projects.random(); 
    task3.project = task3Project; 
    tasks.add(task3); 
    task3Project.tasks.add(task3); 
 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    project1.name = 'fascination'; 
    project1.description = 'wheat'; 
    project1.startDate = new DateTime.now(); 
    project1.endDate = new DateTime.now(); 
    project1.budget = 3.3358141031242905; 
    projects.add(project1); 
 
    var project2 = Project(projects.concept); 
    project2.name = 'mind'; 
    project2.description = 'salary'; 
    project2.startDate = new DateTime.now(); 
    project2.endDate = new DateTime.now(); 
    project2.budget = 48.48520840940507; 
    projects.add(project2); 
 
    var project3 = Project(projects.concept); 
    project3.name = 'craving'; 
    project3.description = 'milk'; 
    project3.startDate = new DateTime.now(); 
    project3.endDate = new DateTime.now(); 
    project3.budget = 98.07084016182559; 
    projects.add(project3); 
 
  } 
 
  void initMilestones() { 
    var milestone1 = Milestone(milestones.concept); 
    milestone1.name = 'video'; 
    milestone1.date = new DateTime.now(); 
    var milestone1Project = projects.random(); 
    milestone1.project = milestone1Project; 
    milestones.add(milestone1); 
    milestone1Project.milestones.add(milestone1); 
 
    var milestone2 = Milestone(milestones.concept); 
    milestone2.name = 'edition'; 
    milestone2.date = new DateTime.now(); 
    var milestone2Project = projects.random(); 
    milestone2.project = milestone2Project; 
    milestones.add(milestone2); 
    milestone2Project.milestones.add(milestone2); 
 
    var milestone3 = Milestone(milestones.concept); 
    milestone3.name = 'table'; 
    milestone3.date = new DateTime.now(); 
    var milestone3Project = projects.random(); 
    milestone3.project = milestone3Project; 
    milestones.add(milestone3); 
    milestone3Project.milestones.add(milestone3); 
 
  } 
 
  void initResources() { 
    var resource1 = Resource(resources.concept); 
    resource1.name = 'test'; 
    resource1.type = 'ocean'; 
    resource1.cost = 37.38354256857572; 
    var resource1Task = tasks.random(); 
    resource1.task = resource1Task; 
    resources.add(resource1); 
    resource1Task.resources.add(resource1); 
 
    var resource2 = Resource(resources.concept); 
    resource2.name = 'thing'; 
    resource2.type = 'music'; 
    resource2.cost = 28.273959773674218; 
    var resource2Task = tasks.random(); 
    resource2.task = resource2Task; 
    resources.add(resource2); 
    resource2Task.resources.add(resource2); 
 
    var resource3 = Resource(resources.concept); 
    resource3.name = 'call'; 
    resource3.type = 'place'; 
    resource3.cost = 77.12757225129072; 
    var resource3Task = tasks.random(); 
    resource3.task = resource3Task; 
    resources.add(resource3); 
    resource3Task.resources.add(resource3); 
 
  } 
 
  void initRoles() { 
    var role1 = Role(roles.concept); 
    role1.title = 'coffee'; 
    role1.responsibility = 'email'; 
    var role1Team = teams.random(); 
    role1.team = role1Team; 
    roles.add(role1); 
    role1Team.roles.add(role1); 
 
    var role2 = Role(roles.concept); 
    role2.title = 'discount'; 
    role2.responsibility = 'deep'; 
    var role2Team = teams.random(); 
    role2.team = role2Team; 
    roles.add(role2); 
    role2Team.roles.add(role2); 
 
    var role3 = Role(roles.concept); 
    role3.title = 'down'; 
    role3.responsibility = 'point'; 
    var role3Team = teams.random(); 
    role3.team = role3Team; 
    roles.add(role3); 
    role3Team.roles.add(role3); 
 
  } 
 
  void initTeams() { 
    var team1 = Team(teams.concept); 
    team1.name = 'truck'; 
    var team1Project = projects.random(); 
    team1.project = team1Project; 
    teams.add(team1); 
    team1Project.teams.add(team1); 
 
    var team2 = Team(teams.concept); 
    team2.name = 'offence'; 
    var team2Project = projects.random(); 
    team2.project = team2Project; 
    teams.add(team2); 
    team2Project.teams.add(team2); 
 
    var team3 = Team(teams.concept); 
    team3.name = 'tall'; 
    var team3Project = projects.random(); 
    team3.project = team3Project; 
    teams.add(team3); 
    team3Project.teams.add(team3); 
 
  } 
 
  void initSkills() { 
    var skill1 = Skill(skills.concept); 
    skill1.name = 'university'; 
    skill1.level = 'brad'; 
    var skill1Resource = resources.random(); 
    skill1.resource = skill1Resource; 
    skills.add(skill1); 
    skill1Resource.skills.add(skill1); 
 
    var skill2 = Skill(skills.concept); 
    skill2.name = 'architecture'; 
    skill2.level = 'observation'; 
    var skill2Resource = resources.random(); 
    skill2.resource = skill2Resource; 
    skills.add(skill2); 
    skill2Resource.skills.add(skill2); 
 
    var skill3 = Skill(skills.concept); 
    skill3.name = 'lunch'; 
    skill3.level = 'cardboard'; 
    var skill3Resource = resources.random(); 
    skill3.resource = skill3Resource; 
    skills.add(skill3); 
    skill3Resource.skills.add(skill3); 
 
  } 
 
  void initTimes() { 
    var time1 = Time(times.concept); 
    time1.hours = 8813; 
    var time1Project = projects.random(); 
    time1.project = time1Project; 
    times.add(time1); 
    time1Project.times.add(time1); 
 
    var time2 = Time(times.concept); 
    time2.hours = 810; 
    var time2Project = projects.random(); 
    time2.project = time2Project; 
    times.add(time2); 
    time2Project.times.add(time2); 
 
    var time3 = Time(times.concept); 
    time3.hours = 2585; 
    var time3Project = projects.random(); 
    time3.project = time3Project; 
    times.add(time3); 
    time3Project.times.add(time3); 
 
  } 
 
  void initBudgets() { 
    var budget1 = Budget(budgets.concept); 
    budget1.amount = 65.36683636612135; 
    budget1.currency = 'finger'; 
    var budget1Project = projects.random(); 
    budget1.project = budget1Project; 
    budgets.add(budget1); 
    budget1Project.budgets.add(budget1); 
 
    var budget2 = Budget(budgets.concept); 
    budget2.amount = 22.9901885596142; 
    budget2.currency = 'cup'; 
    var budget2Project = projects.random(); 
    budget2.project = budget2Project; 
    budgets.add(budget2); 
    budget2Project.budgets.add(budget2); 
 
    var budget3 = Budget(budgets.concept); 
    budget3.amount = 86.48152567442328; 
    budget3.currency = 'knowledge'; 
    var budget3Project = projects.random(); 
    budget3.project = budget3Project; 
    budgets.add(budget3); 
    budget3Project.budgets.add(budget3); 
 
  } 
 
  void initInitiatives() { 
    var initiative1 = Initiative(initiatives.concept); 
    initiative1.name = 'productivity'; 
    var initiative1Project = projects.random(); 
    initiative1.project = initiative1Project; 
    initiatives.add(initiative1); 
    initiative1Project.initiatives.add(initiative1); 
 
    var initiative2 = Initiative(initiatives.concept); 
    initiative2.name = 'job'; 
    var initiative2Project = projects.random(); 
    initiative2.project = initiative2Project; 
    initiatives.add(initiative2); 
    initiative2Project.initiatives.add(initiative2); 
 
    var initiative3 = Initiative(initiatives.concept); 
    initiative3.name = 'flower'; 
    var initiative3Project = projects.random(); 
    initiative3.project = initiative3Project; 
    initiatives.add(initiative3); 
    initiative3Project.initiatives.add(initiative3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

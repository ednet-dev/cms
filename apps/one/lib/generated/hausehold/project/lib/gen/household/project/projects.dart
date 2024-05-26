part of household_project; 
 
// lib/gen/household/project/projects.dart 
 
abstract class ProjectGen extends Entity<Project> { 
 
  ProjectGen(Concept concept) { 
    this.concept = concept; 
    Concept taskConcept = concept.model.concepts.singleWhereCode("Task") as Concept; 
    assert(taskConcept != null); 
    setChild("tasks", Tasks(taskConcept)); 
    Concept milestoneConcept = concept.model.concepts.singleWhereCode("Milestone") as Concept; 
    assert(milestoneConcept != null); 
    setChild("milestones", Milestones(milestoneConcept)); 
    Concept teamConcept = concept.model.concepts.singleWhereCode("Team") as Concept; 
    assert(teamConcept != null); 
    setChild("teams", Teams(teamConcept)); 
    Concept budgetConcept = concept.model.concepts.singleWhereCode("Budget") as Concept; 
    assert(budgetConcept != null); 
    setChild("budgets", Budgets(budgetConcept)); 
    Concept initiativeConcept = concept.model.concepts.singleWhereCode("Initiative") as Concept; 
    assert(initiativeConcept != null); 
    setChild("initiatives", Initiatives(initiativeConcept)); 
    Concept timeConcept = concept.model.concepts.singleWhereCode("Time") as Concept; 
    assert(timeConcept != null); 
    setChild("times", Times(timeConcept)); 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  DateTime get startDate => getAttribute("startDate"); 
  void set startDate(DateTime a) { setAttribute("startDate", a); } 
  
  DateTime get endDate => getAttribute("endDate"); 
  void set endDate(DateTime a) { setAttribute("endDate", a); } 
  
  double get budget => getAttribute("budget"); 
  void set budget(double a) { setAttribute("budget", a); } 
  
  Tasks get tasks => getChild("tasks") as Tasks; 
  
  Milestones get milestones => getChild("milestones") as Milestones; 
  
  Teams get teams => getChild("teams") as Teams; 
  
  Budgets get budgets => getChild("budgets") as Budgets; 
  
  Initiatives get initiatives => getChild("initiatives") as Initiatives; 
  
  Times get times => getChild("times") as Times; 
  
  Project newEntity() => Project(concept); 
  Projects newEntities() => Projects(concept); 
  
} 
 
abstract class ProjectsGen extends Entities<Project> { 
 
  ProjectsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Projects newEntities() => Projects(concept); 
  Project newEntity() => Project(concept); 
  
} 
 

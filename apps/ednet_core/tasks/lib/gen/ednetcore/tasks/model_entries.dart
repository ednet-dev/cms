part of ednetcore_tasks; 
 
// lib/gen/ednetcore/tasks/model_entries.dart 
 
class TasksEntries extends ModelEntries { 
 
  TasksEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Employee"); 
    entries["Employee"] = Employees(concept!); 
    concept = model.concepts.singleWhereCode("Project"); 
    entries["Project"] = Projects(concept!); 
    return entries; 
  } 
 
  Entities? newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Employee") {
      return Employees(concept!); 
    } 
    if (concept.code == "Project") {
      return Projects(concept!); 
    } 
    if (concept.code == "Task") {
      return Tasks(concept!); 
    } 
    return null; 
  } 
 
  Entity? newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Employee") {
      return Employee(concept!); 
    } 
    if (concept.code == "Project") {
      return Project(concept!); 
    } 
    if (concept.code == "Task") {
      return Task(concept!); 
    } 
    return null; 
  } 
 
  Employees get employees => getEntry("Employee") as Employees; 
  Projects get projects => getEntry("Project") as Projects; 
 
} 
 

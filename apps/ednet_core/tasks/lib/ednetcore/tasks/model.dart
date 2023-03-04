 
part of ednetcore_tasks; 
 
// lib/ednetcore/tasks/model.dart 
 
class TasksModel extends TasksEntries { 
 
  TasksModel(Model model) : super(model); 
 
  void fromJsonToEmployeeEntry() { 
    fromJsonToEntry(ednetcoreTasksEmployeeEntry); 
  } 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(ednetcoreTasksProjectEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(ednetcoreTasksModel); 
  } 
 
  void init() { 
    initEmployees(); 
    initProjects(); 
  } 
 
  void initEmployees() { 
    var employee1 = Employee(employees.concept!); 
    employee1.email = 'organization'; 
    employee1.lastName = 'top'; 
    employee1.firstName = 'test'; 
    employees.add(employee1); 
 
    var employee1tasks1 = Task(employee1.tasks.concept!); 
    employee1tasks1.description = 'message'; 
    employee1tasks1.employee = employee1; 
    employee1.tasks.add(employee1tasks1); 
 
    var employee1tasks2 = Task(employee1.tasks.concept!); 
    employee1tasks2.description = 'table'; 
    employee1tasks2.employee = employee1; 
    employee1.tasks.add(employee1tasks2); 
 
    var employee2 = Employee(employees.concept!); 
    employee2.email = 'cash'; 
    employee2.lastName = 'unit'; 
    employee2.firstName = 'fish'; 
    employees.add(employee2); 
 
    var employee2tasks1 = Task(employee2.tasks.concept!); 
    employee2tasks1.description = 'teaching'; 
    employee2tasks1.employee = employee2; 
    employee2.tasks.add(employee2tasks1); 
 
    var employee2tasks2 = Task(employee2.tasks.concept!); 
    employee2tasks2.description = 'health'; 
    employee2tasks2.employee = employee2; 
    employee2.tasks.add(employee2tasks2); 
 
    var employee3 = Employee(employees.concept!); 
    employee3.email = 'capacity'; 
    employee3.lastName = 'tape'; 
    employee3.firstName = 'agreement'; 
    employees.add(employee3); 
 
    var employee3tasks1 = Task(employee3.tasks.concept!); 
    employee3tasks1.description = 'call'; 
    employee3tasks1.employee = employee3; 
    employee3.tasks.add(employee3tasks1); 
 
    var employee3tasks2 = Task(employee3.tasks.concept!); 
    employee3tasks2.description = 'feeling'; 
    employee3tasks2.employee = employee3; 
    employee3.tasks.add(employee3tasks2); 
 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept!); 
    project1.name = 'tax'; 
    project1.description = 'celebration'; 
    projects.add(project1); 
 
    var project1tasks1 = Task(project1.tasks.concept!); 
    project1tasks1.description = 'pub'; 
    project1tasks1.project = project1; 
    project1.tasks.add(project1tasks1); 
 
    var project1tasks2 = Task(project1.tasks.concept!); 
    project1tasks2.description = 'message'; 
    project1tasks2.project = project1; 
    project1.tasks.add(project1tasks2); 
 
    var project2 = Project(projects.concept!); 
    project2.name = 'opinion'; 
    project2.description = 'baby'; 
    projects.add(project2); 
 
    var project2tasks1 = Task(project2.tasks.concept!); 
    project2tasks1.description = 'offence'; 
    project2tasks1.project = project2; 
    project2.tasks.add(project2tasks1); 
 
    var project2tasks2 = Task(project2.tasks.concept!); 
    project2tasks2.description = 'season'; 
    project2tasks2.project = project2; 
    project2.tasks.add(project2tasks2); 
 
    var project3 = Project(projects.concept!); 
    project3.name = 'walking'; 
    project3.description = 'message'; 
    projects.add(project3); 
 
    var project3tasks1 = Task(project3.tasks.concept!); 
    project3tasks1.description = 'seed'; 
    project3tasks1.project = project3; 
    project3.tasks.add(project3tasks1); 
 
    var project3tasks2 = Task(project3.tasks.concept!); 
    project3tasks2.description = 'candy'; 
    project3tasks2.project = project3; 
    project3.tasks.add(project3tasks2); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

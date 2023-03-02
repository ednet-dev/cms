 
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
    var employee1 = Employee(employees.concept); 
    employee1.email = 'selfie'; 
    employee1.lastName = 'notch'; 
    employee1.firstName = 'energy'; 
    employees.add(employee1); 
 
    var employee1tasks1 = Task(employee1.tasks.concept); 
    employee1tasks1.description = 'smog'; 
    employee1tasks1.employee = employee1; 
    employee1.tasks.add(employee1tasks1); 
 
    var employee1tasks2 = Task(employee1.tasks.concept); 
    employee1tasks2.description = 'accomodation'; 
    employee1tasks2.employee = employee1; 
    employee1.tasks.add(employee1tasks2); 
 
    var employee2 = Employee(employees.concept); 
    employee2.email = 'up'; 
    employee2.lastName = 'office'; 
    employee2.firstName = 'train'; 
    employees.add(employee2); 
 
    var employee2tasks1 = Task(employee2.tasks.concept); 
    employee2tasks1.description = 'unit'; 
    employee2tasks1.employee = employee2; 
    employee2.tasks.add(employee2tasks1); 
 
    var employee2tasks2 = Task(employee2.tasks.concept); 
    employee2tasks2.description = 'east'; 
    employee2tasks2.employee = employee2; 
    employee2.tasks.add(employee2tasks2); 
 
    var employee3 = Employee(employees.concept); 
    employee3.email = 'done'; 
    employee3.lastName = 'objective'; 
    employee3.firstName = 'chemist'; 
    employees.add(employee3); 
 
    var employee3tasks1 = Task(employee3.tasks.concept); 
    employee3tasks1.description = 'up'; 
    employee3tasks1.employee = employee3; 
    employee3.tasks.add(employee3tasks1); 
 
    var employee3tasks2 = Task(employee3.tasks.concept); 
    employee3tasks2.description = 'highway'; 
    employee3tasks2.employee = employee3; 
    employee3.tasks.add(employee3tasks2); 
 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    project1.name = 'umbrella'; 
    project1.description = 'coffee'; 
    projects.add(project1); 
 
    var project1tasks1 = Task(project1.tasks.concept); 
    project1tasks1.description = 'top'; 
    project1tasks1.project = project1; 
    project1.tasks.add(project1tasks1); 
 
    var project1tasks2 = Task(project1.tasks.concept); 
    project1tasks2.description = 'lake'; 
    project1tasks2.project = project1; 
    project1.tasks.add(project1tasks2); 
 
    var project2 = Project(projects.concept); 
    project2.name = 'walking'; 
    project2.description = 'tall'; 
    projects.add(project2); 
 
    var project2tasks1 = Task(project2.tasks.concept); 
    project2tasks1.description = 'music'; 
    project2tasks1.project = project2; 
    project2.tasks.add(project2tasks1); 
 
    var project2tasks2 = Task(project2.tasks.concept); 
    project2tasks2.description = 'enquiry'; 
    project2tasks2.project = project2; 
    project2.tasks.add(project2tasks2); 
 
    var project3 = Project(projects.concept); 
    project3.name = 'small'; 
    project3.description = 'blue'; 
    projects.add(project3); 
 
    var project3tasks1 = Task(project3.tasks.concept); 
    project3tasks1.description = 'season'; 
    project3tasks1.project = project3; 
    project3.tasks.add(project3tasks1); 
 
    var project3tasks2 = Task(project3.tasks.concept); 
    project3tasks2.description = 'employer'; 
    project3tasks2.project = project3; 
    project3.tasks.add(project3tasks2); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

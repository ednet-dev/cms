part of ednetcore_tasks;

// lib/gen/ednetcore/tasks/employees.dart

abstract class EmployeeGen extends Entity<Employee> {
  EmployeeGen(Concept concept) {
    this.concept = concept;
    Concept? taskConcept = concept.model.concepts.singleWhereCode("Task");
    assert(taskConcept != null);
    setChild("tasks", Tasks(taskConcept!));
  }

  String get email => getAttribute("email");

  void set email(String a) {
    setAttribute("email", a);
  }

  String get lastName => getAttribute("lastName");

  void set lastName(String a) {
    setAttribute("lastName", a);
  }

  String get firstName => getAttribute("firstName");

  void set firstName(String a) {
    setAttribute("firstName", a);
  }

  Tasks get tasks => getChild("tasks") as Tasks;

  Employee newEntity() => Employee(concept);

  Employees newEntities() => Employees(concept);
}

abstract class EmployeesGen extends Entities<Employee> {
  EmployeesGen(Concept concept) {
    this.concept = concept;
  }

  Employees newEntities() => Employees(concept);

  Employee newEntity() => Employee(concept);
}

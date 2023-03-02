 
// test/ednetcore/tasks/ednetcore_tasks_employee_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:ednetcore_tasks/ednetcore_tasks.dart"; 
 
void testEdnetcoreTasksEmployees( 
    EdnetcoreDomain ednetcoreDomain, TasksModel tasksModel, Employees employees) { 
  DomainSession session; 
  group("Testing Ednetcore.Tasks.Employee", () { 
    session = ednetcoreDomain.newSession();  
    setUp(() { 
      tasksModel.init(); 
    }); 
    tearDown(() { 
      tasksModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(tasksModel.isEmpty, isFalse); 
      expect(employees.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      tasksModel.clear(); 
      expect(tasksModel.isEmpty, isTrue); 
      expect(employees.isEmpty, isTrue); 
      expect(employees.exceptions..isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = tasksModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //tasksModel.displayJson(); 
      //tasksModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = tasksModel.toJson(); 
      tasksModel.clear(); 
      expect(tasksModel.isEmpty, isTrue); 
      tasksModel.fromJson(json); 
      expect(tasksModel.isEmpty, isFalse); 
 
      tasksModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = tasksModel.fromEntryToJson("Employee"); 
      expect(json, isNotNull); 
 
      print(json); 
      //tasksModel.displayEntryJson("Employee"); 
      //tasksModel.displayJson(); 
      //tasksModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = tasksModel.fromEntryToJson("Employee"); 
      employees.clear(); 
      expect(employees.isEmpty, isTrue); 
      tasksModel.fromJsonToEntry(json); 
      expect(employees.isEmpty, isFalse); 
 
      employees.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add employee required error", () { 
      var employeeConcept = employees.concept; 
      var employeeCount = employees.length; 
      var employee = Employee(employeeConcept); 
      var added = employees.add(employee); 
      expect(added, isFalse); 
      expect(employees.length, equals(employeeCount)); 
      expect(employees.exceptions..length, greaterThan(0)); 
      expect(employees.exceptions..toList()[0].category, equals("required")); 
 
      employees.exceptions..display(title: "Add employee required error"); 
    }); 
 
    test("Add employee unique error", () { 
      var employeeConcept = employees.concept; 
      var employeeCount = employees.length; 
      var employee = Employee(employeeConcept); 
      var randomEmployee = employees.random(); 
      employee.email = randomEmployee.email; 
      var added = employees.add(employee); 
      expect(added, isFalse); 
      expect(employees.length, equals(employeeCount)); 
      expect(employees.exceptions..length, greaterThan(0)); 
 
      employees.exceptions..display(title: "Add employee unique error"); 
    }); 
 
    test("Not found employee by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var employee = employees.singleWhereOid(ednetOid); 
      expect(employee, isNull); 
    }); 
 
    test("Find employee by oid", () { 
      var randomEmployee = employees.random(); 
      var employee = employees.singleWhereOid(randomEmployee.oid); 
      expect(employee, isNotNull); 
      expect(employee, equals(randomEmployee)); 
    }); 
 
    test("Find employee by attribute id", () { 
      var randomEmployee = employees.random(); 
      var employee = 
          employees.singleWhereAttributeId("email", randomEmployee.email); 
      expect(employee, isNotNull); 
      expect(employee.email, equals(randomEmployee.email)); 
    }); 
 
    test("Find employee by required attribute", () { 
      var randomEmployee = employees.random(); 
      var employee = 
          employees.firstWhereAttribute("lastName", randomEmployee.lastName); 
      expect(employee, isNotNull); 
      expect(employee.lastName, equals(randomEmployee.lastName)); 
    }); 
 
    test("Find employee by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select employees by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select employees by required attribute", () { 
      var randomEmployee = employees.random(); 
      var selectedEmployees = 
          employees.selectWhereAttribute("lastName", randomEmployee.lastName); 
      expect(selectedEmployees.isEmpty, isFalse); 
      selectedEmployees.forEach((se) => 
          expect(se.lastName, equals(randomEmployee.lastName))); 
 
      //selectedEmployees.display(title: "Select employees by lastName"); 
    }); 
 
    test("Select employees by attribute, then add", () { 
      var randomEmployee = employees.random(); 
      var selectedEmployees = 
          employees.selectWhereAttribute("lastName", randomEmployee.lastName); 
      expect(selectedEmployees.isEmpty, isFalse); 
      expect(selectedEmployees.source?.isEmpty, isFalse); 
      var employeesCount = employees.length; 
 
      var employee = Employee(employees.concept); 
      employee.email = 'sun'; 
      employee.lastName = 'hospital'; 
      employee.firstName = 'test'; 
      var added = selectedEmployees.add(employee); 
      expect(added, isTrue); 
      expect(employees.length, equals(++employeesCount)); 
 
      //selectedEmployees.display(title: 
      //  "Select employees by attribute, then add"); 
      //employees.display(title: "All employees"); 
    }); 
 
    test("Select employees by attribute, then remove", () { 
      var randomEmployee = employees.random(); 
      var selectedEmployees = 
          employees.selectWhereAttribute("lastName", randomEmployee.lastName); 
      expect(selectedEmployees.isEmpty, isFalse); 
      expect(selectedEmployees.source?.isEmpty, isFalse); 
      var employeesCount = employees.length; 
 
      var removed = selectedEmployees.remove(randomEmployee); 
      expect(removed, isTrue); 
      expect(employees.length, equals(--employeesCount)); 
 
      randomEmployee.display(prefix: "removed"); 
      //selectedEmployees.display(title: 
      //  "Select employees by attribute, then remove"); 
      //employees.display(title: "All employees"); 
    }); 
 
    test("Sort employees", () { 
      employees.sort(); 
 
      //employees.display(title: "Sort employees"); 
    }); 
 
    test("Order employees", () { 
      var orderedEmployees = employees.order(); 
      expect(orderedEmployees.isEmpty, isFalse); 
      expect(orderedEmployees.length, equals(employees.length)); 
      expect(orderedEmployees.source?.isEmpty, isFalse); 
      expect(orderedEmployees.source?.length, equals(employees.length)); 
      expect(orderedEmployees, isNot(same(employees))); 
 
      //orderedEmployees.display(title: "Order employees"); 
    }); 
 
    test("Copy employees", () { 
      var copiedEmployees = employees.copy(); 
      expect(copiedEmployees.isEmpty, isFalse); 
      expect(copiedEmployees.length, equals(employees.length)); 
      expect(copiedEmployees, isNot(same(employees))); 
      copiedEmployees.forEach((e) => 
        expect(e, equals(employees.singleWhereOid(e.oid)))); 
      copiedEmployees.forEach((e) => 
        expect(e, isNot(same(employees.singleWhereId(e.id as IId<Employee>))))); 
 
      //copiedEmployees.display(title: "Copy employees"); 
    }); 
 
    test("True for every employee", () { 
      expect(employees.every((e) => e.lastName != null), isTrue); 
    }); 
 
    test("Random employee", () { 
      var employee1 = employees.random(); 
      expect(employee1, isNotNull); 
      var employee2 = employees.random(); 
      expect(employee2, isNotNull); 
 
      //employee1.display(prefix: "random1"); 
      //employee2.display(prefix: "random2"); 
    }); 
 
    test("Update employee id with try", () { 
      var randomEmployee = employees.random(); 
      var beforeUpdate = randomEmployee.email; 
      try { 
        randomEmployee.email = 'chemist'; 
      } on UpdateException catch (e) { 
        expect(randomEmployee.email, equals(beforeUpdate)); 
      } 
    }); 
 
    test("Update employee id without try", () { 
      var randomEmployee = employees.random(); 
      var beforeUpdateValue = randomEmployee.email; 
      expect(() => randomEmployee.email = 'sun', throws); 
      expect(randomEmployee.email, equals(beforeUpdateValue)); 
    }); 
 
    test("Update employee id with success", () { 
      var randomEmployee = employees.random(); 
      var afterUpdateEntity = randomEmployee.copy(); 
      var attribute = randomEmployee.concept.attributes.singleWhereCode("email"); 
      expect(attribute?.update, isFalse); 
      attribute?.update = true; 
      afterUpdateEntity.email = 'call'; 
      expect(afterUpdateEntity.email, equals('call')); 
      attribute?.update = false; 
      var updated = employees.update(randomEmployee, afterUpdateEntity); 
      expect(updated, isTrue); 
 
      var entity = employees.singleWhereAttributeId("email", 'call'); 
      expect(entity, isNotNull); 
      expect(entity.email, equals('call')); 
 
      //employees.display("After update employee id"); 
    }); 
 
    test("Update employee non id attribute with failure", () { 
      var randomEmployee = employees.random(); 
      var afterUpdateEntity = randomEmployee.copy(); 
      afterUpdateEntity.lastName = 'tension'; 
      expect(afterUpdateEntity.lastName, equals('tension')); 
      // employees.update can only be used if oid, code or id is set. 
      expect(() => employees.update(randomEmployee, afterUpdateEntity), throws); 
    }); 
 
    test("Copy Equality", () { 
      var randomEmployee = employees.random(); 
      randomEmployee.display(prefix:"before copy: "); 
      var randomEmployeeCopy = randomEmployee.copy(); 
      randomEmployeeCopy.display(prefix:"after copy: "); 
      expect(randomEmployee, equals(randomEmployeeCopy)); 
      expect(randomEmployee.oid, equals(randomEmployeeCopy.oid)); 
      expect(randomEmployee.code, equals(randomEmployeeCopy.code)); 
      expect(randomEmployee.email, equals(randomEmployeeCopy.email)); 
      expect(randomEmployee.lastName, equals(randomEmployeeCopy.lastName)); 
      expect(randomEmployee.firstName, equals(randomEmployeeCopy.firstName)); 
 
      expect(randomEmployee.id, isNotNull); 
      expect(randomEmployeeCopy.id, isNotNull); 
      expect(randomEmployee.id, equals(randomEmployeeCopy.id)); 
 
      var idsEqual = false; 
      if (randomEmployee.id == randomEmployeeCopy.id) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
 
      idsEqual = false; 
      if (randomEmployee.id!.equals(randomEmployeeCopy.id!)) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
    }); 
 
    test("employee action undo and redo", () { 
      var employeeCount = employees.length; 
      var employee = Employee(employees.concept); 
        employee.email = 'executive'; 
      employee.lastName = 'life'; 
      employee.firstName = 'video'; 
      employees.add(employee); 
      expect(employees.length, equals(++employeeCount)); 
      employees.remove(employee); 
      expect(employees.length, equals(--employeeCount)); 
 
      var action = AddCommand(session, employees, employee); 
      action.doIt(); 
      expect(employees.length, equals(++employeeCount)); 
 
      action.undo(); 
      expect(employees.length, equals(--employeeCount)); 
 
      action.redo(); 
      expect(employees.length, equals(++employeeCount)); 
    }); 
 
    test("employee session undo and redo", () { 
      var employeeCount = employees.length; 
      var employee = Employee(employees.concept); 
        employee.email = 'wave'; 
      employee.lastName = 'output'; 
      employee.firstName = 'sun'; 
      employees.add(employee); 
      expect(employees.length, equals(++employeeCount)); 
      employees.remove(employee); 
      expect(employees.length, equals(--employeeCount)); 
 
      var action = AddCommand(session, employees, employee); 
      action.doIt(); 
      expect(employees.length, equals(++employeeCount)); 
 
      session.past.undo(); 
      expect(employees.length, equals(--employeeCount)); 
 
      session.past.redo(); 
      expect(employees.length, equals(++employeeCount)); 
    }); 
 
    test("Employee update undo and redo", () { 
      var employee = employees.random(); 
      var action = SetAttributeCommand(session, employee, "lastName", 'understanding'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(employee.lastName, equals(action.before)); 
 
      session.past.redo(); 
      expect(employee.lastName, equals(action.after)); 
    }); 
 
    test("Employee action with multiple undos and redos", () { 
      var employeeCount = employees.length; 
      var employee1 = employees.random(); 
 
      var action1 = RemoveCommand(session, employees, employee1); 
      action1.doIt(); 
      expect(employees.length, equals(--employeeCount)); 
 
      var employee2 = employees.random(); 
 
      var action2 = RemoveCommand(session, employees, employee2); 
      action2.doIt(); 
      expect(employees.length, equals(--employeeCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(employees.length, equals(++employeeCount)); 
 
      session.past.undo(); 
      expect(employees.length, equals(++employeeCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(employees.length, equals(--employeeCount)); 
 
      session.past.redo(); 
      expect(employees.length, equals(--employeeCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var employeeCount = employees.length; 
      var employee1 = employees.random(); 
      var employee2 = employees.random(); 
      while (employee1 == employee2) { 
        employee2 = employees.random();  
      } 
      var action1 = RemoveCommand(session, employees, employee1); 
      var action2 = RemoveCommand(session, employees, employee2); 
 
      var transaction = new Transaction("two removes on employees", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      employeeCount = employeeCount - 2; 
      expect(employees.length, equals(employeeCount)); 
 
      employees.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      employeeCount = employeeCount + 2; 
      expect(employees.length, equals(employeeCount)); 
 
      employees.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      employeeCount = employeeCount - 2; 
      expect(employees.length, equals(employeeCount)); 
 
      employees.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var employeeCount = employees.length; 
      var employee1 = employees.random(); 
      var employee2 = employee1; 
      var action1 = RemoveCommand(session, employees, employee1); 
      var action2 = RemoveCommand(session, employees, employee2); 
 
      var transaction = Transaction( 
        "two removes on employees, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(employees.length, equals(employeeCount)); 
 
      //employees.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to employee actions", () { 
      var employeeCount = employees.length; 
 
      var reaction = EmployeeReaction(); 
      expect(reaction, isNotNull); 
 
      ednetcoreDomain.startCommandReaction(reaction); 
      var employee = Employee(employees.concept); 
        employee.email = 'concern'; 
      employee.lastName = 'sailing'; 
      employee.firstName = 'country'; 
      employees.add(employee); 
      expect(employees.length, equals(++employeeCount)); 
      employees.remove(employee); 
      expect(employees.length, equals(--employeeCount)); 
 
      var session = ednetcoreDomain.newSession(); 
      var addCommand = AddCommand(session, employees, employee); 
      addCommand.doIt(); 
      expect(employees.length, equals(++employeeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, employee, "lastName", 'fish'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      ednetcoreDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class EmployeeReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  var repository = Repository(); 
  EdnetcoreDomain ednetcoreDomain = repository.getDomainModels("Ednetcore") as EdnetcoreDomain;   
  assert(ednetcoreDomain != null); 
  TasksModel tasksModel = ednetcoreDomain.getModelEntries("Tasks") as TasksModel;  
  assert(tasksModel != null); 
  var employees = tasksModel.employees; 
  testEdnetcoreTasksEmployees(ednetcoreDomain, tasksModel, employees); 
} 
 

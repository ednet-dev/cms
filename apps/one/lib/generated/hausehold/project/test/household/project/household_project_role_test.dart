 
// test/household/project/household_project_role_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectRoles( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Roles roles) { 
  DomainSession session; 
  group("Testing Household.Project.Role", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(roles.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(roles.isEmpty, isTrue); 
      expect(roles.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = projectModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = projectModel.toJson(); 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      projectModel.fromJson(json); 
      expect(projectModel.isEmpty, isFalse); 
 
      projectModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = projectModel.fromEntryToJson("Role"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Role"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Role"); 
      roles.clear(); 
      expect(roles.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(roles.isEmpty, isFalse); 
 
      roles.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add role required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add role unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found role by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var role = roles.singleWhereOid(ednetOid); 
      expect(role, isNull); 
    }); 
 
    test("Find role by oid", () { 
      var randomRole = projectModel.roles.random(); 
      var role = roles.singleWhereOid(randomRole.oid); 
      expect(role, isNotNull); 
      expect(role, equals(randomRole)); 
    }); 
 
    test("Find role by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find role by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find role by attribute", () { 
      var randomRole = projectModel.roles.random(); 
      var role = 
          roles.firstWhereAttribute("title", randomRole.title); 
      expect(role, isNotNull); 
      expect(role.title, equals(randomRole.title)); 
    }); 
 
    test("Select roles by attribute", () { 
      var randomRole = projectModel.roles.random(); 
      var selectedRoles = 
          roles.selectWhereAttribute("title", randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      selectedRoles.forEach((se) => 
          expect(se.title, equals(randomRole.title))); 
 
      //selectedRoles.display(title: "Select roles by title"); 
    }); 
 
    test("Select roles by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select roles by attribute, then add", () { 
      var randomRole = projectModel.roles.random(); 
      var selectedRoles = 
          roles.selectWhereAttribute("title", randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      expect(selectedRoles.source?.isEmpty, isFalse); 
      var rolesCount = roles.length; 
 
      var role = Role(roles.concept); 
      role.title = 'policeman'; 
      role.responsibility = 'question'; 
      var added = selectedRoles.add(role); 
      expect(added, isTrue); 
      expect(roles.length, equals(++rolesCount)); 
 
      //selectedRoles.display(title: 
      //  "Select roles by attribute, then add"); 
      //roles.display(title: "All roles"); 
    }); 
 
    test("Select roles by attribute, then remove", () { 
      var randomRole = projectModel.roles.random(); 
      var selectedRoles = 
          roles.selectWhereAttribute("title", randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      expect(selectedRoles.source?.isEmpty, isFalse); 
      var rolesCount = roles.length; 
 
      var removed = selectedRoles.remove(randomRole); 
      expect(removed, isTrue); 
      expect(roles.length, equals(--rolesCount)); 
 
      randomRole.display(prefix: "removed"); 
      //selectedRoles.display(title: 
      //  "Select roles by attribute, then remove"); 
      //roles.display(title: "All roles"); 
    }); 
 
    test("Sort roles", () { 
      // no id attribute 
      // add compareTo method in the specific Role class 
      /* 
      roles.sort(); 
 
      //roles.display(title: "Sort roles"); 
      */ 
    }); 
 
    test("Order roles", () { 
      // no id attribute 
      // add compareTo method in the specific Role class 
      /* 
      var orderedRoles = roles.order(); 
      expect(orderedRoles.isEmpty, isFalse); 
      expect(orderedRoles.length, equals(roles.length)); 
      expect(orderedRoles.source?.isEmpty, isFalse); 
      expect(orderedRoles.source?.length, equals(roles.length)); 
      expect(orderedRoles, isNot(same(roles))); 
 
      //orderedRoles.display(title: "Order roles"); 
      */ 
    }); 
 
    test("Copy roles", () { 
      var copiedRoles = roles.copy(); 
      expect(copiedRoles.isEmpty, isFalse); 
      expect(copiedRoles.length, equals(roles.length)); 
      expect(copiedRoles, isNot(same(roles))); 
      copiedRoles.forEach((e) => 
        expect(e, equals(roles.singleWhereOid(e.oid)))); 
 
      //copiedRoles.display(title: "Copy roles"); 
    }); 
 
    test("True for every role", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random role", () { 
      var role1 = projectModel.roles.random(); 
      expect(role1, isNotNull); 
      var role2 = projectModel.roles.random(); 
      expect(role2, isNotNull); 
 
      //role1.display(prefix: "random1"); 
      //role2.display(prefix: "random2"); 
    }); 
 
    test("Update role id with try", () { 
      // no id attribute 
    }); 
 
    test("Update role id without try", () { 
      // no id attribute 
    }); 
 
    test("Update role id with success", () { 
      // no id attribute 
    }); 
 
    test("Update role non id attribute with failure", () { 
      var randomRole = projectModel.roles.random(); 
      var afterUpdateEntity = randomRole.copy(); 
      afterUpdateEntity.title = 'corner'; 
      expect(afterUpdateEntity.title, equals('corner')); 
      // roles.update can only be used if oid, code or id is set. 
      expect(() => roles.update(randomRole, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomRole = projectModel.roles.random(); 
      randomRole.display(prefix:"before copy: "); 
      var randomRoleCopy = randomRole.copy(); 
      randomRoleCopy.display(prefix:"after copy: "); 
      expect(randomRole, equals(randomRoleCopy)); 
      expect(randomRole.oid, equals(randomRoleCopy.oid)); 
      expect(randomRole.code, equals(randomRoleCopy.code)); 
      expect(randomRole.title, equals(randomRoleCopy.title)); 
      expect(randomRole.responsibility, equals(randomRoleCopy.responsibility)); 
 
    }); 
 
    test("role action undo and redo", () { 
      var roleCount = roles.length; 
      var role = Role(roles.concept); 
        role.title = 'tension'; 
      role.responsibility = 'enquiry'; 
    var roleTeam = projectModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      var action = AddCommand(session, roles, role); 
      action.doIt(); 
      expect(roles.length, equals(++roleCount)); 
 
      action.undo(); 
      expect(roles.length, equals(--roleCount)); 
 
      action.redo(); 
      expect(roles.length, equals(++roleCount)); 
    }); 
 
    test("role session undo and redo", () { 
      var roleCount = roles.length; 
      var role = Role(roles.concept); 
        role.title = 'effort'; 
      role.responsibility = 'distance'; 
    var roleTeam = projectModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      var action = AddCommand(session, roles, role); 
      action.doIt(); 
      expect(roles.length, equals(++roleCount)); 
 
      session.past.undo(); 
      expect(roles.length, equals(--roleCount)); 
 
      session.past.redo(); 
      expect(roles.length, equals(++roleCount)); 
    }); 
 
    test("Role update undo and redo", () { 
      var role = projectModel.roles.random(); 
      var action = SetAttributeCommand(session, role, "title", 'abstract'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(role.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(role.title, equals(action.after)); 
    }); 
 
    test("Role action with multiple undos and redos", () { 
      var roleCount = roles.length; 
      var role1 = projectModel.roles.random(); 
 
      var action1 = RemoveCommand(session, roles, role1); 
      action1.doIt(); 
      expect(roles.length, equals(--roleCount)); 
 
      var role2 = projectModel.roles.random(); 
 
      var action2 = RemoveCommand(session, roles, role2); 
      action2.doIt(); 
      expect(roles.length, equals(--roleCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(roles.length, equals(++roleCount)); 
 
      session.past.undo(); 
      expect(roles.length, equals(++roleCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(roles.length, equals(--roleCount)); 
 
      session.past.redo(); 
      expect(roles.length, equals(--roleCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var roleCount = roles.length; 
      var role1 = projectModel.roles.random(); 
      var role2 = projectModel.roles.random(); 
      while (role1 == role2) { 
        role2 = projectModel.roles.random();  
      } 
      var action1 = RemoveCommand(session, roles, role1); 
      var action2 = RemoveCommand(session, roles, role2); 
 
      var transaction = new Transaction("two removes on roles", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      roleCount = roleCount - 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      roleCount = roleCount + 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      roleCount = roleCount - 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var roleCount = roles.length; 
      var role1 = projectModel.roles.random(); 
      var role2 = role1; 
      var action1 = RemoveCommand(session, roles, role1); 
      var action2 = RemoveCommand(session, roles, role2); 
 
      var transaction = Transaction( 
        "two removes on roles, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(roles.length, equals(roleCount)); 
 
      //roles.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to role actions", () { 
      var roleCount = roles.length; 
 
      var reaction = RoleReaction(); 
      expect(reaction, isNotNull); 
 
      householdDomain.startCommandReaction(reaction); 
      var role = Role(roles.concept); 
        role.title = 'concern'; 
      role.responsibility = 'bank'; 
    var roleTeam = projectModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, roles, role); 
      addCommand.doIt(); 
      expect(roles.length, equals(++roleCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, role, "title", 'hospital'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class RoleReaction implements ICommandReaction { 
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
  var repository = HouseholdProjectRepo(); 
  HouseholdDomain householdDomain = repository.getDomainModels("Household") as HouseholdDomain;   
  assert(householdDomain != null); 
  ProjectModel projectModel = householdDomain.getModelEntries("Project") as ProjectModel;  
  assert(projectModel != null); 
  var roles = projectModel.roles; 
  testHouseholdProjectRoles(householdDomain, projectModel, roles); 
} 
 

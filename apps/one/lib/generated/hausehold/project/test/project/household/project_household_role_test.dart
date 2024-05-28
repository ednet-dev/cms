 
// test/project/household/project_household_role_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_household/project_household.dart"; 
 
void testProjectHouseholdRoles( 
    ProjectDomain projectDomain, HouseholdModel householdModel, Roles roles) { 
  DomainSession session; 
  group("Testing Project.Household.Role", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      householdModel.init(); 
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(roles.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(roles.isEmpty, isTrue); 
      expect(roles.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = householdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = householdModel.toJson(); 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      householdModel.fromJson(json); 
      expect(householdModel.isEmpty, isFalse); 
 
      householdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = householdModel.fromEntryToJson("Role"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Role"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Role"); 
      roles.clear(); 
      expect(roles.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
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
      var randomRole = householdModel.roles.random(); 
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
      var randomRole = householdModel.roles.random(); 
      var role = 
          roles.firstWhereAttribute("title", randomRole.title); 
      expect(role, isNotNull); 
      expect(role.title, equals(randomRole.title)); 
    }); 
 
    test("Select roles by attribute", () { 
      var randomRole = householdModel.roles.random(); 
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
      var randomRole = householdModel.roles.random(); 
      var selectedRoles = 
          roles.selectWhereAttribute("title", randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      expect(selectedRoles.source?.isEmpty, isFalse); 
      var rolesCount = roles.length; 
 
      var role = Role(roles.concept); 
      role.title = 'computer'; 
      role.responsibility = 'end'; 
      var added = selectedRoles.add(role); 
      expect(added, isTrue); 
      expect(roles.length, equals(++rolesCount)); 
 
      //selectedRoles.display(title: 
      //  "Select roles by attribute, then add"); 
      //roles.display(title: "All roles"); 
    }); 
 
    test("Select roles by attribute, then remove", () { 
      var randomRole = householdModel.roles.random(); 
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
      var role1 = householdModel.roles.random(); 
      expect(role1, isNotNull); 
      var role2 = householdModel.roles.random(); 
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
      var randomRole = householdModel.roles.random(); 
      var afterUpdateEntity = randomRole.copy(); 
      afterUpdateEntity.title = 'pub'; 
      expect(afterUpdateEntity.title, equals('pub')); 
      // roles.update can only be used if oid, code or id is set. 
      expect(() => roles.update(randomRole, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomRole = householdModel.roles.random(); 
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
        role.title = 'architecture'; 
      role.responsibility = 'train'; 
    var roleTeam = householdModel.teams.random(); 
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
        role.title = 'cream'; 
      role.responsibility = 'redo'; 
    var roleTeam = householdModel.teams.random(); 
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
      var role = householdModel.roles.random(); 
      var action = SetAttributeCommand(session, role, "title", 'wheat'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(role.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(role.title, equals(action.after)); 
    }); 
 
    test("Role action with multiple undos and redos", () { 
      var roleCount = roles.length; 
      var role1 = householdModel.roles.random(); 
 
      var action1 = RemoveCommand(session, roles, role1); 
      action1.doIt(); 
      expect(roles.length, equals(--roleCount)); 
 
      var role2 = householdModel.roles.random(); 
 
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
      var role1 = householdModel.roles.random(); 
      var role2 = householdModel.roles.random(); 
      while (role1 == role2) { 
        role2 = householdModel.roles.random();  
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
      var role1 = householdModel.roles.random(); 
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
 
      projectDomain.startCommandReaction(reaction); 
      var role = Role(roles.concept); 
        role.title = 'kids'; 
      role.responsibility = 'teacher'; 
    var roleTeam = householdModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, roles, role); 
      addCommand.doIt(); 
      expect(roles.length, equals(++roleCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, role, "title", 'left'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
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
  var repository = ProjectHouseholdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  HouseholdModel householdModel = projectDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var roles = householdModel.roles; 
  testProjectHouseholdRoles(projectDomain, householdModel, roles); 
} 
 

 
// test/project/core/project_core_role_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreRoles( 
    ProjectDomain projectDomain, CoreModel coreModel, Roles roles) { 
  DomainSession session; 
  group('Testing Project.Core.Role', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(roles.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(roles.isEmpty, isTrue); 
      expect(roles.exceptions.isEmpty, isTrue); 
    }); 
 
    test('From model to JSON', () { 
      final json = coreModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model', () { 
      final json = coreModel.toJson(); 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      coreModel.fromJson(json); 
      expect(coreModel.isEmpty, isFalse); 
 
      coreModel.display(); 
    }); 
 
    test('From model entry to JSON', () { 
      final json = coreModel.fromEntryToJson('Role'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Role'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Role'); 
      roles.clear(); 
      expect(roles.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(roles.isEmpty, isFalse); 
 
      roles.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add role required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add role unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found role by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final role = roles.singleWhereOid(ednetOid); 
      expect(role, isNull); 
    }); 
 
    test('Find role by oid', () { 
      final randomRole = coreModel.roles.random(); 
      final role = roles.singleWhereOid(randomRole.oid); 
      expect(role, isNotNull); 
      expect(role, equals(randomRole)); 
    }); 
 
    test('Find role by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find role by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find role by attribute', () { 
      final randomRole = coreModel.roles.random(); 
      final role = 
          roles.firstWhereAttribute('title', randomRole.title); 
      expect(role, isNotNull); 
      expect(role.title, equals(randomRole.title)); 
    }); 
 
    test('Select roles by attribute', () { 
      final randomRole = coreModel.roles.random(); 
      final selectedRoles = 
          roles.selectWhereAttribute('title', randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      for (final se in selectedRoles) {        expect(se.title, equals(randomRole.title));      } 
      //selectedRoles.display(title: 'Select roles by title'); 
    }); 
 
    test('Select roles by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select roles by attribute, then add', () { 
      final randomRole = coreModel.roles.random(); 
      final selectedRoles = 
          roles.selectWhereAttribute('title', randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      expect(selectedRoles.source?.isEmpty, isFalse); 
      var rolesCount = roles.length; 
 
      final role = Role(roles.concept) 

      ..title = 'ticket'
      ..responsibility = 'camping';      final added = selectedRoles.add(role); 
      expect(added, isTrue); 
      expect(roles.length, equals(++rolesCount)); 
 
      //selectedRoles.display(title: 
      //  'Select roles by attribute, then add'); 
      //roles.display(title: 'All roles'); 
    }); 
 
    test('Select roles by attribute, then remove', () { 
      final randomRole = coreModel.roles.random(); 
      final selectedRoles = 
          roles.selectWhereAttribute('title', randomRole.title); 
      expect(selectedRoles.isEmpty, isFalse); 
      expect(selectedRoles.source?.isEmpty, isFalse); 
      var rolesCount = roles.length; 
 
      final removed = selectedRoles.remove(randomRole); 
      expect(removed, isTrue); 
      expect(roles.length, equals(--rolesCount)); 
 
      randomRole.display(prefix: 'removed'); 
      //selectedRoles.display(title: 
      //  'Select roles by attribute, then remove'); 
      //roles.display(title: 'All roles'); 
    }); 
 
    test('Sort roles', () { 
      // no id attribute 
      // add compareTo method in the specific Role class 
      /* 
      roles.sort(); 
 
      //roles.display(title: 'Sort roles'); 
      */ 
    }); 
 
    test('Order roles', () { 
      // no id attribute 
      // add compareTo method in the specific Role class 
      /* 
      final orderedRoles = roles.order(); 
      expect(orderedRoles.isEmpty, isFalse); 
      expect(orderedRoles.length, equals(roles.length)); 
      expect(orderedRoles.source?.isEmpty, isFalse); 
      expect(orderedRoles.source?.length, equals(roles.length)); 
      expect(orderedRoles, isNot(same(roles))); 
 
      //orderedRoles.display(title: 'Order roles'); 
      */ 
    }); 
 
    test('Copy roles', () { 
      final copiedRoles = roles.copy(); 
      expect(copiedRoles.isEmpty, isFalse); 
      expect(copiedRoles.length, equals(roles.length)); 
      expect(copiedRoles, isNot(same(roles))); 
      for (final e in copiedRoles) {        expect(e, equals(roles.singleWhereOid(e.oid)));      } 
 
      //copiedRoles.display(title: "Copy roles"); 
    }); 
 
    test('True for every role', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random role', () { 
      final role1 = coreModel.roles.random(); 
      expect(role1, isNotNull); 
      final role2 = coreModel.roles.random(); 
      expect(role2, isNotNull); 
 
      //role1.display(prefix: 'random1'); 
      //role2.display(prefix: 'random2'); 
    }); 
 
    test('Update role id with try', () { 
      // no id attribute 
    }); 
 
    test('Update role id without try', () { 
      // no id attribute 
    }); 
 
    test('Update role id with success', () { 
      // no id attribute 
    }); 
 
    test('Update role non id attribute with failure', () { 
      final randomRole = coreModel.roles.random(); 
      final afterUpdateEntity = randomRole.copy()..title = 'east'; 
      expect(afterUpdateEntity.title, equals('east')); 
      // roles.update can only be used if oid, code or id is set. 
      expect(() => roles.update(randomRole, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomRole = coreModel.roles.random()..display(prefix:'before copy: '); 
      final randomRoleCopy = randomRole.copy()..display(prefix:'after copy: '); 
      expect(randomRole, equals(randomRoleCopy)); 
      expect(randomRole.oid, equals(randomRoleCopy.oid)); 
      expect(randomRole.code, equals(randomRoleCopy.code)); 
      expect(randomRole.title, equals(randomRoleCopy.title)); 
      expect(randomRole.responsibility, equals(randomRoleCopy.responsibility)); 
 
    }); 
 
    test('role action undo and redo', () { 
      var roleCount = roles.length; 
      final role = Role(roles.concept) 
  
      ..title = 'deep'
      ..responsibility = 'dog';    final roleTeam = coreModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      final action = AddCommand(session, roles, role)..doIt(); 
      expect(roles.length, equals(++roleCount)); 
 
      action.undo(); 
      expect(roles.length, equals(--roleCount)); 
 
      action.redo(); 
      expect(roles.length, equals(++roleCount)); 
    }); 
 
    test('role session undo and redo', () { 
      var roleCount = roles.length; 
      final role = Role(roles.concept) 
  
      ..title = 'park'
      ..responsibility = 'measuremewnt';    final roleTeam = coreModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      AddCommand(session, roles, role).doIt();; 
      expect(roles.length, equals(++roleCount)); 
 
      session.past.undo(); 
      expect(roles.length, equals(--roleCount)); 
 
      session.past.redo(); 
      expect(roles.length, equals(++roleCount)); 
    }); 
 
    test('Role update undo and redo', () { 
      final role = coreModel.roles.random(); 
      final action = SetAttributeCommand(session, role, 'title', 'up')..doIt(); 
 
      session.past.undo(); 
      expect(role.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(role.title, equals(action.after)); 
    }); 
 
    test('Role action with multiple undos and redos', () { 
      var roleCount = roles.length; 
      final role1 = coreModel.roles.random(); 
 
      RemoveCommand(session, roles, role1).doIt(); 
      expect(roles.length, equals(--roleCount)); 
 
      final role2 = coreModel.roles.random(); 
 
      RemoveCommand(session, roles, role2).doIt(); 
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
 
    test('Transaction undo and redo', () { 
      var roleCount = roles.length; 
      final role1 = coreModel.roles.random(); 
      var role2 = coreModel.roles.random(); 
      while (role1 == role2) { 
        role2 = coreModel.roles.random();  
      } 
      final action1 = RemoveCommand(session, roles, role1); 
      final action2 = RemoveCommand(session, roles, role2); 
 
      Transaction('two removes on roles', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      roleCount = roleCount - 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      roleCount = roleCount + 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      roleCount = roleCount - 2; 
      expect(roles.length, equals(roleCount)); 
 
      roles.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final roleCount = roles.length; 
      final role1 = coreModel.roles.random(); 
      final role2 = role1; 
      final action1 = RemoveCommand(session, roles, role1); 
      final action2 = RemoveCommand(session, roles, role2); 
 
      final transaction = Transaction( 
        'two removes on roles, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(roles.length, equals(roleCount)); 
 
      //roles.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to role actions', () { 
      var roleCount = roles.length; 
 
      final reaction = RoleReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final role = Role(roles.concept) 
  
      ..title = 'present'
      ..responsibility = 'park';    final roleTeam = coreModel.teams.random(); 
    role.team = roleTeam; 
      roles.add(role); 
    roleTeam.roles.add(role); 
      expect(roles.length, equals(++roleCount)); 
      roles.remove(role); 
      expect(roles.length, equals(--roleCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, roles, role).doIt(); 
      expect(roles.length, equals(++roleCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        role,
        'title',
        'celebration',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class RoleReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  @override  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  final repository = ProjectCoreRepo(); 
  final projectDomain = repository.getDomainModels('Project') as ProjectDomain?;
  assert(projectDomain != null, 'ProjectDomain is not defined'); 
  final coreModel = projectDomain!.getModelEntries('Core') as CoreModel?;
  assert(coreModel != null, 'CoreModel is not defined'); 
  final roles = coreModel!.roles; 
  testProjectCoreRoles(projectDomain, coreModel, roles); 
} 
 

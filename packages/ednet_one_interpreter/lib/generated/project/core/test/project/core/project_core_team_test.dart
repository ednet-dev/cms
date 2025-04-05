 
// test/project/core/project_core_team_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreTeams( 
    ProjectDomain projectDomain, CoreModel coreModel, Teams teams) { 
  DomainSession session; 
  group('Testing Project.Core.Team', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(teams.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(teams.isEmpty, isTrue); 
      expect(teams.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Team'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Team'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Team'); 
      teams.clear(); 
      expect(teams.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(teams.isEmpty, isFalse); 
 
      teams.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add team required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add team unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found team by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final team = teams.singleWhereOid(ednetOid); 
      expect(team, isNull); 
    }); 
 
    test('Find team by oid', () { 
      final randomTeam = coreModel.teams.random(); 
      final team = teams.singleWhereOid(randomTeam.oid); 
      expect(team, isNotNull); 
      expect(team, equals(randomTeam)); 
    }); 
 
    test('Find team by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find team by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find team by attribute', () { 
      final randomTeam = coreModel.teams.random(); 
      final team = 
          teams.firstWhereAttribute('name', randomTeam.name); 
      expect(team, isNotNull); 
      expect(team.name, equals(randomTeam.name)); 
    }); 
 
    test('Select teams by attribute', () { 
      final randomTeam = coreModel.teams.random(); 
      final selectedTeams = 
          teams.selectWhereAttribute('name', randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      for (final se in selectedTeams) {        expect(se.name, equals(randomTeam.name));      } 
      //selectedTeams.display(title: 'Select teams by name'); 
    }); 
 
    test('Select teams by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select teams by attribute, then add', () { 
      final randomTeam = coreModel.teams.random(); 
      final selectedTeams = 
          teams.selectWhereAttribute('name', randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      expect(selectedTeams.source?.isEmpty, isFalse); 
      var teamsCount = teams.length; 
 
      final team = Team(teams.concept) 

      ..name = 'abstract';      final added = selectedTeams.add(team); 
      expect(added, isTrue); 
      expect(teams.length, equals(++teamsCount)); 
 
      //selectedTeams.display(title: 
      //  'Select teams by attribute, then add'); 
      //teams.display(title: 'All teams'); 
    }); 
 
    test('Select teams by attribute, then remove', () { 
      final randomTeam = coreModel.teams.random(); 
      final selectedTeams = 
          teams.selectWhereAttribute('name', randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      expect(selectedTeams.source?.isEmpty, isFalse); 
      var teamsCount = teams.length; 
 
      final removed = selectedTeams.remove(randomTeam); 
      expect(removed, isTrue); 
      expect(teams.length, equals(--teamsCount)); 
 
      randomTeam.display(prefix: 'removed'); 
      //selectedTeams.display(title: 
      //  'Select teams by attribute, then remove'); 
      //teams.display(title: 'All teams'); 
    }); 
 
    test('Sort teams', () { 
      // no id attribute 
      // add compareTo method in the specific Team class 
      /* 
      teams.sort(); 
 
      //teams.display(title: 'Sort teams'); 
      */ 
    }); 
 
    test('Order teams', () { 
      // no id attribute 
      // add compareTo method in the specific Team class 
      /* 
      final orderedTeams = teams.order(); 
      expect(orderedTeams.isEmpty, isFalse); 
      expect(orderedTeams.length, equals(teams.length)); 
      expect(orderedTeams.source?.isEmpty, isFalse); 
      expect(orderedTeams.source?.length, equals(teams.length)); 
      expect(orderedTeams, isNot(same(teams))); 
 
      //orderedTeams.display(title: 'Order teams'); 
      */ 
    }); 
 
    test('Copy teams', () { 
      final copiedTeams = teams.copy(); 
      expect(copiedTeams.isEmpty, isFalse); 
      expect(copiedTeams.length, equals(teams.length)); 
      expect(copiedTeams, isNot(same(teams))); 
      for (final e in copiedTeams) {        expect(e, equals(teams.singleWhereOid(e.oid)));      } 
 
      //copiedTeams.display(title: "Copy teams"); 
    }); 
 
    test('True for every team', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random team', () { 
      final team1 = coreModel.teams.random(); 
      expect(team1, isNotNull); 
      final team2 = coreModel.teams.random(); 
      expect(team2, isNotNull); 
 
      //team1.display(prefix: 'random1'); 
      //team2.display(prefix: 'random2'); 
    }); 
 
    test('Update team id with try', () { 
      // no id attribute 
    }); 
 
    test('Update team id without try', () { 
      // no id attribute 
    }); 
 
    test('Update team id with success', () { 
      // no id attribute 
    }); 
 
    test('Update team non id attribute with failure', () { 
      final randomTeam = coreModel.teams.random(); 
      final afterUpdateEntity = randomTeam.copy()..name = 'fascination'; 
      expect(afterUpdateEntity.name, equals('fascination')); 
      // teams.update can only be used if oid, code or id is set. 
      expect(() => teams.update(randomTeam, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomTeam = coreModel.teams.random()..display(prefix:'before copy: '); 
      final randomTeamCopy = randomTeam.copy()..display(prefix:'after copy: '); 
      expect(randomTeam, equals(randomTeamCopy)); 
      expect(randomTeam.oid, equals(randomTeamCopy.oid)); 
      expect(randomTeam.code, equals(randomTeamCopy.code)); 
      expect(randomTeam.name, equals(randomTeamCopy.name)); 
 
    }); 
 
    test('team action undo and redo', () { 
      var teamCount = teams.length; 
      final team = Team(teams.concept) 
  
      ..name = 'television';    final teamProject = coreModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      final action = AddCommand(session, teams, team)..doIt(); 
      expect(teams.length, equals(++teamCount)); 
 
      action.undo(); 
      expect(teams.length, equals(--teamCount)); 
 
      action.redo(); 
      expect(teams.length, equals(++teamCount)); 
    }); 
 
    test('team session undo and redo', () { 
      var teamCount = teams.length; 
      final team = Team(teams.concept) 
  
      ..name = 'dog';    final teamProject = coreModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      AddCommand(session, teams, team).doIt();; 
      expect(teams.length, equals(++teamCount)); 
 
      session.past.undo(); 
      expect(teams.length, equals(--teamCount)); 
 
      session.past.redo(); 
      expect(teams.length, equals(++teamCount)); 
    }); 
 
    test('Team update undo and redo', () { 
      final team = coreModel.teams.random(); 
      final action = SetAttributeCommand(session, team, 'name', 'month')..doIt(); 
 
      session.past.undo(); 
      expect(team.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(team.name, equals(action.after)); 
    }); 
 
    test('Team action with multiple undos and redos', () { 
      var teamCount = teams.length; 
      final team1 = coreModel.teams.random(); 
 
      RemoveCommand(session, teams, team1).doIt(); 
      expect(teams.length, equals(--teamCount)); 
 
      final team2 = coreModel.teams.random(); 
 
      RemoveCommand(session, teams, team2).doIt(); 
      expect(teams.length, equals(--teamCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(teams.length, equals(++teamCount)); 
 
      session.past.undo(); 
      expect(teams.length, equals(++teamCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(teams.length, equals(--teamCount)); 
 
      session.past.redo(); 
      expect(teams.length, equals(--teamCount)); 
 
      //session.past.display(); 
    }); 
 
    test('Transaction undo and redo', () { 
      var teamCount = teams.length; 
      final team1 = coreModel.teams.random(); 
      var team2 = coreModel.teams.random(); 
      while (team1 == team2) { 
        team2 = coreModel.teams.random();  
      } 
      final action1 = RemoveCommand(session, teams, team1); 
      final action2 = RemoveCommand(session, teams, team2); 
 
      Transaction('two removes on teams', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      teamCount = teamCount - 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      teamCount = teamCount + 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      teamCount = teamCount - 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final teamCount = teams.length; 
      final team1 = coreModel.teams.random(); 
      final team2 = team1; 
      final action1 = RemoveCommand(session, teams, team1); 
      final action2 = RemoveCommand(session, teams, team2); 
 
      final transaction = Transaction( 
        'two removes on teams, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(teams.length, equals(teamCount)); 
 
      //teams.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to team actions', () { 
      var teamCount = teams.length; 
 
      final reaction = TeamReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final team = Team(teams.concept) 
  
      ..name = 'small';    final teamProject = coreModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, teams, team).doIt(); 
      expect(teams.length, equals(++teamCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        team,
        'name',
        'economy',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TeamReaction implements ICommandReaction { 
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
  final teams = coreModel!.teams; 
  testProjectCoreTeams(projectDomain, coreModel, teams); 
} 
 

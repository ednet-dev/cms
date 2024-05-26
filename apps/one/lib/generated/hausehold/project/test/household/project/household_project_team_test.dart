 
// test/household/project/household_project_team_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectTeams( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Teams teams) { 
  DomainSession session; 
  group("Testing Household.Project.Team", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(teams.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(teams.isEmpty, isTrue); 
      expect(teams.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("Team"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Team"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Team"); 
      teams.clear(); 
      expect(teams.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(teams.isEmpty, isFalse); 
 
      teams.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add team required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add team unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found team by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var team = teams.singleWhereOid(ednetOid); 
      expect(team, isNull); 
    }); 
 
    test("Find team by oid", () { 
      var randomTeam = projectModel.teams.random(); 
      var team = teams.singleWhereOid(randomTeam.oid); 
      expect(team, isNotNull); 
      expect(team, equals(randomTeam)); 
    }); 
 
    test("Find team by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find team by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find team by attribute", () { 
      var randomTeam = projectModel.teams.random(); 
      var team = 
          teams.firstWhereAttribute("name", randomTeam.name); 
      expect(team, isNotNull); 
      expect(team.name, equals(randomTeam.name)); 
    }); 
 
    test("Select teams by attribute", () { 
      var randomTeam = projectModel.teams.random(); 
      var selectedTeams = 
          teams.selectWhereAttribute("name", randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      selectedTeams.forEach((se) => 
          expect(se.name, equals(randomTeam.name))); 
 
      //selectedTeams.display(title: "Select teams by name"); 
    }); 
 
    test("Select teams by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select teams by attribute, then add", () { 
      var randomTeam = projectModel.teams.random(); 
      var selectedTeams = 
          teams.selectWhereAttribute("name", randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      expect(selectedTeams.source?.isEmpty, isFalse); 
      var teamsCount = teams.length; 
 
      var team = Team(teams.concept); 
      team.name = 'east'; 
      var added = selectedTeams.add(team); 
      expect(added, isTrue); 
      expect(teams.length, equals(++teamsCount)); 
 
      //selectedTeams.display(title: 
      //  "Select teams by attribute, then add"); 
      //teams.display(title: "All teams"); 
    }); 
 
    test("Select teams by attribute, then remove", () { 
      var randomTeam = projectModel.teams.random(); 
      var selectedTeams = 
          teams.selectWhereAttribute("name", randomTeam.name); 
      expect(selectedTeams.isEmpty, isFalse); 
      expect(selectedTeams.source?.isEmpty, isFalse); 
      var teamsCount = teams.length; 
 
      var removed = selectedTeams.remove(randomTeam); 
      expect(removed, isTrue); 
      expect(teams.length, equals(--teamsCount)); 
 
      randomTeam.display(prefix: "removed"); 
      //selectedTeams.display(title: 
      //  "Select teams by attribute, then remove"); 
      //teams.display(title: "All teams"); 
    }); 
 
    test("Sort teams", () { 
      // no id attribute 
      // add compareTo method in the specific Team class 
      /* 
      teams.sort(); 
 
      //teams.display(title: "Sort teams"); 
      */ 
    }); 
 
    test("Order teams", () { 
      // no id attribute 
      // add compareTo method in the specific Team class 
      /* 
      var orderedTeams = teams.order(); 
      expect(orderedTeams.isEmpty, isFalse); 
      expect(orderedTeams.length, equals(teams.length)); 
      expect(orderedTeams.source?.isEmpty, isFalse); 
      expect(orderedTeams.source?.length, equals(teams.length)); 
      expect(orderedTeams, isNot(same(teams))); 
 
      //orderedTeams.display(title: "Order teams"); 
      */ 
    }); 
 
    test("Copy teams", () { 
      var copiedTeams = teams.copy(); 
      expect(copiedTeams.isEmpty, isFalse); 
      expect(copiedTeams.length, equals(teams.length)); 
      expect(copiedTeams, isNot(same(teams))); 
      copiedTeams.forEach((e) => 
        expect(e, equals(teams.singleWhereOid(e.oid)))); 
 
      //copiedTeams.display(title: "Copy teams"); 
    }); 
 
    test("True for every team", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random team", () { 
      var team1 = projectModel.teams.random(); 
      expect(team1, isNotNull); 
      var team2 = projectModel.teams.random(); 
      expect(team2, isNotNull); 
 
      //team1.display(prefix: "random1"); 
      //team2.display(prefix: "random2"); 
    }); 
 
    test("Update team id with try", () { 
      // no id attribute 
    }); 
 
    test("Update team id without try", () { 
      // no id attribute 
    }); 
 
    test("Update team id with success", () { 
      // no id attribute 
    }); 
 
    test("Update team non id attribute with failure", () { 
      var randomTeam = projectModel.teams.random(); 
      var afterUpdateEntity = randomTeam.copy(); 
      afterUpdateEntity.name = 'consulting'; 
      expect(afterUpdateEntity.name, equals('consulting')); 
      // teams.update can only be used if oid, code or id is set. 
      expect(() => teams.update(randomTeam, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomTeam = projectModel.teams.random(); 
      randomTeam.display(prefix:"before copy: "); 
      var randomTeamCopy = randomTeam.copy(); 
      randomTeamCopy.display(prefix:"after copy: "); 
      expect(randomTeam, equals(randomTeamCopy)); 
      expect(randomTeam.oid, equals(randomTeamCopy.oid)); 
      expect(randomTeam.code, equals(randomTeamCopy.code)); 
      expect(randomTeam.name, equals(randomTeamCopy.name)); 
 
    }); 
 
    test("team action undo and redo", () { 
      var teamCount = teams.length; 
      var team = Team(teams.concept); 
        team.name = 'policeman'; 
    var teamProject = projectModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      var action = AddCommand(session, teams, team); 
      action.doIt(); 
      expect(teams.length, equals(++teamCount)); 
 
      action.undo(); 
      expect(teams.length, equals(--teamCount)); 
 
      action.redo(); 
      expect(teams.length, equals(++teamCount)); 
    }); 
 
    test("team session undo and redo", () { 
      var teamCount = teams.length; 
      var team = Team(teams.concept); 
        team.name = 'line'; 
    var teamProject = projectModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      var action = AddCommand(session, teams, team); 
      action.doIt(); 
      expect(teams.length, equals(++teamCount)); 
 
      session.past.undo(); 
      expect(teams.length, equals(--teamCount)); 
 
      session.past.redo(); 
      expect(teams.length, equals(++teamCount)); 
    }); 
 
    test("Team update undo and redo", () { 
      var team = projectModel.teams.random(); 
      var action = SetAttributeCommand(session, team, "name", 'marriage'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(team.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(team.name, equals(action.after)); 
    }); 
 
    test("Team action with multiple undos and redos", () { 
      var teamCount = teams.length; 
      var team1 = projectModel.teams.random(); 
 
      var action1 = RemoveCommand(session, teams, team1); 
      action1.doIt(); 
      expect(teams.length, equals(--teamCount)); 
 
      var team2 = projectModel.teams.random(); 
 
      var action2 = RemoveCommand(session, teams, team2); 
      action2.doIt(); 
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
 
    test("Transaction undo and redo", () { 
      var teamCount = teams.length; 
      var team1 = projectModel.teams.random(); 
      var team2 = projectModel.teams.random(); 
      while (team1 == team2) { 
        team2 = projectModel.teams.random();  
      } 
      var action1 = RemoveCommand(session, teams, team1); 
      var action2 = RemoveCommand(session, teams, team2); 
 
      var transaction = new Transaction("two removes on teams", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      teamCount = teamCount - 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      teamCount = teamCount + 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      teamCount = teamCount - 2; 
      expect(teams.length, equals(teamCount)); 
 
      teams.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var teamCount = teams.length; 
      var team1 = projectModel.teams.random(); 
      var team2 = team1; 
      var action1 = RemoveCommand(session, teams, team1); 
      var action2 = RemoveCommand(session, teams, team2); 
 
      var transaction = Transaction( 
        "two removes on teams, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(teams.length, equals(teamCount)); 
 
      //teams.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to team actions", () { 
      var teamCount = teams.length; 
 
      var reaction = TeamReaction(); 
      expect(reaction, isNotNull); 
 
      householdDomain.startCommandReaction(reaction); 
      var team = Team(teams.concept); 
        team.name = 'salary'; 
    var teamProject = projectModel.projects.random(); 
    team.project = teamProject; 
      teams.add(team); 
    teamProject.teams.add(team); 
      expect(teams.length, equals(++teamCount)); 
      teams.remove(team); 
      expect(teams.length, equals(--teamCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, teams, team); 
      addCommand.doIt(); 
      expect(teams.length, equals(++teamCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, team, "name", 'school'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TeamReaction implements ICommandReaction { 
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
  var teams = projectModel.teams; 
  testHouseholdProjectTeams(householdDomain, projectModel, teams); 
} 
 

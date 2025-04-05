 
// test/project/core/project_core_skill_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_core/project_core.dart"; 
 
void testProjectCoreSkills( 
    ProjectDomain projectDomain, CoreModel coreModel, Skills skills) { 
  DomainSession session; 
  group("Testing Project.Core.Skill", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(skills.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(skills.isEmpty, isTrue); 
      expect(skills.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = coreModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = coreModel.toJson(); 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      coreModel.fromJson(json); 
      expect(coreModel.isEmpty, isFalse); 
 
      coreModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = coreModel.fromEntryToJson("Skill"); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson("Skill"); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = coreModel.fromEntryToJson("Skill"); 
      skills.clear(); 
      expect(skills.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(skills.isEmpty, isFalse); 
 
      skills.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add skill required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add skill unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found skill by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var skill = skills.singleWhereOid(ednetOid); 
      expect(skill, isNull); 
    }); 
 
    test("Find skill by oid", () { 
      var randomSkill = coreModel.skills.random(); 
      var skill = skills.singleWhereOid(randomSkill.oid); 
      expect(skill, isNotNull); 
      expect(skill, equals(randomSkill)); 
    }); 
 
    test("Find skill by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find skill by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find skill by attribute", () { 
      var randomSkill = coreModel.skills.random(); 
      var skill = 
          skills.firstWhereAttribute("name", randomSkill.name); 
      expect(skill, isNotNull); 
      expect(skill.name, equals(randomSkill.name)); 
    }); 
 
    test("Select skills by attribute", () { 
      var randomSkill = coreModel.skills.random(); 
      var selectedSkills = 
          skills.selectWhereAttribute("name", randomSkill.name); 
      expect(selectedSkills.isEmpty, isFalse); 
      selectedSkills.forEach((se) => 
          expect(se.name, equals(randomSkill.name))); 
 
      //selectedSkills.display(title: "Select skills by name"); 
    }); 
 
    test("Select skills by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select skills by attribute, then add", () { 
      var randomSkill = coreModel.skills.random(); 
      var selectedSkills = 
          skills.selectWhereAttribute("name", randomSkill.name); 
      expect(selectedSkills.isEmpty, isFalse); 
      expect(selectedSkills.source?.isEmpty, isFalse); 
      var skillsCount = skills.length; 
 
      var skill = Skill(skills.concept); 
      skill.name = 'cinema'; 
      skill.level = 'down'; 
      var added = selectedSkills.add(skill); 
      expect(added, isTrue); 
      expect(skills.length, equals(++skillsCount)); 
 
      //selectedSkills.display(title: 
      //  "Select skills by attribute, then add"); 
      //skills.display(title: "All skills"); 
    }); 
 
    test("Select skills by attribute, then remove", () { 
      var randomSkill = coreModel.skills.random(); 
      var selectedSkills = 
          skills.selectWhereAttribute("name", randomSkill.name); 
      expect(selectedSkills.isEmpty, isFalse); 
      expect(selectedSkills.source?.isEmpty, isFalse); 
      var skillsCount = skills.length; 
 
      var removed = selectedSkills.remove(randomSkill); 
      expect(removed, isTrue); 
      expect(skills.length, equals(--skillsCount)); 
 
      randomSkill.display(prefix: "removed"); 
      //selectedSkills.display(title: 
      //  "Select skills by attribute, then remove"); 
      //skills.display(title: "All skills"); 
    }); 
 
    test("Sort skills", () { 
      // no id attribute 
      // add compareTo method in the specific Skill class 
      /* 
      skills.sort(); 
 
      //skills.display(title: "Sort skills"); 
      */ 
    }); 
 
    test("Order skills", () { 
      // no id attribute 
      // add compareTo method in the specific Skill class 
      /* 
      var orderedSkills = skills.order(); 
      expect(orderedSkills.isEmpty, isFalse); 
      expect(orderedSkills.length, equals(skills.length)); 
      expect(orderedSkills.source?.isEmpty, isFalse); 
      expect(orderedSkills.source?.length, equals(skills.length)); 
      expect(orderedSkills, isNot(same(skills))); 
 
      //orderedSkills.display(title: "Order skills"); 
      */ 
    }); 
 
    test("Copy skills", () { 
      var copiedSkills = skills.copy(); 
      expect(copiedSkills.isEmpty, isFalse); 
      expect(copiedSkills.length, equals(skills.length)); 
      expect(copiedSkills, isNot(same(skills))); 
      copiedSkills.forEach((e) => 
        expect(e, equals(skills.singleWhereOid(e.oid)))); 
 
      //copiedSkills.display(title: "Copy skills"); 
    }); 
 
    test("True for every skill", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random skill", () { 
      var skill1 = coreModel.skills.random(); 
      expect(skill1, isNotNull); 
      var skill2 = coreModel.skills.random(); 
      expect(skill2, isNotNull); 
 
      //skill1.display(prefix: "random1"); 
      //skill2.display(prefix: "random2"); 
    }); 
 
    test("Update skill id with try", () { 
      // no id attribute 
    }); 
 
    test("Update skill id without try", () { 
      // no id attribute 
    }); 
 
    test("Update skill id with success", () { 
      // no id attribute 
    }); 
 
    test("Update skill non id attribute with failure", () { 
      var randomSkill = coreModel.skills.random(); 
      var afterUpdateEntity = randomSkill.copy(); 
      afterUpdateEntity.name = 'kids'; 
      expect(afterUpdateEntity.name, equals('kids')); 
      // skills.update can only be used if oid, code or id is set. 
      expect(() => skills.update(randomSkill, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomSkill = coreModel.skills.random(); 
      randomSkill.display(prefix:"before copy: "); 
      var randomSkillCopy = randomSkill.copy(); 
      randomSkillCopy.display(prefix:"after copy: "); 
      expect(randomSkill, equals(randomSkillCopy)); 
      expect(randomSkill.oid, equals(randomSkillCopy.oid)); 
      expect(randomSkill.code, equals(randomSkillCopy.code)); 
      expect(randomSkill.name, equals(randomSkillCopy.name)); 
      expect(randomSkill.level, equals(randomSkillCopy.level)); 
 
    }); 
 
    test("skill action undo and redo", () { 
      var skillCount = skills.length; 
      var skill = Skill(skills.concept); 
        skill.name = 'book'; 
      skill.level = 'season'; 
    var skillResource = coreModel.resources.random(); 
    skill.resource = skillResource; 
      skills.add(skill); 
    skillResource.skills.add(skill); 
      expect(skills.length, equals(++skillCount)); 
      skills.remove(skill); 
      expect(skills.length, equals(--skillCount)); 
 
      var action = AddCommand(session, skills, skill); 
      action.doIt(); 
      expect(skills.length, equals(++skillCount)); 
 
      action.undo(); 
      expect(skills.length, equals(--skillCount)); 
 
      action.redo(); 
      expect(skills.length, equals(++skillCount)); 
    }); 
 
    test("skill session undo and redo", () { 
      var skillCount = skills.length; 
      var skill = Skill(skills.concept); 
        skill.name = 'fascination'; 
      skill.level = 'cream'; 
    var skillResource = coreModel.resources.random(); 
    skill.resource = skillResource; 
      skills.add(skill); 
    skillResource.skills.add(skill); 
      expect(skills.length, equals(++skillCount)); 
      skills.remove(skill); 
      expect(skills.length, equals(--skillCount)); 
 
      var action = AddCommand(session, skills, skill); 
      action.doIt(); 
      expect(skills.length, equals(++skillCount)); 
 
      session.past.undo(); 
      expect(skills.length, equals(--skillCount)); 
 
      session.past.redo(); 
      expect(skills.length, equals(++skillCount)); 
    }); 
 
    test("Skill update undo and redo", () { 
      var skill = coreModel.skills.random(); 
      var action = SetAttributeCommand(session, skill, "name", 'baby'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(skill.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(skill.name, equals(action.after)); 
    }); 
 
    test("Skill action with multiple undos and redos", () { 
      var skillCount = skills.length; 
      var skill1 = coreModel.skills.random(); 
 
      var action1 = RemoveCommand(session, skills, skill1); 
      action1.doIt(); 
      expect(skills.length, equals(--skillCount)); 
 
      var skill2 = coreModel.skills.random(); 
 
      var action2 = RemoveCommand(session, skills, skill2); 
      action2.doIt(); 
      expect(skills.length, equals(--skillCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(skills.length, equals(++skillCount)); 
 
      session.past.undo(); 
      expect(skills.length, equals(++skillCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(skills.length, equals(--skillCount)); 
 
      session.past.redo(); 
      expect(skills.length, equals(--skillCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var skillCount = skills.length; 
      var skill1 = coreModel.skills.random(); 
      var skill2 = coreModel.skills.random(); 
      while (skill1 == skill2) { 
        skill2 = coreModel.skills.random();  
      } 
      var action1 = RemoveCommand(session, skills, skill1); 
      var action2 = RemoveCommand(session, skills, skill2); 
 
      var transaction = new Transaction("two removes on skills", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      skillCount = skillCount - 2; 
      expect(skills.length, equals(skillCount)); 
 
      skills.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      skillCount = skillCount + 2; 
      expect(skills.length, equals(skillCount)); 
 
      skills.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      skillCount = skillCount - 2; 
      expect(skills.length, equals(skillCount)); 
 
      skills.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var skillCount = skills.length; 
      var skill1 = coreModel.skills.random(); 
      var skill2 = skill1; 
      var action1 = RemoveCommand(session, skills, skill1); 
      var action2 = RemoveCommand(session, skills, skill2); 
 
      var transaction = Transaction( 
        "two removes on skills, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(skills.length, equals(skillCount)); 
 
      //skills.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to skill actions", () { 
      var skillCount = skills.length; 
 
      var reaction = SkillReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var skill = Skill(skills.concept); 
        skill.name = 'universe'; 
      skill.level = 'chairman'; 
    var skillResource = coreModel.resources.random(); 
    skill.resource = skillResource; 
      skills.add(skill); 
    skillResource.skills.add(skill); 
      expect(skills.length, equals(++skillCount)); 
      skills.remove(skill); 
      expect(skills.length, equals(--skillCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, skills, skill); 
      addCommand.doIt(); 
      expect(skills.length, equals(++skillCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, skill, "name", 'baby'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class SkillReaction implements ICommandReaction { 
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
  var repository = ProjectCoreRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  CoreModel coreModel = projectDomain.getModelEntries("Core") as CoreModel;  
  assert(coreModel != null); 
  var skills = coreModel.skills; 
  testProjectCoreSkills(projectDomain, coreModel, skills); 
} 
 

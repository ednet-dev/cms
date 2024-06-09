 
// test/member/household/member_household_member_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:member_household/member_household.dart"; 
 
void testMemberHouseholdMembers( 
    MemberDomain memberDomain, HouseholdModel householdModel, Members members) { 
  DomainSession session; 
  group("Testing Member.Household.Member", () { 
    session = memberDomain.newSession();  
    setUp(() { 
      householdModel.simulate();
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(members.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(members.isEmpty, isTrue); 
      expect(members.exceptions.isEmpty, isTrue); 
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
      var json = householdModel.fromEntryToJson("Member"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Member"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Member"); 
      members.clear(); 
      expect(members.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
      expect(members.isEmpty, isFalse); 
 
      members.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add member required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add member unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found member by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var member = members.singleWhereOid(ednetOid); 
      expect(member, isNull); 
    }); 
 
    test("Find member by oid", () { 
      var randomMember = householdModel.members.random(); 
      var member = members.singleWhereOid(randomMember.oid); 
      expect(member, isNotNull); 
      expect(member, equals(randomMember)); 
    }); 
 
    test("Find member by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find member by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find member by attribute", () { 
      var randomMember = householdModel.members.random(); 
      var member = 
          members.firstWhereAttribute("name", randomMember.name); 
      expect(member, isNotNull); 
      expect(member.name, equals(randomMember.name)); 
    }); 
 
    test("Select members by attribute", () { 
      var randomMember = householdModel.members.random(); 
      var selectedMembers = 
          members.selectWhereAttribute("name", randomMember.name); 
      expect(selectedMembers.isEmpty, isFalse); 
      selectedMembers.forEach((se) => 
          expect(se.name, equals(randomMember.name))); 
 
      //selectedMembers.display(title: "Select members by name"); 
    }); 
 
    test("Select members by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select members by attribute, then add", () { 
      var randomMember = householdModel.members.random(); 
      var selectedMembers = 
          members.selectWhereAttribute("name", randomMember.name); 
      expect(selectedMembers.isEmpty, isFalse); 
      expect(selectedMembers.source?.isEmpty, isFalse); 
      var membersCount = members.length; 
 
      var member = Member(members.concept); 
      member.name = 'paper'; 
      var added = selectedMembers.add(member); 
      expect(added, isTrue); 
      expect(members.length, equals(++membersCount)); 
 
      //selectedMembers.display(title: 
      //  "Select members by attribute, then add"); 
      //members.display(title: "All members"); 
    }); 
 
    test("Select members by attribute, then remove", () { 
      var randomMember = householdModel.members.random(); 
      var selectedMembers = 
          members.selectWhereAttribute("name", randomMember.name); 
      expect(selectedMembers.isEmpty, isFalse); 
      expect(selectedMembers.source?.isEmpty, isFalse); 
      var membersCount = members.length; 
 
      var removed = selectedMembers.remove(randomMember); 
      expect(removed, isTrue); 
      expect(members.length, equals(--membersCount)); 
 
      randomMember.display(prefix: "removed"); 
      //selectedMembers.display(title: 
      //  "Select members by attribute, then remove"); 
      //members.display(title: "All members"); 
    }); 
 
    test("Sort members", () { 
      // no id attribute 
      // add compareTo method in the specific Member class 
      /* 
      members.sort(); 
 
      //members.display(title: "Sort members"); 
      */ 
    }); 
 
    test("Order members", () { 
      // no id attribute 
      // add compareTo method in the specific Member class 
      /* 
      var orderedMembers = members.order(); 
      expect(orderedMembers.isEmpty, isFalse); 
      expect(orderedMembers.length, equals(members.length)); 
      expect(orderedMembers.source?.isEmpty, isFalse); 
      expect(orderedMembers.source?.length, equals(members.length)); 
      expect(orderedMembers, isNot(same(members))); 
 
      //orderedMembers.display(title: "Order members"); 
      */ 
    }); 
 
    test("Copy members", () { 
      var copiedMembers = members.copy(); 
      expect(copiedMembers.isEmpty, isFalse); 
      expect(copiedMembers.length, equals(members.length)); 
      expect(copiedMembers, isNot(same(members))); 
      copiedMembers.forEach((e) => 
        expect(e, equals(members.singleWhereOid(e.oid)))); 
 
      //copiedMembers.display(title: "Copy members"); 
    }); 
 
    test("True for every member", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random member", () { 
      var member1 = householdModel.members.random(); 
      expect(member1, isNotNull); 
      var member2 = householdModel.members.random(); 
      expect(member2, isNotNull); 
 
      //member1.display(prefix: "random1"); 
      //member2.display(prefix: "random2"); 
    }); 
 
    test("Update member id with try", () { 
      // no id attribute 
    }); 
 
    test("Update member id without try", () { 
      // no id attribute 
    }); 
 
    test("Update member id with success", () { 
      // no id attribute 
    }); 
 
    test("Update member non id attribute with failure", () { 
      var randomMember = householdModel.members.random(); 
      var afterUpdateEntity = randomMember.copy(); 
      afterUpdateEntity.name = 'chemist'; 
      expect(afterUpdateEntity.name, equals('chemist')); 
      // members.update can only be used if oid, code or id is set. 
      expect(() => members.update(randomMember, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomMember = householdModel.members.random(); 
      randomMember.display(prefix:"before copy: "); 
      var randomMemberCopy = randomMember.copy(); 
      randomMemberCopy.display(prefix:"after copy: "); 
      expect(randomMember, equals(randomMemberCopy)); 
      expect(randomMember.oid, equals(randomMemberCopy.oid)); 
      expect(randomMember.code, equals(randomMemberCopy.code)); 
      expect(randomMember.name, equals(randomMemberCopy.name)); 
 
    }); 
 
    test("member action undo and redo", () { 
      var memberCount = members.length; 
      var member = Member(members.concept); 
        member.name = 'observation'; 
      members.add(member); 
      expect(members.length, equals(++memberCount)); 
      members.remove(member); 
      expect(members.length, equals(--memberCount)); 
 
      var action = AddCommand(session, members, member); 
      action.doIt(); 
      expect(members.length, equals(++memberCount)); 
 
      action.undo(); 
      expect(members.length, equals(--memberCount)); 
 
      action.redo(); 
      expect(members.length, equals(++memberCount)); 
    }); 
 
    test("member session undo and redo", () { 
      var memberCount = members.length; 
      var member = Member(members.concept); 
        member.name = 'lifespan'; 
      members.add(member); 
      expect(members.length, equals(++memberCount)); 
      members.remove(member); 
      expect(members.length, equals(--memberCount)); 
 
      var action = AddCommand(session, members, member); 
      action.doIt(); 
      expect(members.length, equals(++memberCount)); 
 
      session.past.undo(); 
      expect(members.length, equals(--memberCount)); 
 
      session.past.redo(); 
      expect(members.length, equals(++memberCount)); 
    }); 
 
    test("Member update undo and redo", () { 
      var member = householdModel.members.random(); 
      var action = SetAttributeCommand(session, member, "name", 'circle'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(member.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(member.name, equals(action.after)); 
    }); 
 
    test("Member action with multiple undos and redos", () { 
      var memberCount = members.length; 
      var member1 = householdModel.members.random(); 
 
      var action1 = RemoveCommand(session, members, member1); 
      action1.doIt(); 
      expect(members.length, equals(--memberCount)); 
 
      var member2 = householdModel.members.random(); 
 
      var action2 = RemoveCommand(session, members, member2); 
      action2.doIt(); 
      expect(members.length, equals(--memberCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(members.length, equals(++memberCount)); 
 
      session.past.undo(); 
      expect(members.length, equals(++memberCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(members.length, equals(--memberCount)); 
 
      session.past.redo(); 
      expect(members.length, equals(--memberCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var memberCount = members.length; 
      var member1 = householdModel.members.random(); 
      var member2 = householdModel.members.random(); 
      while (member1 == member2) { 
        member2 = householdModel.members.random();  
      } 
      var action1 = RemoveCommand(session, members, member1); 
      var action2 = RemoveCommand(session, members, member2); 
 
      var transaction = new Transaction("two removes on members", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      memberCount = memberCount - 2; 
      expect(members.length, equals(memberCount)); 
 
      members.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      memberCount = memberCount + 2; 
      expect(members.length, equals(memberCount)); 
 
      members.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      memberCount = memberCount - 2; 
      expect(members.length, equals(memberCount)); 
 
      members.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var memberCount = members.length; 
      var member1 = householdModel.members.random(); 
      var member2 = member1; 
      var action1 = RemoveCommand(session, members, member1); 
      var action2 = RemoveCommand(session, members, member2); 
 
      var transaction = Transaction( 
        "two removes on members, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(members.length, equals(memberCount)); 
 
      //members.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to member actions", () { 
      var memberCount = members.length; 
 
      var reaction = MemberReaction(); 
      expect(reaction, isNotNull); 
 
      memberDomain.startCommandReaction(reaction); 
      var member = Member(members.concept); 
        member.name = 'team'; 
      members.add(member); 
      expect(members.length, equals(++memberCount)); 
      members.remove(member); 
      expect(members.length, equals(--memberCount)); 
 
      var session = memberDomain.newSession(); 
      var addCommand = AddCommand(session, members, member); 
      addCommand.doIt(); 
      expect(members.length, equals(++memberCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, member, "name", 'wife'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      memberDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class MemberReaction implements ICommandReaction { 
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
  var repository = MemberHouseholdRepo(); 
  MemberDomain memberDomain = repository.getDomainModels("Member") as MemberDomain;   
  assert(memberDomain != null); 
  HouseholdModel householdModel = memberDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var members = householdModel.members; 
  testMemberHouseholdMembers(memberDomain, householdModel, members); 
} 
 

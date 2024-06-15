 
part of household_member; 
 
// lib/household/member/model.dart 
 
class MemberModel extends MemberEntries { 
 
  MemberModel(Model model) : super(model); 
 
  void fromJsonToMemberEntry() { 
    fromJsonToEntry(householdMemberMemberEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(householdMemberModel); 
  } 
 
  void init() { 
    initMembers(); 
  } 
 
  void initMembers() { 
    var member1 = Member(members.concept); 
    member1.name = 'team'; 
    members.add(member1); 
 
    var member2 = Member(members.concept); 
    member2.name = 'vacation'; 
    members.add(member2); 
 
    var member3 = Member(members.concept); 
    member3.name = 'distance'; 
    members.add(member3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

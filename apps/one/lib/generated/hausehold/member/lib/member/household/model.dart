 
part of member_household; 
 
// lib/member/household/model.dart 
 
class HouseholdModel extends HouseholdEntries { 
 
  HouseholdModel(Model model) : super(model); 
 
  void fromJsonToMemberEntry() { 
    fromJsonToEntry(memberHouseholdMemberEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(memberHouseholdModel); 
  } 
 
  void init() { 
    initMembers(); 
  } 
 
  void initMembers() { 
    var member1 = Member(members.concept); 
    member1.name = 'judge'; 
    members.add(member1); 
 
    var member2 = Member(members.concept); 
    member2.name = 'observation'; 
    members.add(member2); 
 
    var member3 = Member(members.concept); 
    member3.name = 'beach'; 
    members.add(member3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

 
part of project_user; 
 
// lib/project/user/model.dart 
 
class UserModel extends UserEntries { 
 
  UserModel(Model model) : super(model); 
 
  void fromJsonToUserEntry() { 
    fromJsonToEntry(projectUserUserEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectUserModel); 
  } 
 
  void init() { 
    initUsers(); 
  } 
 
  void initUsers() { 
    var user1 = User(users.concept); 
    user1.name = 'debt'; 
    user1.email = 'oil'; 
    user1.password = 'parfem'; 
    user1.role = 'hall'; 
    user1.status = 'cup'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'dinner'; 
    user2.email = 'mile'; 
    user2.password = 'message'; 
    user2.role = 'theme'; 
    user2.status = 'lake'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'judge'; 
    user3.email = 'instruction'; 
    user3.password = 'abstract'; 
    user3.role = 'money'; 
    user3.status = 'coffee'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

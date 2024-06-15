 
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
    user1.name = 'word'; 
    user1.email = 'tent'; 
    user1.password = 'river'; 
    user1.role = 'slate'; 
    user1.status = 'element'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'hell'; 
    user2.email = 'cable'; 
    user2.password = 'computer'; 
    user2.role = 'nothingness'; 
    user2.status = 'abstract'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'plaho'; 
    user3.email = 'email'; 
    user3.password = 'brad'; 
    user3.role = 'objective'; 
    user3.status = 'beer'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

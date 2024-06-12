 
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
    user1.name = 'grading'; 
    user1.email = 'money'; 
    user1.password = 'salary'; 
    user1.role = 'brave'; 
    user1.status = 'tax'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'consulting'; 
    user2.email = 'cabinet'; 
    user2.password = 'park'; 
    user2.role = 'message'; 
    user2.status = 'darts'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'call'; 
    user3.email = 'lifespan'; 
    user3.password = 'output'; 
    user3.role = 'knowledge'; 
    user3.status = 'candy'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

 
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
    user1.name = 'architecture'; 
    user1.email = 'lake'; 
    user1.password = 'salad'; 
    user1.role = 'house'; 
    user1.status = 'saving'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'hell'; 
    user2.email = 'agile'; 
    user2.password = 'darts'; 
    user2.role = 'cable'; 
    user2.status = 'thing'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'darts'; 
    user3.email = 'distance'; 
    user3.password = 'call'; 
    user3.role = 'city'; 
    user3.status = 'training'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

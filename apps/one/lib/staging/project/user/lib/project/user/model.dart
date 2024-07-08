 
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
    user1.name = 'revolution'; 
    user1.email = 'opinion'; 
    user1.password = 'salad'; 
    user1.role = 'walking'; 
    user1.status = 'redo'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'river'; 
    user2.email = 'advisor'; 
    user2.password = 'heaven'; 
    user2.role = 'job'; 
    user2.status = 'sentence'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'hell'; 
    user3.email = 'photo'; 
    user3.password = 'word'; 
    user3.role = 'restaurant'; 
    user3.status = 'fascination'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

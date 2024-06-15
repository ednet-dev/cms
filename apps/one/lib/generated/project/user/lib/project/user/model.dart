 
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
    user1.name = 'flower'; 
    user1.email = 'circle'; 
    user1.password = 'job'; 
    user1.role = 'candy'; 
    user1.status = 'darts'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'dog'; 
    user2.email = 'highway'; 
    user2.password = 'crisis'; 
    user2.role = 'notch'; 
    user2.status = 'abstract'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'message'; 
    user3.email = 'truck'; 
    user3.password = 'restaurant'; 
    user3.role = 'hospital'; 
    user3.status = 'computer'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

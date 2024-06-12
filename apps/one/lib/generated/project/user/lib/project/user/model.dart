 
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
    user1.name = 'secretary'; 
    user1.email = 'call'; 
    user1.password = 'mile'; 
    user1.role = 'boat'; 
    user1.status = 'ocean'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'judge'; 
    user2.email = 'phone'; 
    user2.password = 'tape'; 
    user2.role = 'dvd'; 
    user2.status = 'hell'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'corner'; 
    user3.email = 'cabinet'; 
    user3.password = 'brad'; 
    user3.role = 'craving'; 
    user3.status = 'secretary'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

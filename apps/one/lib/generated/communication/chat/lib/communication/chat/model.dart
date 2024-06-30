 
part of communication_chat; 
 
// lib/communication/chat/model.dart 
 
class ChatModel extends ChatEntries { 
 
  ChatModel(Model model) : super(model); 
 
  void fromJsonToUserEntry() { 
    fromJsonToEntry(communicationChatUserEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(communicationChatModel); 
  } 
 
  void init() { 
    initUsers(); 
  } 
 
  void initUsers() { 
    var user1 = User(users.concept); 
    user1.name = 'winter'; 
    user1.email = 'tent'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'computer'; 
    user2.email = 'college'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'offence'; 
    user3.email = 'entertainment'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

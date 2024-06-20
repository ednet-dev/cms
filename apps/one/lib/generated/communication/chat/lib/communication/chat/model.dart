 
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
    user1.name = 'algorithm'; 
    user1.email = 'dog'; 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    user2.name = 'electronic'; 
    user2.email = 'left'; 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    user3.name = 'redo'; 
    user3.email = 'river'; 
    users.add(user3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 

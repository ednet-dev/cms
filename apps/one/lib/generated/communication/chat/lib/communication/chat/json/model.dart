part of communication_chat;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/communication/chat/json/model.dart

var communicationChatModelJson = r'''
domain: 'communication'
model: 'chat'
concepts:
  - name: Message
    attributes:
      - name: text
      - name: timestamp
  - name: User
    entry: true
    attributes:
      - name: name
      - name: email
  - name: ApiKey
    attributes:
      - name: key
  - name: Chat
    attributes:
      - name: title
      - name: apiKey
  - name: Category
    attributes:
      - name: name
relations:
  - from: Chat
    to: Message
    fromToName: messages
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: chat
    toFromMin: '1'
    toFromMax: '1'
  - from: Chat
    to: Category
    fromToName: categories
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: chats
    toFromMin: '1'
    toFromMax: '1'

''';
  
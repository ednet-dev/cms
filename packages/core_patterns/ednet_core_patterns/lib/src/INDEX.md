⸻

📖 List of Patterns

⸻

🔹 A

 1. Aggregator ✅ 
How do we combine the results of individual but related messages so that they can be processed as a whole?
 2. Canonical Data Model ✅
How do we minimize dependencies when integrating applications that use different data formats?
 3. Channel Adapter ✅
How do you connect an application to the messaging system so that it can send and receive messages?
 4. Channel Purger
How can you keep leftover messages on a channel from disturbing tests or causing errors?
 5. Claim Check
How can we reduce the data volume of message sent across the system without sacrificing information content?
 6. Command Message
How can messaging be used to invoke a procedure in another application?
 7. Competing Consumers
How can a messaging client process multiple messages concurrently?
 8. Composed Message Processor
How can you combine processing steps to handle a message that contains multiple elements, each of which may have to be processed differently?
 9. Content Enricher
How can we communicate with another system if we do not have all the required data items available?
 10. Content Filter
How do you simplify dealing with a large message, when you are interested only in a few data items?
 11. Content-Based Router
How do we handle a situation where the implementation of a single logical function (e.g., inventory check) is spread across multiple physical systems?
 12. Control Bus
How can we effectively administer a messaging system that is distributed across multiple platforms and a wide geographic area?
 13. Correlation Identifier
How can we correlate one message with a later message, e.g., to recognize that one message is a response to another?
 14. Datatype Channel
How can the application developer make sure that a particular channel is used only for a specific type of message?
 15. Dead Letter Channel
What will the messaging system do with a message it cannot deliver?
 16. Detour
How can you route a message through intermediate steps to perform validation, testing, or debugging functions?
 17. Document Message
How can messaging be used to transfer data between applications?
 18. Durable Subscriber
How can a subscriber avoid missing messages while it's not listening for them?

⸻

🔹 D – E
 19. Dynamic Router
How can you avoid the dependency of the router on all possible destinations while maintaining its efficiency?
 20. Envelope Wrapper
How can existing systems participate in a messaging exchange that places specific requirements on the message format, such as message header fields or encryption?
 21. Event Message
How can messaging be used to transmit events from one application to another?
 22. Event-Driven Consumer
How can an application automatically consume messages as they become available?

⸻

🔹 I – M
 23. Invalid Message Channel
How can a messaging receiver gracefully handle receiving a message that makes no sense?
 24. Invalid Message Identifier
(Note: seems like duplication of Correlation Identifier - to be verified)
 25. Message Aggregator
(Appears to reference Aggregator again - part of same concept)
 26. Message Broker
How can you decouple the destination of a message from the sender and maintain central control over the flow of messages?
 27. Message Bus
How can you decouple the destination of a message from the sender and maintain central control over the flow of messages?
 28. Message Channel
How does one application communicate with another using messaging?
 29. Message Dispatcher
How can multiple consumers on a single channel coordinate their message processing?
 30. Message Endpoint
How does an application connect to a messaging channel to send and receive messages?
 31. Message Expiration
How can a sender indicate when a message should be considered stale and thus shouldn't be processed?
 32. Message Filter
How can a component avoid receiving uninteresting messages?
 33. Message History
How can we effectively analyze and debug the flow of messages in a loosely coupled system?
 34. Message Router
How can you decouple individual processing steps so that messages can be passed to different filters depending on a set of conditions?
 35. Message Sequence
How can messaging be used to transmit events from one application to another?
 36. Message Store
How can you report against message information without disturbing the loosely coupled transactional nature of a messaging system?
 37. Message Translator
How can systems using different data formats communicate with each other using messaging?

⸻

🔹 M – R
 38. Messaging Gateway
How do you encapsulate access to messaging systems from non-messaging systems?
 39. Messaging Mapper
How do you move data between domain objects and the messaging infrastructure while keeping the two independent?
 40. Messaging System
How can I integrate multiple applications so that they work together and can exchange information?
 41. Messaging Bridge
How can multiple messaging systems be connected so that messages can flow across the systems that are using different technologies or versions of messaging protocols?
 42. Messaging Adapter
How do you encapsulate interaction with a messaging system from the rest of the application?
 43. Messaging Monitor
How can we effectively administer a messaging system that is distributed across multiple platforms and a wide geographic area?
 44. Messaging Queue
How can you decouple the destination of a message from the sender and maintain central control over the flow of messages?
 45. Messaging Statistics
How can we perform root-cause analysis on a message which was delivered to the wrong destination?
 46. Messaging Command
How can the sender signal a receiver that it should perform a particular task?
 47. Messaging Error
How can a system handle the failure of a message processing step?
 48. Polling Consumer
How can an application consume a message when the application is ready?
 49. Process Manager
How do we route a message through multiple processing steps when the required steps may not be known at design time and may not be sequential?

⸻

🔹 P – T
 50. Publish-Subscribe Channel
How can the sender broadcast an event to all interested receivers?
 51. Recipient List
How do we route a message to a list of (possibly dynamically specified) recipients?
 52. Remote Procedure Invocation
How can I invoke a procedure in another application when the applications are not tightly integrated and can be on different platforms?
 53. Request-Reply
When an application sends a message, how can it get a response from the receiver?
 54. Resequencer
How can we get a stream of related but out-of-sequence messages back into the correct order?
 55. Return Address
How does a replier know where to send the reply?
 56. Routing Slip
How do we route a message through a series of processing steps when the sequence of steps is not known at design time and may vary for each message?

⸻

🔹 S – T
 57. Scatter-Gather
How do you maintain the overall message flow when a message needs to be sent to multiple recipients, each of which may send a reply?
 58. Selective Consumer
How can a message consumer select which message it wishes to receive?
 59. Service Activator
How can an application design a service to be invoked both via various messaging and non-messaging techniques?
 60. Shared Database
How can multiple applications coordinate their work and data without tight coupling?
 61. Smart Proxy
How can you track messages passing through a system that stores and forwards messages using queues?
 62. Store and Forward Channel
How can we ensure the reliability of message delivery between applications when the communication channel is temporarily unavailable?
 63. System Management
How can you effectively administer a messaging system that is distributed across multiple platforms?
 64. Test Message
How do you inspect messages that travel on a Point-to-Point Channel?
 65. Transactional Client
How can a client control its transactions with the messaging system?

⸻
---

## 🧩 1. Aggregator ✅

**🧠 Explanation**: Combine multiple related messages into one final result. Useful when processing parts of a whole (e.g., batch responses).

**🛠️ Dart Interface and Implementation**:
```dart
abstract class MessageAggregator<T> {
  void addMessage(Message message);
  bool isComplete();
  T getAggregatedResult();
  void reset();
}

// Implemented variants:
// - CountBasedAggregator: aggregates until reaching a specified count
// - TimeBasedAggregator: aggregates until a timeout occurs
```

**📦 Integration Point**: `lib/src/patterns/aggregator/aggregator.dart`  
**🔗 Related Concepts**: correlation ID, message grouping, composite results  

**🧪 Tests**:
- Count-based aggregation with correlation ID
- Time-based aggregation with timeout
- Error conditions and edge cases

**🌟 EDNet Integration**:
The Aggregator pattern is crucial for collective decision-making in direct democracy systems:
- Gathering citizen votes across distributed voting platforms
- Combining feedback from multiple stakeholder groups
- Assembling fragments of proposals into complete policy documents
- Consolidating statistical analysis from multiple data sources

---

## 🧩 2. Canonical Data Model ✅

**🧠 Explanation**: Minimize coupling between systems by using a shared internal format for data interchange.

**🛠️ Dart Interface and Implementation**:
```dart
class CanonicalModel<T> {
  final String type;
  final T data;
  final Map<String, dynamic>? metadata;
  
  // Core functionality
  String toJson();
  static CanonicalModel<Map<String, dynamic>> fromJson(String json);
}

// Supporting classes:
// - ModelFormatter: converts between canonical and external formats
// - ModelValidator: validates models against schemas
```

**📦 Integration Point**: `lib/src/patterns/canonical/canonical_model.dart`  
**🔗 Related Concepts**: data transformation, schema validation, system integration

**🧪 Tests**:
- Conversion between different system formats
- Serialization to and from JSON
- Schema validation for data integrity

**🌟 EDNet Integration**:
The Canonical Data Model pattern is essential in EDNet for:
- Standardizing citizen identity data across voting platforms
- Representing proposals and amendments in a system-agnostic way
- Defining common formats for voting results and analytics
- Integrating with various external identity providers and services

---

## 🧩 3. Channel Adapter ✅

**🧠 Explanation**: Bridge between external systems and the internal messaging infrastructure. Translates protocols or transports (e.g., HTTP, WebSocket).

**🛠️ Dart Interface and Implementation**:
```dart
abstract class ChannelAdapter<I, O> {
  final Channel channel;
  
  Future<void> handleIncoming(I input);
  Future<O> handleOutgoing(Message message);
  Future<void> start();
  Future<void> stop();
}

// Implemented variants:
// - HttpChannelAdapter: adapts HTTP requests/responses to messages
// - WebSocketChannelAdapter: adapts WebSocket communications to messages
```

**📦 Integration Point**: `lib/src/patterns/channel/adapter/channel_adapter.dart`  
**🔗 Related Concepts**: protocol translation, API gateways, service integration

**🧪 Tests**:
- HTTP request conversion to internal messages
- Message conversion to HTTP responses
- WebSocket bidirectional communication
- Error handling and edge cases

**🌟 EDNet Integration**:
The Channel Adapter pattern is vital in EDNet for:
- Building RESTful APIs for citizen engagement platforms
- Integrating with existing government services via standard protocols
- Creating WebSocket interfaces for real-time voting and deliberation
- Enabling mobile app communication with the democracy infrastructure

---

## 🧩 4. Channel Purger

**🧠 Explanation**: Clears stale or leftover messages from a channel before testing or bootstrapping.

**🛠️ Dart Interface Proposal**:
```dart
abstract class ChannelPurger {
  Future<void> purge(Channel channel);
}
```

**📦 Integration Point**: `lib/src/patterns/channel/util/channel_purger.dart`  
**🔗 Related Concepts**: test preparation, TTL, expired message cleanup

**🧪 Suggested Test**:
```dart
test('ChannelPurger clears messages in test setup', () async {
  final purger = InMemoryChannelPurger();
  final channel = InMemoryChannel();
  channel.send(Message(...));
  await purger.purge(channel);
  expect(await channel.receive().isEmpty, isTrue);
});
```

---

## 🧩 5. Claim Check

**🧠 Explanation**: Store large or sensitive message payloads externally and replace with a lightweight reference (claim check).

**🛠️ Dart Interface Proposal**:
```dart
abstract class ClaimStore {
  Future<String> storePayload(dynamic payload);
  Future<dynamic> retrievePayload(String claimCheckId);
}

class ClaimCheckMessage {
  final String claimId;
  final Map<String, dynamic> metadata;
}
```

**📦 Integration Point**: `lib/src/patterns/claim/claim_check.dart`  
**🔗 Related Concepts**: external blob storage, payload offloading

**🧪 Suggested Test**:
```dart
test('ClaimStore saves and retrieves large payload correctly', () async {
  final store = InMemoryClaimStore();
  final id = await store.storePayload({'data': 'large-content'});
  final result = await store.retrievePayload(id);
  expect(result, contains('large-content'));
});
```

---
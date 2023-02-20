//
// class Calendar extends Entity {
//   final DateTime today;
//
//   Calendar({
//     id,
//     today,
//   })  : today = today ?? DateTime.now(),
//         id = id ?? const Uuid().v4();
//
//   // ...
//   // Path: lib/time/calendar/calendar.dart
//   static Calendar get defaultCalendar => Calendar(
//         today: DateTime.now(),
//         type: CalendarType.gregorian,
//       );
//
//   @override
//   List<EntityCommand> commands = [];
//
//   @override
//   String description = 'Calendar';
//
//   @override
//   String id = const Uuid().v4();
//
//   @override
//   List<EntityEvent> interests = [];
//
//   @override
//   List<EntityPolicy> policies = [];
//
//   @override
//   List<String> tags = [];
//
//   @override
//   List<EntityEvent> topics = [];
//
//   @override
//   // TODO: implement attributes
//   List<EntityAttribute> get attributes => throw UnimplementedError();
//
//   get today => null;
//
//   @override
//   getAttributeByName(String name) {
//     // TODO: implement getAttributeByName
//     throw UnimplementedError();
//   }
//
//   @override
//   getAttributesByType(String type) {
//     // TODO: implement getAttributesByType
//     throw UnimplementedError();
//   }
//
//   @override
//   getAttributesNames() {
//     // TODO: implement getAttributesNames
//     throw UnimplementedError();
//   }
//
//   @override
//   getValueByName(String name) {
//     // TODO: implement getValueByName
//     throw UnimplementedError();
//   }
//
//   @override
//   // TODO: implement name
//   String get name => throw UnimplementedError();
//
//   @override
//   // TODO: implement status
//   get status => throw UnimplementedError();
//
//   @override
//   Map<String, dynamic> toJson() {
//     // TODO: implement toJson
//     throw UnimplementedError();
//   }
// }
//
// enum CalendarType {
//   gregorian,
//   julian,
//   hebrew,
//   islamic,
//   buddhist,
//   chinese,
//   coptic,
//   ethiopicAmeteAlem,
//   ethiopicAmeteMihret,
//   indian,
//   islamicCivil,
//   japanese,
//   persian,
//   roc,
//   umAlQura,
// }

part of ednet_core;
//
// /// ValueObject abstraction
// abstract class ValueObject {
//   /// ValueObject name
//   final String name;
//
//   /// ValueObject description
//   final String description;
//
//   /// ValueObject version
//   final String version;
//
//   /// ValueObject attributes
//   final List<EntityAttributes> attributes;
//
//   /// ValueObject constructor
//   ValueObject(
//     this.description,
//     this.version, {
//     required this.name,
//     required this.attributes,
//   });
//
//   String get toJson => '''
//   {
//     "name": "$name",
//     "description": "$description",
//     "version": "$version",
//     "attributes": ${attributes.map((e) => e.toJson).join(',')}
//   }
//   ''';
// }

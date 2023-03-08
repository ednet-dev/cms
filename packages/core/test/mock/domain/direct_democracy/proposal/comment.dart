// import 'package:ednet_core/ednet_core.dart';
// import '../../../../../../../../../home/slavisam/.config/Google/AndroidStudio2021.3/scratches/semantic_attribute.dart';
// import 'package:uuid/uuid.dart';
//
// class Comment extends Entity {
//   final String id;
//   final String proposalId;
//   final String authorId;
//   final String content;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Comment({
//     this.id,
//     this.proposalId,
//     this.authorId,
//     this.content,
//     this.createdAt,
//     this.updatedAt,
//   }) : super(id);
//
//   Comment copyWith({
//     String id,
//     String proposalId,
//     String authorId,
//     String content,
//     DateTime createdAt,
//     DateTime updatedAt,
//   }) {
//     return Comment(
//       id: id ?? this.id,
//       proposalId: proposalId ?? this.proposalId,
//       authorId: authorId ?? this.authorId,
//       content: content ?? this.content,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Comment &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           proposalId == other.proposalId &&
//           authorId == other.authorId &&
//           content == other.content &&
//           createdAt == other.createdAt &&
//           updatedAt == other.updatedAt;
//
//   @override
//   int get hashCode =>
//       id.hashCode ^
//       proposalId.hashCode ^
//       authorId.hashCode ^
//       content.hashCode ^
//       createdAt.hashCode ^
//       updatedAt.hashCode;
//
//   @override
//   String toString() {
//     return 'Comment{id: $id, proposalId: $proposalId, authorId: $authorId, content: $content, createdAt: $createdAt, updatedAt: $updatedAt}';
//   }
//
//   static Comment fromJson(Map<String, dynamic> json) {
//     return Comment(
//       id: json['id'],
//       proposalId: json['proposalId'],
//       authorId: json['authorId'],
//       content: json['content'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'proposalId': proposalId,
//       'authorId': authorId,
//       'content': content,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
//
//   static Comment create({
//     String proposalId,
//     String authorId,
//     String content,
//   }) {
//     return Comment(
//       id: Uuid().v4(),
//       proposal: proposalId,
//       authorId: authorId,
//       content: content,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }
//
//   @override
//   List<SemanticAttribute> attributes;
//
//   @override
//   List<EntityCommand> commands;
//
//   @override
//   String description;
//
//   @override
//   List<EntityEvent> interests;
//
//   @override
//   String name;
//
//   @override
//   List<EntityPolicy> policies;
//
//   @override
//   List<String> tags;
//
//   @override
//   List<EntityEvent> topics;
//
//   @override
//   set id(String value) {
//     // TODO: implement id
//   }
//
//   @override
//   // TODO: implement toJson
//   String get toJson => throw UnimplementedError();
// }

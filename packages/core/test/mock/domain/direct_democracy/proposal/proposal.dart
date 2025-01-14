// import 'package:ednet_core/ednet_core.dart';
// import 'package:uuid/uuid.dart';
//
// import 'comment.dart';
// import 'vote.dart';
//
// class Proposal extends Entity {
//   @override
//   List<EntityCommand> commands = [];
//
//   @override
//   String description =
//       'A proposal is a piece of text that is attached to a vote.';
//
//   @override
//   List<EntityEvent> interests = [];
//
//   @override
//   String name = 'Proposal';
//
//   @override
//   List<EntityPolicy> policies = [];
//
//   @override
//   List<String> tags = ['proposal', 'text', 'vote'];
//
//   @override
//   List<EntityEvent> topics = [];
//
//   @override
//   String id = const Uuid().v4();
//
//   @override
//   Map<String, Object> attributes = {};
//
//   String title;
//   List<Comment> comments = [];
//   List<Vote> votes;
//
//   /// then solve it in constructor:
//
//   Proposal({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.comments,
//     required this.votes,
//   }) {
//     attributes['id'] = id;
//     attributes['title'] = title;
//     attributes['comments'] = comments;
//     attributes['votes'] = votes;
//   }
//
//   void addComment(Comment comment) {
//     comments.add(comment);
//   }
//
//   void removeComment(Comment comment) {
//     comments.remove(comment);
//   }
//
//   void addVote(Vote vote) {
//     votes.add(vote);
//   }
//
//   void removeVote(Vote vote) {
//     votes.remove(vote);
//   }
// }

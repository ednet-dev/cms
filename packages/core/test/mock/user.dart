import 'package:ednet_core/ednet_core.dart';

// class User extends Entity {
//   @override
//   List<EntityCommand> commands;
//
//   @override
//   String description;
//
//   @override
//   String id;
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
//   // constructor
//   User({
//     required this.commands,
//     required this.description,
//     required this.id,
//     required this.interests,
//     required this.name,
//     required this.policies,
//     required this.tags,
//     required this.topics,
//   });
//
//   double walletBalance = 0;
//
//   // increase wallet balance
//   double increaseWalletBalance(double amount) {
//     walletBalance += amount;
//     return walletBalance;
//   }
//
//   // decrease wallet balance
//   double decreaseWalletBalance(double amount) {
//     // add safety check
//     if (walletBalance - amount < 0) {
//       throw Exception('Insufficient funds');
//     }
//     walletBalance -= amount;
//
//     return walletBalance;
//   }
//
//   //
//   // // some additional user specific behaviour
//   // String getFullName() {
//   //   return '$name ${attributes['surname']}';
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getAvatarUrl() {
//   //   return attributes['avatar_url'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getBio() {
//   //   return attributes['bio'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getWebsite() {
//   //   return attributes['website'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getTwitter() {
//   //   return attributes['twitter'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getGithub() {
//   //   return attributes['github'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getFacebook() {
//   //   return attributes['facebook'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getLinkedin() {
//   //   return attributes['linkedin'];
//   // }
//   //
//   // // some additional user specific behaviour
//   // Object? getInstagram() {
//   //   return attributes['instagram'];
//   // }
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
//   toJson() {
//     // TODO: implement toJson
//     throw UnimplementedError();
//   }
//
//   @override
//   // TODO: implement attributes
//   List<EntityAttribute> get attributes => throw UnimplementedError();
//
//   @override
//   // TODO: implement status
//   get status => throw UnimplementedError();
// }

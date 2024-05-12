library direct_democracy;

import 'package:ednet_core/ednet_core.dart';

class Vote extends Entity<Vote> {
  static const String isForAttribute = 'isFor';
  static const String voterAttribute = 'voter';
  static const String initiativeAttribute = 'initiative';

  Vote(Concept concept) {
    this.concept = concept;
  }

  bool get isFor => getAttribute(isForAttribute);

  set isFor(bool isFor) => setAttribute(isForAttribute, isFor);

  Voter get voter => getAttribute(voterAttribute);

  set voter(Voter voter) => setAttribute(voterAttribute, voter);

  Initiative get initiative => getAttribute(initiativeAttribute);

  set initiative(Initiative initiative) =>
      setAttribute(initiativeAttribute, initiative);
}

class Votes extends Entities<Vote> {
  Votes(Concept concept) {
    this.concept = concept;
  }
}

abstract class Voter extends Entity<Voter> {
  static const String fullNameAttribute = 'fullName';
  static const String emailAttribute = 'email';

  String get fullName => getAttribute(fullNameAttribute);

  set fullName(String fullName) => setAttribute(fullNameAttribute, fullName);

  String get email => getAttribute(emailAttribute);

  set email(String email) => setAttribute(emailAttribute, email);
}

class Initiative extends Entity<Initiative> {
  static const String titleAttribute = 'title';
  static const String descriptionAttribute = 'description';
  static const String isActiveAttribute = 'isActive';
  static const String supportersAttribute = 'supporters';
  static const String oppositionAttribute = 'opposition';

  String get title => getAttribute(titleAttribute);

  set title(String title) => setAttribute(titleAttribute, title);

  String get description => getAttribute(descriptionAttribute);

  set description(String description) =>
      setAttribute(descriptionAttribute, description);

  bool get isActive => getAttribute(isActiveAttribute);

  set isActive(bool isActive) => setAttribute(isActiveAttribute, isActive);

  List<Voter> get supporters => getAttribute(supportersAttribute);

  set supporters(List<Voter> supporters) =>
      setAttribute(supportersAttribute, supporters);

  List<Voter> get opposition => getAttribute(oppositionAttribute);

  set opposition(List<Voter> opposition) =>
      setAttribute(oppositionAttribute, opposition);

  void registerVote(Voter voter, bool isFor) {
    // business logic
  }
}

class Citizen extends Entity<Citizen> {
  static const String nameAttribute = 'fullName';

  String get name => getAttribute(nameAttribute).getValue();

  set name(String name) => getAttribute(name).setValue(name);
}

// Proposal
class Proposal extends Entity<Proposal> {
  static const String titleAttribute = 'title';
  static const String descriptionAttribute = 'description';
  static const String statusAttribute = 'status';
  static const String votesForAttribute = 'votesFor';
  static const String votesAgainstAttribute = 'votesAgainst';
  static const String voterAttribute = 'voter';
  static const String supportersAttribute = 'supporters';
  static const String oppositionAttribute = 'opposition';

  String get title => getAttribute(titleAttribute).getValue();

  set title(String title) => getAttribute(title).setValue(title);

  String get description => getAttribute(descriptionAttribute).getValue();

  set description(String description) =>
      getAttribute(description).setValue(description);

  String get status => getAttribute(statusAttribute).getValue();

  set status(String status) => getAttribute(statusAttribute).setValue(status);

  int get votesFor => getAttribute(votesForAttribute).getValue();

  set votesFor(int votesFor) =>
      getAttribute(votesForAttribute).setValue(votesFor);

  int get votesAgainst => getAttribute(votesAgainstAttribute).getValue();

  set votesAgainst(int votesAgainst) =>
      getAttribute(votesAgainstAttribute).setValue(votesAgainst);
}

// class TravelModels extends DomainModels {
//
//   TravelModels(Domain domain) : super(domain) {
//     add(fromJsonToImpressionsEntries());
//   }
//
//   ImpressionsEntries fromJsonToImpressionsEntries() {
//     return new ImpressionsEntries(fromJsonToModel(
//         travelImpressionsModelJson,
//         domain,
//         TravelRepo.travelImpressionsModelCode));
//   }
//
// }
//
//
// class DDRepo extends CoreRepository {
//   static const categoryQuestionDomainCode = "CategoryQuestion";
//   static const categoryQuestionLinkModelCode = "Link";
//
//   DDRepo({String code: "CategoryQuestionRepo"}) : super(code) {
//     _initCategoryQuestionDomain();
//   }
//
//   _initCategoryQuestionDomain() {
//     var categoryQuestionDomain = Domain(categoryQuestionDomainCode);
//     domains.add(categoryQuestionDomain);
//     add(CategoryQuestionModels(categoryQuestionDomain));
//   }
//
// }

import 'package:ednet_core/ednet_core.dart';

Model createDomainModel() {
  Domain domain = new Domain('DirectDemocracy');
  Model model = new Model(domain, 'DirectDemocracyModel');
  assert(domain.models.length == 1);

  Concept userConcept = new Concept(model, 'User');
  userConcept.description = 'Represents a registered user on the platform.';
  assert(model.concepts.length == 1);
  new Attribute(userConcept, 'email').identifier = true;
  new Attribute(userConcept, 'name');
  new Attribute(userConcept, 'password');
  // ...

  Concept proposalConcept = new Concept(model, 'Proposal');
  proposalConcept.description =
      'Represents a proposal for a decision or action to be taken within a particular context.';
  assert(model.concepts.length == 2);
  new Attribute(proposalConcept, 'id').identifier = true;
  new Attribute(proposalConcept, 'title');
  new Attribute(proposalConcept, 'description');
  // ...

  Concept voteConcept = new Concept(model, 'Vote');
  voteConcept.description =
      'Represents a vote cast by a user on a particular proposal.';
  assert(model.concepts.length == 3);
  new Attribute(voteConcept, 'id').identifier = true;
  new Attribute(voteConcept, 'voteType');
  // ...

  Concept issueConcept = new Concept(model, 'Issue');
  issueConcept.description =
      'Represents a topic or question that is open for discussion and debate among users on the platform.';
  assert(model.concepts.length == 4);
  new Attribute(issueConcept, 'id').identifier = true;
  new Attribute(issueConcept, 'title');
  new Attribute(issueConcept, 'description');
  // ...

  Concept commentConcept = new Concept(model, 'Comment');
  commentConcept.description =
      'Represents a comment made by a user on a particular issue.';
  assert(model.concepts.length == 5);
  new Attribute(commentConcept, 'id').identifier = true;
  new Attribute(commentConcept, 'text');
  // ...

  Concept expertConcept = new Concept(model, 'Expert');
  expertConcept.description =
      'Represents a user who has specialized knowledge or experience in a particular field or topic.';
  assert(model.concepts.length == 6);
  new Attribute(expertConcept, 'fieldOfExpertise').identifier = true;
// ...

  Child userProposalsNeighbor =
      new Child(userConcept, proposalConcept, 'proposals');
  Parent proposalUserNeighbor =
      new Parent(proposalConcept, userConcept, 'user');
  proposalUserNeighbor.identifier = true;
  userProposalsNeighbor.opposite = proposalUserNeighbor;
  proposalUserNeighbor.opposite = userProposalsNeighbor;
  assert(userConcept.children.length == 1);
  assert(proposalConcept.parents.length == 1);
  assert(userConcept.sourceParents.length == 1);
  assert(proposalConcept.sourceChildren.length == 1);

  Child proposalVotesNeighbor =
      new Child(proposalConcept, voteConcept, 'votes');
  Parent voteProposalNeighbor =
      new Parent(voteConcept, proposalConcept, 'proposal');
  voteProposalNeighbor.identifier = true;
  proposalVotesNeighbor.opposite = voteProposalNeighbor;
  voteProposalNeighbor.opposite = proposalVotesNeighbor;
  assert(proposalConcept.children.length == 1);
  assert(voteConcept.parents.length == 1);
  assert(proposalConcept.sourceParents.length == 1);
  assert(voteConcept.sourceChildren.length == 1);

  Child issueCommentsNeighbor =
      new Child(issueConcept, commentConcept, 'comments');
  Parent commentIssueNeighbor =
      new Parent(commentConcept, issueConcept, 'issue');
  commentIssueNeighbor.identifier = true;
  issueCommentsNeighbor.opposite = commentIssueNeighbor;
  commentIssueNeighbor.opposite = issueCommentsNeighbor;
  assert(issueConcept.children.length == 1);
  assert(commentConcept.parents.length == 1);
  assert(issueConcept.sourceParents.length == 1);
  assert(commentConcept.sourceChildren.length == 1);

  Child userCommentsNeighbor =
      new Child(userConcept, commentConcept, 'comments');
  Parent commentUserNeighbor = new Parent(commentConcept, userConcept, 'user');
  commentUserNeighbor.identifier = true;
  userCommentsNeighbor.opposite = commentUserNeighbor;
  commentUserNeighbor.opposite = userCommentsNeighbor;
  assert(userConcept.children.length == 1);
  assert(commentConcept.parents.length == 1);
  assert(userConcept.sourceParents.length == 1);
  assert(commentConcept.sourceChildren.length == 1);

  Child expertUsersNeighbor = new Child(expertConcept, userConcept, 'users');
  Parent userExpertNeighbor = new Parent(userConcept, expertConcept, 'expert');
  userExpertNeighbor.identifier = true;
  expertUsersNeighbor.opposite = userExpertNeighbor;
  userExpertNeighbor.opposite = expertUsersNeighbor;
  assert(expertConcept.children.length == 1);
  assert(userConcept.parents.length == 1);
  assert(expertConcept.sourceParents.length == 1);
  assert(userConcept.sourceChildren.length == 1);

  return model;
}

class UserConcept extends Concept {
  UserConcept(super.model, super.conceptCode);
}

ModelEntries createModelData(Model model) {
  var entries = new ModelEntries(model);
  Entities users = entries.getEntry('User');
  assert(users.length == 0);

  Entity user1 = new Entity<Concept>();
  user1.concept = users.concept!;
  user1.setAttribute('email', 'user1@example.com');
  user1.setAttribute('name', 'User One');
  user1.setAttribute('password', 'password1');
// ...

  Entities proposals = entries.getEntry('Proposal');
  assert(proposals.length == 0);

  Entity proposal1 = new Entity<Concept>();
  proposal1.concept = proposals.concept!;
  proposal1.setAttribute('id', 1);
  proposal1.setAttribute('title', 'Proposal One');
  proposal1.setAttribute('description', 'Description of Proposal One');
  proposal1.setParent('user', user1);
// ...

  Entities votes = entries.getEntry('Vote');
  assert(votes.length == 0);

  Entity vote1 = new Entity<Concept>();
  vote1.concept = votes.concept!;
  vote1.setAttribute('id', 1);
  vote1.setAttribute('title', 'Vote One');
  vote1.setAttribute('description', 'Description of Vote One');
  vote1.setParent('user', user1);
  //...

  Entities comments = entries.getEntry('Comment');
  assert(comments.length == 0);

  Entity comment1 = new Entity<Concept>();
  comment1.concept = comments.concept!;
  comment1.setAttribute('id', 1);

  Entity comment2 = new Entity<Concept>();
  comment2.concept = comments.concept!;
  comment2.setAttribute('id', 2);

  Entity comment3 = new Entity<Concept>();
  comment3.concept = comments.concept!;
  comment3.setAttribute('id', 3);

  Entity comment4 = new Entity<Concept>();
  comment4.concept = comments.concept!;
  comment4.setAttribute('id', 4);

  return entries;
}

void main() {
  Model model = createDomainModel();
  ModelEntries entries = createModelData(model);

  print('ojha');
}

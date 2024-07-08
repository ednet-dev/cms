// import 'package:isar/isar.dart';
//
// import '../comment.dart';
// import '../proposal.dart';
// import '../vote.dart';
//
// /// Proposal service handles all the business logic of the proposal entity.
// /// enabling clients to decide about any proposal colaboratively and with transparent
// /// and communicated consensus.
// /// Implement at least five user cases from domain model of direct democracy
//
// class ProposalService {
//   final ProposalRepository proposalRepository;
//
//   ProposalService({
//     required this.proposalRepository,
//   });
//
//   /// Create a new proposal
//   Future<Proposal> createProposal({
//     required String title,
//     required String description,
//     required List<Comment> comments,
//     required List<Vote> votes,
//   }) async {
//     final proposal = Proposal(
//       title: title,
//       description: description,
//       comments: comments,
//       votes: votes,
//       id: '1',
//     );
//     await proposalRepository.createProposal(proposal);
//     return proposal;
//   }
//
//   /// Get a proposal by id
//   Future<Proposal> getProposalById(String id) async {
//     final proposal = await proposalRepository.getProposalById(id);
//     return proposal;
//   }
//
//   /// Update a proposal
//   Future<Proposal> updateProposal(Proposal proposal) async {
//     final updatedProposal = await proposalRepository.updateProposal(proposal);
//     return updatedProposal;
//   }
//
//   /// Delete a proposal
//   Future<void> deleteProposal(Proposal proposal) async {
//     await proposalRepository.deleteProposal(proposal);
//   }
//
//   /// Get all proposals
//   Future<List<Proposal>> getAllProposals() async {
//     final proposals = await proposalRepository.getAllProposals();
//     return proposals;
//   }
// }
//
// /// Proposal repository
// /// Handles all the data access of the proposal entity.
// /// Implement at least five user cases from domain model of direct democracy
//
// abstract class ProposalRepository {
//   /// Create a new proposal
//   Future<void> createProposal(Proposal proposal);
//
//   /// Get a proposal by id
//   Future<Proposal> getProposalById(String id);
//
//   /// Update a proposal
//   Future<Proposal> updateProposal(Proposal proposal);
//
//   /// Delete a proposal
//   Future<void> deleteProposal(Proposal proposal);
//
//   /// Get all proposals
//   Future<List<Proposal>> getAllProposals();
// }
//
// /// Proposal repository mock
// /// Handles all the data access of the proposal entity.
// /// Implement at least five user cases from domain model of direct democracy
//
// class ProposalRepositoryIsar extends ProposalRepository {
//   final Isar isar;
//
//   ProposalRepositoryIsar({required this.isar});
//
//   /// Create a new proposal
//   Future<void> createProposal(Proposal proposal) async {
//     // final isarProposal = IsarProposal(
//     //     id: '1',
//     //     title: 'title',
//     //     description: 'description',
//     //     comments: [],
//     //     votes: []);
//     // isarProposal.id = proposal.id;
//     // isarProposal.title = proposal.title;
//     // isarProposal.description = proposal.description;
//     // isarProposal.comments = proposal.comments;
//     // isarProposal.votes = proposal.votes;
//     // isarProposal.attributes = proposal.attributes;
//     // await isar.proposals.put(isarProposal);
//   }
//
//   /// Get a proposal by id
//   Future<Proposal> getProposalById(String id) async {
//     // final isarProposal = await isar.proposals.get(id);
//     // final proposal = Proposal(
//     //   id: isarProposal.id,
//     //   title: isarProposal.title,
//     //   description: isarProposal.description,
//     //   comments: isarProposal.comments,
//     //   votes: isarProposal.votes,
//     //   attributes: isarProposal.attributes,
//     // );
//     // return proposal;
//     return Proposal(
//       id: '1',
//       title: 'title',
//       description: 'description',
//       comments: [],
//       votes: [],
//     );
//   }
//
//   /// Update a proposal
//   Future<Proposal> updateProposal(Proposal proposal) async {
//     // final isarProposal = IsarProposal();
//     // isarProposal.id = proposal.id;
//     // isarProposal.title = proposal.title;
//     // isarProposal.description = proposal.description;
//     // isarProposal.comments = proposal.comments;
//     // isarProposal.votes = proposal.votes;
//     // isarProposal.attributes = proposal.attributes;
//     // await isar.proposals.put(isarProposal);
//     return proposal;
//   }
//
//   /// Delete a proposal
//   Future<void> deleteProposal(Proposal proposal) async {
//     // await isar.proposals.delete(proposal.id);
//   }
//
//   /// Get all proposals
//   Future<List<Proposal>> getAllProposals() async {
//     return [];
//     // final isarProposals = await isar.proposals.find().toList();
//     // final proposals = isarProposals
//     //     .map((isarProposal) => Proposal(
//     //           id: isarProposal.id,
//     //           title: isarProposal.title,
//     //           description: isarProposal.description,
//     //           comments: isarProposal.comments,
//     //           votes: isarProposal.votes,
//     //           attributes: isarProposal.attributes,
//     //         ))
//     //     .toList();
//     // return proposals;
//   }
// }
//
// /// Isar proposal
// /// Handles all the data access of the proposal entity.
// /// Implement at least five user cases from domain model of direct democracy
//
// @Collection()
// class IsarProposal {
//   String id;
//
//   String title;
//
//   String description;
//
//   List<Comment> comments;
//
//   List<Vote> votes;
//
//   Map<String, dynamic> attributes;
//
//   IsarProposal({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.comments,
//     required this.votes,
//     required this.attributes,
//   });
// }

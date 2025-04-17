import 'package:ednet_core/ednet_core.dart';

/// Represents a GitHub Pull Request in the development workflow
class PullRequest extends Entity<PullRequest> {
  /// The title of the pull request
  final String title;
  
  /// The body content of the pull request
  final String body;
  
  /// The base branch (target for merging)
  final String baseBranch;
  
  /// The head branch (containing changes)
  final String headBranch;
  
  /// List of linked issue IDs
  final List<String> linkedIssues;
  
  /// Milestone ID if assigned
  final String? milestoneId;
  
  /// Labels applied to the PR
  final List<String> labels;
  
  /// Current state of the PR
  final PullRequestState state;
  
  /// GitHub API URL for this PR
  final String? apiUrl;
  
  /// Web URL for viewing this PR in browser
  final String? webUrl;
  
  PullRequest({
    required Id id,
    required this.title,
    required this.body,
    required this.baseBranch,
    required this.headBranch,
    this.linkedIssues = const [],
    this.milestoneId,
    this.labels = const [],
    this.state = PullRequestState.draft,
    this.apiUrl,
    this.webUrl,
  }) : super(id);
  
  @override
  List<Object?> get props => [
    id,
    title,
    body,
    baseBranch,
    headBranch,
    linkedIssues,
    milestoneId,
    labels,
    state,
    apiUrl,
    webUrl,
  ];
  
  /// Creates a copy of this PR with the given fields replaced
  @override
  PullRequest copyWith({
    Id? id,
    String? title,
    String? body,
    String? baseBranch,
    String? headBranch,
    List<String>? linkedIssues,
    String? milestoneId,
    List<String>? labels,
    PullRequestState? state,
    String? apiUrl,
    String? webUrl,
  }) {
    return PullRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      baseBranch: baseBranch ?? this.baseBranch,
      headBranch: headBranch ?? this.headBranch,
      linkedIssues: linkedIssues ?? this.linkedIssues,
      milestoneId: milestoneId ?? this.milestoneId,
      labels: labels ?? this.labels,
      state: state ?? this.state,
      apiUrl: apiUrl ?? this.apiUrl,
      webUrl: webUrl ?? this.webUrl,
    );
  }
  
  /// Adds an issue to the list of linked issues
  PullRequest linkIssue(String issueId) {
    if (linkedIssues.contains(issueId)) return this;
    
    final newLinkedIssues = List<String>.from(linkedIssues)..add(issueId);
    return copyWith(linkedIssues: newLinkedIssues);
  }
  
  /// Opens the PR (changes state from draft)
  PullRequest open() {
    return copyWith(state: PullRequestState.open);
  }
  
  /// Closes the PR
  PullRequest close() {
    return copyWith(state: PullRequestState.closed);
  }
  
  /// Marks the PR as merged
  PullRequest merge() {
    return copyWith(state: PullRequestState.merged);
  }
  
  @override
  String toString() => 'PR#${id.toString()}: $title ($state)';
}

/// The possible states of a pull request
enum PullRequestState {
  draft,
  open,
  closed,
  merged,
} 
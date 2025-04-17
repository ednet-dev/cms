import 'dart:io';
import 'package:ednet_core/ednet_core.dart';
import '../model/github/pull_request.dart';

/// Service for interacting with GitHub API
class GitHubService extends DomainService {
  final String _owner;
  final String _repo;
  final String? _token;

  GitHubService({
    required String owner,
    required String repo,
    String? token,
  })  : _owner = owner,
        _repo = repo,
        _token = token;

  /// Create a pull request using GitHub CLI
  Future<PullRequest?> createPullRequest({
    required String title,
    required String body,
    required String baseBranch,
    required String headBranch,
    List<String> labels = const [],
    String? milestone,
  }) async {
    try {
      // Prepare the command
      final args = [
        'pr', 'create',
        '--title', title,
        '--body', body,
        '--base', baseBranch,
        '--head', headBranch,
      ];

      // Add labels if present
      if (labels.isNotEmpty) {
        args.addAll(['--label', labels.join(',')]);
      }

      // Add milestone if present
      if (milestone != null) {
        args.addAll(['--milestone', milestone]);
      }

      // Run the command
      final result = await Process.run('gh', args);
      
      if (result.exitCode != 0) {
        print('Error creating PR: ${result.stderr}');
        return null;
      }

      // Extract the PR number and URL from output
      final output = result.stdout.toString();
      final prNumber = _extractPrNumber(output);
      final prUrl = _extractPrUrl(output);

      if (prNumber == null) {
        print('Could not extract PR number from: $output');
        return null;
      }

      // Create and return PR entity
      return PullRequest(
        id: Id(prNumber),
        title: title,
        body: body,
        baseBranch: baseBranch,
        headBranch: headBranch,
        labels: labels,
        webUrl: prUrl,
      );
    } catch (e) {
      print('Exception creating PR: $e');
      return null;
    }
  }

  /// List open issues in the repository
  Future<List<Map<String, dynamic>>> listOpenIssues() async {
    try {
      final result = await Process.run('gh', [
        'issue', 'list',
        '--repo', '$_owner/$_repo',
        '--state', 'open',
        '--json', 'number,title,url,labels,milestone'
      ]);

      if (result.exitCode != 0) {
        print('Error listing issues: ${result.stderr}');
        return [];
      }

      // Parse the JSON output
      final output = result.stdout.toString();
      // This would require a JSON parsing library
      // For now, we'll return a placeholder
      return [];
    } catch (e) {
      print('Exception listing issues: $e');
      return [];
    }
  }

  /// List available milestones
  Future<List<Map<String, dynamic>>> listMilestones() async {
    try {
      final result = await Process.run('gh', [
        'api',
        'repos/$_owner/$_repo/milestones',
        '--jq', '.[].{number: number, title: title, description: description}'
      ]);

      if (result.exitCode != 0) {
        print('Error listing milestones: ${result.stderr}');
        return [];
      }

      // Parse the JSON output
      final output = result.stdout.toString();
      // This would require a JSON parsing library
      // For now, we'll return a placeholder
      return [];
    } catch (e) {
      print('Exception listing milestones: $e');
      return [];
    }
  }

  /// Link a PR to issues
  Future<bool> linkIssues(String prNumber, List<String> issueNumbers) async {
    try {
      // Build the comment body with issue references
      final references = issueNumbers.map((issue) => "#$issue").join(", ");
      final commentBody = "Linked to issues: $references";

      final result = await Process.run('gh', [
        'pr', 'comment', prNumber,
        '--body', commentBody
      ]);

      return result.exitCode == 0;
    } catch (e) {
      print('Exception linking issues: $e');
      return false;
    }
  }

  // Helper methods
  String? _extractPrNumber(String output) {
    // Example regex to extract PR number - needs to be adjusted based on actual output
    final regex = RegExp(r'#(\d+)');
    final match = regex.firstMatch(output);
    return match?.group(1);
  }

  String? _extractPrUrl(String output) {
    // Example regex to extract URL - needs to be adjusted based on actual output
    final regex = RegExp(r'(https://github\.com/[^\s]+)');
    final match = regex.firstMatch(output);
    return match?.group(1);
  }
} 
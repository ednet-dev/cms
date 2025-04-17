import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../../domain/service/github_service.dart';

/// Command to create a pull request
class PrCreateCommand extends Command {
  @override
  final String name = 'create';

  @override
  final String description = 'Create a pull request';

  PrCreateCommand() {
    argParser
      ..addOption(
        'title',
        abbr: 't',
        help: 'Title of the pull request',
      )
      ..addOption(
        'body',
        abbr: 'b',
        help: 'Body content of the pull request',
      )
      ..addOption(
        'base',
        defaultsTo: 'main',
        help: 'Base branch (target for merging)',
      )
      ..addOption(
        'head',
        help: 'Head branch (containing your changes)',
      )
      ..addMultiOption(
        'labels',
        abbr: 'l',
        help: 'Labels to apply to the PR',
        splitCommas: true,
      )
      ..addOption(
        'milestone',
        abbr: 'm',
        help: 'Milestone to associate with the PR',
      )
      ..addMultiOption(
        'issues',
        abbr: 'i',
        help: 'Issues to link with this PR',
        splitCommas: true,
      );
  }

  @override
  Future<void> run() async {
    // Get repository information
    final repoInfo = await _getRepositoryInfo();
    if (repoInfo == null) {
      print('Failed to get repository information');
      return;
    }

    final owner = repoInfo['owner']!;
    final repo = repoInfo['repo']!;

    // Create GitHub service
    final github = GitHubService(owner: owner, repo: repo);

    // Get arguments
    final args = argResults!;
    
    // Get current branch if head not specified
    String? headBranch = args['head'] as String?;
    if (headBranch == null) {
      headBranch = await _getCurrentBranch();
      if (headBranch == null) {
        print('Failed to determine current branch');
        return;
      }
    }

    // Get title from args or prompt
    String? title = args['title'] as String?;
    if (title == null || title.isEmpty) {
      title = await _promptForInput('Enter PR title: ');
      if (title == null || title.isEmpty) {
        print('PR title is required');
        return;
      }
    }

    // Get body from args or prompt
    String? body = args['body'] as String?;
    if (body == null || body.isEmpty) {
      body = await _promptForInput('Enter PR description (press Enter twice to finish):\n');
      if (body == null) {
        body = '';
      }
    }

    // Get labels and milestone
    final labels = args['labels'] as List<String>;
    final milestone = args['milestone'] as String?;
    
    // Get base branch
    final baseBranch = args['base'] as String;

    // Create the PR
    print('Creating PR from $headBranch to $baseBranch...');
    final pr = await github.createPullRequest(
      title: title,
      body: body,
      baseBranch: baseBranch,
      headBranch: headBranch,
      labels: labels,
      milestone: milestone,
    );

    if (pr == null) {
      print('Failed to create PR');
      return;
    }

    print('Successfully created PR: ${pr.webUrl}');

    // Link issues if specified
    final issues = args['issues'] as List<String>;
    if (issues.isNotEmpty) {
      print('Linking issues: ${issues.join(', ')}');
      final success = await github.linkIssues(pr.id.toString(), issues);
      if (success) {
        print('Successfully linked issues');
      } else {
        print('Failed to link issues');
      }
    }
  }

  /// Get the current Git repository owner and name
  Future<Map<String, String>?> _getRepositoryInfo() async {
    try {
      final result = await Process.run('git', ['remote', 'get-url', 'origin']);
      if (result.exitCode != 0) return null;

      final url = result.stdout.toString().trim();
      
      // Extract owner/repo from URL formats:
      // https://github.com/owner/repo.git or git@github.com:owner/repo.git
      final RegExp httpsRegex = RegExp(r'https://github\.com/([^/]+)/([^/.]+)');
      final RegExp sshRegex = RegExp(r'git@github\.com:([^/]+)/([^/.]+)');

      Match? match = httpsRegex.firstMatch(url);
      match ??= sshRegex.firstMatch(url);

      if (match == null) return null;

      return {
        'owner': match.group(1)!,
        'repo': match.group(2)!,
      };
    } catch (e) {
      print('Error getting repository info: $e');
      return null;
    }
  }

  /// Get the current branch name
  Future<String?> _getCurrentBranch() async {
    try {
      final result = await Process.run('git', ['branch', '--show-current']);
      if (result.exitCode != 0) return null;
      return result.stdout.toString().trim();
    } catch (e) {
      print('Error getting current branch: $e');
      return null;
    }
  }

  /// Prompt the user for input
  Future<String?> _promptForInput(String prompt) async {
    stdout.write(prompt);
    return stdin.readLineSync();
  }
} 
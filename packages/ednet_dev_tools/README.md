# EDNet Dev Tools

A domain-driven utility for enhancing the EDNet development workflow, built with `ednet_core` modeling capabilities.

## Vision

EDNet Dev Tools provides a seamless integration between your development workflow and project management tools, specifically GitHub Projects, Issues, and PRs.

## Features

### GitHub Integration

- Create PRs with proper semantic commit grouping
- Link PRs to relevant issues and projects
- Update issue statuses automatically
- Query project milestones and issues
- Generate release notes based on semantic commits

### Workflow Enhancement

- Domain-driven commands that understand EDNet architecture
- Automated validation of dependencies and versioning
- Integration with Melos workflow
- Support for TDD workflow tracking

## Architecture

EDNet Dev Tools uses `ednet_core` to model the development workflow as a domain:

- **Entities**: PR, Issue, Milestone, Project, Release
- **Value Objects**: Commit, Branch, Semantic Version
- **Aggregates**: DevWorkflow, ReleaseProcess
- **Services**: GitHubConnector, ValidationService
- **Events**: PRCreated, IssueUpdated, ReleasePublished

## Installation

```bash
dart pub global activate ednet_dev_tools
```

## Usage

```bash
# Create a PR with current changes
ednet pr create

# Link to issues and update status
ednet pr link --issues 123,456 --status "In Review"

# Query available milestones for a project
ednet milestone list

# Create a release based on semantic commits
ednet release prepare
```

## Development

This package is part of the EDNet ecosystem and follows the same development practices:

- Domain-driven design
- Test-driven development
- Semantic versioning
- Conventional commits 
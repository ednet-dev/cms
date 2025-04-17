# Creating a PR with EDNet Dev Tools

## Basic Usage

```bash
# Create a PR with interactive prompts
ednet pr create

# Create a PR with command line arguments
ednet pr create --title "Feature: New Visualization Component" \
  --body "This PR adds a new visualization component for domain models." \
  --base main \
  --head feature/new-visualization \
  --labels enhancement,ui \
  --milestone "v1.2.0" \
  --issues 123,456
```

## Integration with Semantic Commits

The tool automatically groups semantic commits when creating PR descriptions:

```bash
# Generate PR description from semantic commits
ednet pr create --generate-from-commits

# This will produce a PR description like:
# 
# ## Features
# - feat(core-flutter): enhance canvas visualization and filtering components
# 
# ## Refactoring
# - refactor(core): enhance constraint validation system
# - refactor(core-flutter): improve domain session and shell app integration
# - refactor(core-flutter): remove deprecated entity factory
# 
# ## Documentation
# - docs: update development notes and project documentation
# 
# ## Dependencies
# - chore(deps): update dependencies across packages
```

## Querying Milestones and Issues

```bash
# List available milestones
ednet milestone list

# List open issues
ednet issue list

# List issues in current milestone
ednet issue list --milestone current
```

## Moving Issues Between Project States

```bash
# Move an issue to In Progress state
ednet issue move 123 --to "In Progress"

# Move multiple issues to Review state
ednet issue move 123,456 --to "Review"
``` 
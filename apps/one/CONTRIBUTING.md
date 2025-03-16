# Contributing to EDNet One

**EDNet One** is part of the **EDNet CMS** monorepo, which hosts multiple packages and apps such as **ednet_core**, **ednet_cms**, **ednet_code_generation**, and **ednet_one**. This guide focuses on contributing specifically to the EDNet One application while referencing our broader monorepo practices.

---

## Table of Contents

- [Overview](#overview)
- [Preparing Your Environment](#preparing-your-environment)
- [How to Contribute](#how-to-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Enhancements](#suggesting-enhancements)
    - [Fixing Bugs](#fixing-bugs)
    - [Adding Features](#adding-features)
    - [Improving Documentation](#improving-documentation)
    - [Writing Tests](#writing-tests)
    - [Code Review](#code-review)
- [Workflow with the Monorepo](#workflow-with-the-monorepo)
    - [Cloning and Bootstrapping](#cloning-and-bootstrapping)
    - [Creating a Branch](#creating-a-branch)
    - [Making Your Changes](#making-your-changes)
    - [Commit Messages](#commit-messages)
    - [Opening a Pull Request](#opening-a-pull-request)
- [Design Decisions and Guidelines](#design-decisions-and-guidelines)
- [Contact](#contact)

---

## Overview

Thank you for your interest in **EDNet One**—the domain model explorer and UI built on top of [`ednet_core`](https://github.com/ednet-dev/cms/tree/main/packages/core). This doc guides you on how to:

- Follow our **monorepo** structure and processes.
- Contribute to EDNet One’s code, documentation, and tests.
- Collaborate effectively with other EDNet projects.

For a broader understanding of how the entire monorepo is organized, see the top-level [**Contributing to EDNet CMS**](../CONTRIBUTING.md) guide.

---

## Preparing Your Environment

1. **Install Flutter & Dart**: Ensure you have a recent stable version.
2. **Install Melos**: The monorepo uses [Melos](https://melos.invertase.dev) for dependency management and scripts.
   ```bash
   dart pub global activate melos
   ```
3. **Fork & Clone**: Fork the [EDNet dev monorepo](https://github.com/ednet-dev/cms) and then clone it locally.
   ```bash
   git clone https://github.com/<YOUR_USERNAME>/cms.git
   cd cms
   ```
4. **Bootstrap**: Pull down all dependencies across packages.
   ```bash
   melos bootstrap
   ```
5. **Navigate to EDNet One**:
   ```bash
   cd apps/one
   flutter run
   ```

---

## How to Contribute

### Reporting Bugs

- **Search Existing Issues**: Check if an issue describing your bug already exists.
- **Create a New Issue**: If not found, file a new issue. Include:
    - Steps to reproduce
    - Expected vs. actual behavior
    - Screenshots or error logs
    - Flutter & environment details
- Link relevant error messages or logs.

### Suggesting Enhancements

- **Check for Ideas**: Scan existing issues or discussions for similar suggestions.
- **Propose a New Feature**: Provide context on its value, who benefits, and how it integrates with EDNet One’s domain approach.

### Fixing Bugs

- **Assign Yourself**: Comment on the issue to signal you’re working on it.
- **Fork & Branch**: Follow the instructions in the [Workflow with the Monorepo](#workflow-with-the-monorepo) section.
- **Test Thoroughly**: Confirm your fix addresses the bug across all relevant use cases.
- **Open a PR**: Provide details in the description.

### Adding Features

- **Discuss First**: Complex features might need discussion with maintainers.
- **Domain-Driven Focus**: Keep the domain model approach consistent, referencing `ednet_core` patterns.
- **Write or Update Tests**: For new code, ensure coverage.

### Improving Documentation

- **Docs Are Code**: Our docs live in `.md` files or code comments.
- **Correct Typos, Clarify**: Even small improvements help.
- **Screenshots & Samples**: When helpful, add them.

### Writing Tests

- **Coverage**: We appreciate test coverage for any new or changed logic.
- **Unit Tests**: For domain logic, UI components, or model generation workflows.
- **Integration Tests**: (If relevant) e.g., verifying app flows in EDNet One.

### Code Review

- **Review Others**: If you see an open PR, feel free to review and add comments.
- **Be Constructive**: Provide clear, actionable feedback.

---

## Workflow with the Monorepo

### Cloning and Bootstrapping

1. **Fork** the repo on GitHub.
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/cms.git
   cd cms
   melos bootstrap
   ```

### Creating a Branch

In the `cms` folder:
```bash
git checkout -b feature/ednet-one-awesome
```
(Alternatively, `bugfix/ednet-one-issueXYZ`.)

### Making Your Changes

- **CD into `apps/one/`**: This is the EDNet One Flutter app.
- **Implement** your bug fix or feature.
- **Test Locally**:
  ```bash
  melos run test:flutter
  ```
- **Run the App**:
  ```bash
  flutter run
  ```
- **Check Lints**:
  ```bash
  melos run analyze
  ```

### Commit Messages

We use **[Conventional Commits](https://www.conventionalcommits.org/)** to keep a clean commit history:

- **feat(one):** for adding a new feature in EDNet One.
- **fix(one):** for bug fixes.
- **docs:** for documentation.
- **chore:** for tooling, build scripts, etc.
- **refactor:** for code changes that aren’t bug fixes or new features.

Example:
```bash
git commit -m "feat(one): add domain model visualization toggle"
```

### Opening a Pull Request

1. **Push** your branch:
   ```bash
   git push origin feature/ednet-one-awesome
   ```
2. **Open PR** on the original `ednet-dev/cms` repository.
3. **Describe** your changes thoroughly.
4. **Link Issues**: If you’re fixing a known issue, reference it in the PR body.
5. **Respond to Feedback**: Maintainers may request changes.

---

## Design Decisions and Guidelines

- **Domain-Driven Design (DDD)**: EDNet One leverages DDD from `ednet_core`.
- **Flutter’s Reactive UI**: We use Flutter for cross-platform consistency.
- **`ednet_core` Integration**: Focus on robust domain model definitions.
- **Graph-based Rendering**: We rely on `graphview` or similar to show domain relationships.
- **Monorepo Cohesion**: Adhere to shared patterns, code style, and versioning.

---

## Contact

For any questions:

- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)
- **GitHub Discussions**: [https://github.com/ednet-dev/cms/discussions](https://github.com/ednet-dev/cms/discussions)
- **Discord**: [EDNet Dev Community](https://discord.gg/7E7bPjNMG3)

Thank you for contributing to **EDNet One** and the broader **EDNet CMS** ecosystem! Your efforts help improve domain-driven development for everyone.


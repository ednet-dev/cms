# Contributing to EDNet CMS

Thank you for your interest in contributing to **EDNet CMS**! 🚀  
This document outlines the contribution process to ensure **efficiency**, **clarity**, and **scalability** for **new** and **experienced** contributors.

---

## 📌 Table of Contents

- [🛠️ Setup & Development Workflow](#setup--development-workflow)
- [💡 How to Contribute](#how-to-contribute)
    - [🐛 Reporting Issues](#reporting-issues)
    - [📌 Picking Up an Issue](#picking-up-an-issue)
    - [📂 Creating a New Feature](#creating-a-new-feature)
- [👨‍💻 Coding Guidelines](#coding-guidelines)
    - [💾 Repository Structure](#repository-structure)
    - [📝 Commit Guidelines](#commit-guidelines)
    - [📖 Documentation Contributions](#documentation-contributions)
- [📦 Dependency & Package Management](#dependency--package-management)
- [📢 Pull Request Process](#pull-request-process)
- [🔄 Continuous Integration (CI/CD)](#continuous-integration-cicd)
- [🤝 Community Guidelines](#community-guidelines)
- [📞 Contact & Support](#contact--support)

---

## 🛠️ Setup & Development Workflow

### 1️⃣ **Clone the repository**
```bash
git clone https://github.com/ednet-dev/cms.git
cd cms
melos bootstrap
```

### 2️⃣ **Use Melos for package management**
- Install dependencies:
  ```bash
  melos bootstrap
  ```
- Run the project:
  ```bash
  flutter run
  ```

---

## 💡 How to Contribute

There are multiple ways you can contribute to EDNet CMS:

### 🐛 Reporting Issues

1. **Check for existing issues**  
   Before submitting a new issue, check if it’s already reported in the **GitHub Issues**:
    - [@ednet_one Issues](https://github.com/orgs/ednet-dev/projects/5/views/1)
    - [@ednet_cms Issues](https://github.com/orgs/ednet-dev/projects/7/views/1)
    - [@ednet_core Issues](https://github.com/orgs/ednet-dev/projects/6/views/1)

2. **Create a new issue**  
   If no existing issue covers your concern:
    - Use the **Bug Report** or **Feature Request** templates in the issues tab.
    - Provide **clear steps** to reproduce the issue (if a bug).
    - Add relevant **screenshots, logs, or stack traces**.

### 📌 Picking Up an Issue

1. **Go to the project boards**:
    - [@ednet_one Project Board](https://github.com/orgs/ednet-dev/projects/5/views/1)
    - [@ednet_cms Project Board](https://github.com/orgs/ednet-dev/projects/7/views/1)
    - [@ednet_core Project Board](https://github.com/orgs/ednet-dev/projects/6/views/1)

2. **Comment on the issue** to let others know you're working on it.

3. **Fork the repository**, create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Work on the feature**, then push and open a PR.

### 📂 Creating a New Feature

- Follow the **Domain-Driven Design (DDD)** structure.
- Use **Event Storming** methodology for complex features.
- Ensure code is **fully tested** and aligns with **our coding guidelines**.

---

## 👨‍💻 Coding Guidelines

### 💾 Repository Structure

The monorepo is structured as follows:

```
cms/
│── packages/
│   ├── core/              # EDNet Core package
│   ├── cms/               # EDNet CMS package
│   ├── code_generation/   # Codegen utilities
│── apps/
│   ├── one/               # EDNet One application
│── tools/
│── rfcs/                  # Request for Comments (RFC) documents
│── .github/               # GitHub workflows and templates
│── melos.yaml             # Monorepo package manager
│── codemagic.yaml         # CI/CD pipeline configuration
│── CONTRIBUTING.md        # This document
```

### 📝 Commit Guidelines

We follow **Conventional Commits** to automate changelog generation.

```
<type>(<optional scope>): <short description>

<longer description if needed>

<footer if needed, e.g. BREAKING CHANGE: ... or close #issue>
```

#### Common Types
- **feat**: A new feature (`feat(cms): add new user role`)
- **fix**: A bug fix (`fix(core): handle null checks on domain model`)
- **docs**: Documentation updates (`docs(repo): update root monorepo readme`)
- **chore**: Changes to tooling, CI/CD, or dependencies (`chore(ci): update github action`)

#### Breaking Changes
```
refactor!(cms): remove deprecated method

BREAKING CHANGE: The old method has been removed. Use `newMethod()` instead.
```

---

## 📦 Dependency & Package Management

We use [Melos](https://melos.invertase.dev/) to manage multiple Dart & Flutter packages.

Common commands:
```bash
melos bootstrap      # Install dependencies
melos run analyze    # Run static analysis
melos run format     # Format code
melos run test:flutter  # Run Flutter tests
```

To publish a package:
```bash
melos publish --scope="cms" --no-dry-run
```

---

## 📢 Pull Request Process

### ✅ Before Opening a PR:
- Ensure your changes are **self-contained**.
- Check if tests are passing using:
  ```bash
  melos run test:flutter
  ```
- Ensure **formatting & linting**:
  ```bash
  melos run format
  melos run analyze
  ```

### 🚀 Opening a PR
1. Push your changes:
   ```bash
   git push origin feature/your-feature-name
   ```
2. Open a Pull Request (PR) in GitHub.
3. Assign reviewers and wait for feedback.

---

## 🔄 Continuous Integration (CI/CD)

### ✅ GitHub Actions
- GitHub Actions automatically publishes packages to **pub.dev** when a version tag (`v1.2.3`) is pushed.

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+*'
jobs:
  cms:
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    with:
      working-directory: packages/cms
```

### 🛠️ CodeMagic (CI - currently broken)
- `codemagic.yaml` handles **testing & publishing**, but needs **fixing**.
- To debug, check:
  ```
  cat $XDG_CONFIG_HOME/dart/pub-credentials.json
  ```
- Future work: **Fix pipeline & automate testing/deployment**.

---

## 🤝 Community Guidelines

Be respectful, open-minded, and collaborative. Follow these principles:

✅ **Code of Conduct**  
✅ **Review feedback constructively**  
✅ **Be welcoming to new contributors**  
✅ **Tag relevant team members for discussions**

---

## 📞 Contact & Support

For questions, reach out on:

- **Discord**: [Join Here](https://discord.gg/7E7bPjNMG3)
- **GitHub Discussions**: [Ask Here](https://github.com/ednet-dev/cms/discussions)
- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)

---

## 🚀 Welcome Aboard!

We appreciate your interest in **EDNet CMS**!  
Happy coding! 🚀🎉
# EDNet Core

**Version:** 1.0.0

## Overview

EDNet Core is a meta framework for rapid definition of domain models, built on top of Domain-Driven
Design (DDD) and EventStorming methodologies. It encapsulates reusable parts of semantic
implementation for generic repositories and UI default renderings, aiming to democratize the no-code
approach to software development.

## Key Features

- **Domain-Driven Design (DDD)**
- **EventStorming Methodologies**
- **Rapid Domain Model Definition**
- **Reusable Implementation**
- **UI Default Renderings**
- **Cross-Platform Deployment**

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up the Environment](#setting-up-the-environment)
3. [Defining Domain Models](#defining-domain-models)
4. [Creating a Core Repository](#creating-a-core-repository)
5. [Creating Models](#creating-models)
6. [Defining Entities](#defining-entities)
7. [Initializing Data](#initializing-data)
8. [Generating Code](#generating-code)
9. [Writing Tests](#writing-tests)
10. [Example Projects](#example-projects)
11. [Best Practices](#best-practices)
12. [Contribution](#contribution)

## Prerequisites

Ensure you have the following installed:

- Dart SDK
- Flutter SDK (if working on a Flutter project)
- An IDE or text editor (e.g., VS Code, IntelliJ IDEA)

## Setting Up the Environment

1. **Install Dart and Flutter**: Follow the official [Dart](https://dart.dev/get-dart)
   and [Flutter](https://flutter.dev/docs/get-started/install) installation guides.
2. **Create a new Dart/Flutter project**:
    ```bash
    dart create my_project
    # or for Flutter
    flutter create my_project
    ```
3. **Add ednet_core to your project**:
    ```yaml
    dependencies:
      ednet_core: latest_version
    ```
4. **Install dependencies**:
    ```bash
    dart pub get
    # or for Flutter
    flutter pub get
    ```

## Defining Domain Models

1. **Create domain model files**: Create a file for your domain model,
   e.g., `household_domain.dart`.
2. **Define domain and model structure**:
    ```dart
    import 'package:ednet_core/ednet_core.dart';

    class HouseholdDomain extends Domain {
      HouseholdDomain(String name) : super(name);
    }

    class ProjectModel extends ModelEntries {
      Projects projects;

      ProjectModel(Domain domain) : super(domain, "Project") {
        projects = Projects(this);
        addEntry("Project", projects);
      }
    }
    ```

## Creating a Core Repository

1. **Create a repository**:
    ```dart
    var repository = CoreRepository();
    ```
2. **Register the domain and models with the repository**:
    ```dart
    var householdDomain = HouseholdDomain("Household");
    repository.addDomain(householdDomain);

    var projectModel = ProjectModel(householdDomain);
    householdDomain.addModelEntries(projectModel);
    ```

## Creating Models

1. **Create a model**:
    ```dart
    ProjectModel projectModel = ProjectModel(householdDomain);
    householdDomain.addModelEntries(projectModel);
    ```

## Defining Entities

1. **Define an entity** within your model:
    ```dart
    class Project extends Entity {
      String name;

      Project(Concept concept) : super(concept);

      @override
      String toString() => 'Project: $name';
    }

    class Projects extends Entities<Project> {
      Projects(ModelEntries modelEntries) : super(modelEntries);
    }

    class ProjectModel extends ModelEntries {
      Projects projects;

      ProjectModel(Domain domain) : super(domain, "Project") {
        projects = Projects(this);
        addEntry("Project", projects);
      }
    }
    ```

## Initializing Data

1. **Initialize data**:
    ```dart
    void initData(CoreRepository repository) {
       var householdDomain = repository.getDomainModels("Household");
       ProjectModel? projectModel = householdDomain?.getModelEntries("Project") as ProjectModel?;
       projectModel?.init();
    }
    ```

## Generating Code

1. **Generate code**:
    ```dart
    void genCode(CoreRepository repository) {
      repository.gen("household_project");
    }
    ```

## Writing Tests

1. **Write tests**:
    ```dart
    void testHouseholdProjectProjects(HouseholdDomain householdDomain, ProjectModel projectModel, Projects projects) {
      DomainSession session;
      group("Testing Household.Project.Project", () {
        session = householdDomain.newSession();
        setUp(() { projectModel.init(); });
        tearDown(() { projectModel.clear(); });

        test("Not empty model", () {
          expect(projectModel.isEmpty, isFalse);
          expect(projects.isEmpty, isFalse);
        });

        // Other tests...
      });
    }
    ```


# Alternatives

## EDNetDSL

is used to describe any domain model.
EDNetCMS interprets it on various platforms using appropriate default model interpreters,
by only manipulating a YAML file of user stories high-level concepts and their basic relationships,
as not more complex as a basic ER diagram, we can generate an entire well-structured, evolveable MVP
of domain model in
discussion and deploy it on the platform of our choosing.

```yaml
concepts:
  - name: User
    entry: true
    attributes:
      - sequence: 1
        name: username

      - sequence: 2
        name: password
        sensitive: true

      - sequence: 3
        name: email

      - sequence: 4
        name: name

  - name: Address
    attributes:
      - sequence: 1
        name: zip

      - sequence: 2
        name: city

      - sequence: 3
        name: street

      - sequence: 4
        name: number

  - name: Country
    attributes:
      - sequence: 1
        name: name

      - sequence: 2
        name: iso

relations:
  - from: Address
    fromToName: country
    to: Country
    toFromName: addresses
    id:
      from: false
      to: false
    fromToCardinality:
      min: 1
      max: 1
    toFromCardinality:
      min: 0
      max: N
    category: relationship
    internal: false

  - from: User
    fromToName: company
    to: Company
    toFromName: employees
    id:
      from: true
      to: false
    fromToCardinality:
      min: 1
      max: 1

    toFromCardinality:
      min: 0
      max: N
    category: relationship
    internal: false
```
### ednet_code_generation

### EDNetCMS

1. Create your e.g. flutter app with `flutter create my_app`
2. Add `ednet_cms` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     ednet_cms: latest_version
   ```
3. Put your DSL yaml files in `lib/requriements` folder like e.g:
   ```bash
   lib/requirements/
   ├── user_management
   │   ├── user.ednet.yaml
   │   └── role.ednet.yaml
   ├── voting
   │   ├── vote.ednet.yaml
   │   └── ballot.ednet.yaml
   ├── legislation_proposal
   │   ├── proposal.ednet.yaml
   │   └── amendment.ednet.yaml
   └── discussion_forum
       ├── thread.ednet.yaml
       └── comment.ednet.yaml
   ```
4. Run `dart run build_runner watch --delete-conflicting-outputs` to generate the code.
5. 
## Best Practices

1. **Modularize your code**: Keep your domains, models, and entities well-organized and align
   boundaries against business language.
2. **Write comprehensive tests**: Ensure all critical paths are tested.
3. **Follow Dart and Flutter best practices**: Adhere to recommended coding standards and
   conventions.

## Contribution

Start your collaboration by participating in our [RFC](https://github.com/ednet-dev/cms/pull/6).

## Conclusion

EDNetCore aims to democratize the no-code approach to software development by focusing on domain
models. With the combination of DDD and EventStorming methodologies, it offers a powerful framework
for rapid domain model definition and reusable implementation.

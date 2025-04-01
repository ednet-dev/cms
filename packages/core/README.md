# EDNet Core
**Version:** 0.1.0

## Overview

EDNet Core is the foundational Dart library for defining, managing, and evolving rich domain models using the principles of Domain-Driven Design (DDD) and EventStorming. It aims to simplify how domain models are captured, reasoned about, and integrated into the broader software ecosystem. By abstracting away boilerplate and offering a consistent pattern for modeling complex domains, EDNet Core accelerates development and fosters a more collaborative no-code/low-code environment.

In essence, EDNet Core focuses on the "semantic backbone" of your application—your domain. It helps you describe your concepts, attributes, relationships, invariants, and domain events in a structured, platform-agnostic manner. EDNet Core then serves as a stable foundation for code generation, repository abstractions, UI scaffolds, and integrations with higher-level tools or platforms like EDNet CMS, EDNet DSL, and other EDNet ecosystem offerings.

## Enhanced Query Capabilities

EDNet Core now includes a powerful expression-based query system that enables complex, type-safe querying of domain entities.

### Query Expression System

The expression system allows for composable, type-safe query expressions:

```dart
// Create a simple attribute expression
final priceExpression = AttributeExpression('price', ComparisonOperator.lessThan, 100);

// Create a logical AND expression
final categoryExpression = AttributeExpression('category', ComparisonOperator.equals, 'electronics');
final combinedExpression = priceExpression.and(categoryExpression);

// Create a relationship expression
final assignedToJohnExpression = RelationshipExpression(
  'assignedUser',
  RelationshipType.parent,
  AttributeExpression('name', ComparisonOperator.contains, 'John')
);
```

### Fluent Query Builder

A fluent query builder is available for constructing complex queries in a readable way:

```dart
final query = QueryBuilder.forConcept(productConcept, 'FindProducts')
  .where('price').lessThan(100)
  .and('name').contains('laptop')
  .andWhere('category', RelationshipType.parent)
    .where('name').equals('electronics')
  .orderBy('price')
  .paginate(1, 20)
  .build();
```

### Key Features

The enhanced query system provides:

- **Composable Expressions**: Combine attribute filters, relationship traversals, and logical operations
- **Type Safety**: Validate queries against concept metadata
- **Relationship Traversal**: Query across parent and child relationships
- **Advanced Filtering**: Support for a wide range of operators and functions
- **Pagination and Sorting**: Built-in pagination and sorting capabilities

### Expression Types

The system includes various expression types:

- **AttributeExpression**: Filter by attribute values
- **LogicalExpression**: Combine expressions with AND/OR
- **RelationshipExpression**: Filter based on related entities
- **NotExpression**: Negate an expression
- **FunctionExpression**: Apply functions to attributes
- **ConstantExpression**: Use fixed boolean values

### Integration with Drift

The query system is fully integrated with the Drift database package:

```dart
final adapter = DriftExpressionQueryAdapter(driftDatabase);
final result = await adapter.executeExpressionQuery(expressionQuery);
```

## Example Usage

Here's a real-world example of using the query system in a product catalog application:

```dart
Future<EntityQueryResult<Entity<dynamic>>> searchProducts({
  String? searchTerm,
  String? category,
  double? minPrice,
  double? maxPrice,
  bool? inStock,
  int page = 1,
  int pageSize = 20,
}) async {
  final queryBuilder = QueryBuilder.forConcept(_productConcept, 'SearchProducts');
  
  if (searchTerm != null && searchTerm.isNotEmpty) {
    queryBuilder.where('name').contains(searchTerm)
      .or('description').contains(searchTerm);
  }
  
  if (category != null && category.isNotEmpty) {
    queryBuilder.andWhere('category', RelationshipType.parent)
      .where('name').equals(category);
  }
  
  if (minPrice != null) {
    queryBuilder.and('price').greaterThanOrEqual(minPrice);
  }
  
  if (maxPrice != null) {
    queryBuilder.and('price').lessThanOrEqual(maxPrice);
  }
  
  if (inStock != null) {
    queryBuilder.and('stockQuantity').greaterThan(0);
  }
  
  final query = queryBuilder.orderBy('name')
    .paginate(page, pageSize)
    .build();
  
  return await _dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(query);
}
```

## Key Tenets
EDNet Core elevates the role of domain models in software development. By combining DDD and EventStorming techniques with a meta-level approach, EDNet Core fosters quick iteration, richer semantics, and a smoother path from abstract concepts to fully functional applications. As part of the broader EDNet ecosystem, it lays the groundwork for more expressive, maintainable, and democratized software design.

- **Domain-Driven Modeling**: Directly model your business concepts (Entities, Value Objects, Aggregates), ensuring the code reflects the ubiquitous language and rich semantics.
- **EventStorming Alignment**: Incorporate EventStorming-inspired workflows, tying domain events, processes, and invariants into a coherent, analyzable structure.
- **Meta-Framework**: EDNet Core acts as a meta-layer, allowing higher-level frameworks (like EDNet CMS or EDNet Code Generation) to read, interpret, and transform your models without hand-crafted adapters.
- **No-Code / Low-Code Integration**: By defining domain models in a structured YAML or DSL format, non-technical stakeholders can collaborate and iterate on the domain without diving into code internals.
- **Extensible & Reusable**: Leverage standard patterns and baseline implementations (like repository interfaces, event handlers, and validation hooks) without reinventing the wheel.
- **Cross-Platform Friendly**: EDNet Core is pure Dart, making it suitable for Flutter, server-side, CLI tools, code generation pipelines, and beyond.

## Table of Contents

- [EDNet Core](#ednet-core)
  - [Overview](#overview)
  - [Enhanced Query Capabilities](#enhanced-query-capabilities)
    - [Query Expression System](#query-expression-system)
    - [Fluent Query Builder](#fluent-query-builder)
    - [Key Features](#key-features)
    - [Expression Types](#expression-types)
    - [Integration with Drift](#integration-with-drift)
  - [Example Usage](#example-usage)
  - [Key Tenets](#key-tenets)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Installation \& Setup](#installation--setup)
  - [Defining a Domain](#defining-a-domain)
  - [Adding Models and Entities](#adding-models-and-entities)
  - [Relationships \& Constraints](#relationships--constraints)
  - [Initialization \& Data Seeding](#initialization--data-seeding)
  - [Code Generation with ednet\_code\_generation](#code-generation-with-ednet_code_generation)
  - [Integration Points](#integration-points)
  - [Testing \& Validation](#testing--validation)
  - [Best Practices](#best-practices)
  - [Resources \& Community](#resources--community)
  - [Contributing](#contributing)
  - [Contact](#contact)

## Prerequisites

- **Dart SDK**: Ensure you have the [Dart SDK](https://dart.dev/get-dart) installed.
- **Optional Flutter Setup**: If integrating with Flutter-based UIs, have [Flutter](https://flutter.dev/docs/get-started/install) set up.
- **Familiarity with DDD Concepts**: Basic understanding of Entities, Value Objects, Aggregates, and Repositories is helpful.

## Installation & Setup

Add `ednet_core` to your project's `pubspec.yaml`:

```yaml
dependencies:
  ednet_core: ^0.1.0
```

Then run:

```bash
dart pub get
# or if using Flutter
flutter pub get
```

## Defining a Domain

A domain in EDNet Core encapsulates a conceptual boundary of your business logic:

```dart
import 'package:ednet_core/ednet_core.dart';

class MyDomain extends Domain {
  MyDomain(String name) : super(name);
}
```

Domains contain one or more models (e.g., "Project", "User", "Proposal"), each capturing a part of the domain's complexity.

## Adding Models and Entities

Models are collections of concepts (Entities, Value Objects, Attributes, Relations):

```dart
class ProjectModel extends ModelEntries {
  late Projects projects;

  ProjectModel(Domain domain) : super(domain, "Project") {
    projects = Projects(this);
    addEntry("Project", projects);
  }
}

class Project extends Entity {
  String name = "";

  Project(Concept concept) : super(concept);

  @override
  String toString() => 'Project: $name';
}

class Projects extends Entities<Project> {
  Projects(ModelEntries modelEntries) : super(modelEntries);
}
```

Add the model to the domain and register it in a repository:

```dart
var domain = MyDomain("Business");
var projectModel = ProjectModel(domain);
domain.addModelEntries(projectModel);

var repository = CoreRepository();
repository.addDomain(domain);
```

## Relationships & Constraints

EDNet Core supports relationships (one-to-one, one-to-many, many-to-many) and invariants. Model these as needed:

```yaml
concepts:
  - name: User
    attributes:
      - name: username
      - name: email

  - name: Project
    attributes:
      - name: name

relations:
  - from: Project
    fromToName: owner
    to: User
    toFromName: ownedProjects
    fromToCardinality:
      min: 1
      max: 1
    toFromCardinality:
      min: 0
      max: N
```

This YAML-driven definition could then be transformed by EDNet Core into typed Entities and robust relations in code.

## Initialization & Data Seeding

Initialize or seed data after model creation:

```dart
projectModel.init(); // may populate default entries
```

## Code Generation with ednet\_code\_generation

When integrated with ednet\_code\_generation, you can:

- Take your domain definitions (in Dart or YAML DSL).
- Run code generation steps to produce boilerplate, typed repositories, and event handling code.
- Export DSL, regenerate code, and keep your domain models in sync with evolving business needs.

```bash
dart run build_runner build
```

The generated code provides a stable foundation for further expansions, validations, and integration with UI layers.

## Integration Points

- **EDNet CMS**: Combine with EDNet CMS to interpret domain models into dynamic web interfaces, collaborative modeling tools, and governance workflows.
- **EDNet DSL**: Define domain models in a high-level YAML DSL and have EDNet Core generate the underlying code. Non-technical users can adjust the DSL, enabling a no-code or low-code approach.
- **Custom Repositories and Services**: EDNet Core doesn't lock you in; integrate your domain model with REST APIs, GraphQL endpoints, microservices, and other data layers as needed.

## Testing & Validation

Leverage EDNet Core's consistent structure to write comprehensive tests:

```dart
test('Should have initial projects', () {
  expect(projectModel.isEmpty, isFalse);
  expect(projectModel.projects.isEmpty, isFalse);
});
```

The stable structure makes it straightforward to test invariants, relationships, and domain logic.

## Best Practices

1. **Keep Domain Language Clean**: Use descriptive concept and attribute names aligned with real business language.
2. **Modularization**: Split large domains into multiple models for clarity.
3. **Leverage DSLs Early**: Start from simple YAML or code-based definitions and generate complex artifacts. Iterate frequently.
4. **Test Often**: Integrations and invariants should be tested to ensure the domain's logic remains correct as it evolves.

## Resources & Community

- **EDNet Core Repository**: [GitHub - ednet-dev/core](https://github.com/ednet-dev/cms/tree/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/core)
- **EDNet Ecosystem**: Explore EDNet CMS, EDNet Code Generation, and EDNet DSL for a more holistic no-code/low-code pipeline.
- **DDD & EventStorming**: Familiarize yourself with these methodologies to get the most out of EDNet Core.

## Contributing

We welcome contributions, feedback, and discussions. Start by reviewing the Contribution Guidelines. Submit PRs, suggest RFCs, or engage in community discussions to improve and refine EDNet Core.

## Contact

For any questions:

- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)
- **GitHub Discussions**: [https://github.com/ednet-dev/cms/discussions](https://github.com/ednet-dev/cms/discussions)
- **Discord**: [EDNet Dev Community](https://discord.gg/7E7bPjNMG3)

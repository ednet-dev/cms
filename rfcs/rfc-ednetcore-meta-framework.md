# Proposal for Collaboration on `ednet_core`: A Domain Model Meta Framework

## Introduction

This document proposes a collaboration on an open-source project to develop a meta-framework for the rapid definition of domain models, called `ednet_core`. Built on Domain-Driven Design (DDD) and EventStorming methodologies, this framework encapsulates reusable semantic implementations for generic repositories and UI default renderings.

## Motivation

The software development industry is shifting towards highly abstract and conceptual architectural thinking, as evidenced by the rise of no-code platforms. This trend emphasizes the importance of concepts, their contextual roles, and relationships over implementation details like UI or persistence concerns. Consequently, the industry is moving towards a higher level of creative competition, where specialized developers maintain substacks with deep system knowledge.

The analog-to-digital transition is immense, utilizing novel niches with disruptive potential. This project aims to democratize the no-code approach by enabling developers to focus on the Domain Model.

## Framework Description

### ednet DSL

The `ednet` Domain-Specific Language (DSL) is used to describe domain models. The `ednet_cms` tool generates code that interprets this DSL on various platforms using default model interpreters. By manipulating a YAML file of user stories, high-level concepts, and their relationships—akin to a basic ER diagram—we can generate a well-structured, evolvable MVP for a domain model.

Example `ednet` DSL:
```yaml
concepts:
  - name: User
    entry: true
    attributes:
      - name: username
      - name: password
        sensitive: true
      - name: email
      - name: name

  - name: Address
    attributes:
      - name: zip
      - name: city
      - name: street
      - name: number

  - name: Country
    attributes:
      - name: name
      - name: iso

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

### ednet_core

`ednet_core` is an implementation of the `ednet` DSL, providing a meta-framework for rapid domain model definition. It abstracts Domain-Driven Design and EventStorming principles, enabling the encapsulation of reusable implementation parts for generic repositories and basic UX.

`ednet_core` can generate nearly all infrastructural components, offering default Flutter material interpreter apps for multi-platform deployment and React material interpreter apps optimized for web deployment.

Example usage in Dart:
```dart
import 'package:ednet_core/ednet_core.dart';

class Vote extends Entity<Vote> {}
class Votes extends Entities<Vote> {}
class Initiative extends Entity<Initiative> {}
class Citizen extends Entity<Citizen> {}

class VoteForProposalCommand extends IEntitiesCommand {}
class VoteAgainstProposalCommand extends IEntitiesCommand {}
class CommentProposalCommand extends IEntitiesCommand {}

class ProposalCommentedReaction implements ICommandReaction {}

class VotedForProposalEvent extends IEntitiesEvent {}
class VotedAgainstProposalEvent extends IEntitiesEvent {}
```

## Project Ambition

The project encompasses all levels of seniority, addressing the following tasks:

- Transforming legacy Dart 1 code into modern mixins and extensions.
- Tackling large-scale architectural concerns, such as performant peer-to-peer capabilities with universal platform constraints.
- Defining and integrating DDD and EventStorming artifacts like policies, events, aggregate roots, and systems.
- Transpiling to ECMAScript and publishing to npmjs for web development.
- Providing backend use case examples, integrating `ednet_core` with Dart or Node.js, and popular technologies like Remix.
- Creating extensive documentation in the form of C4 diagrams for the existing API and architecture of `ednet_core`.
- Implementing code generation for the DSL to empower stakeholders, such as Product Managers, to participate in software design.
- Utilizing resources like DBPedia for generic interpretation or building a library of highly contextualized specializations of public semantic models.
- Ensuring deployment capabilities support all major cloud providers in a unified way (EaaS).

## Conclusion

The `ednet_core` meta-framework for rapid domain model definition, built on DDD and EventStorming, aims to democratize the no-code approach to software development. By enabling developers to focus on the Domain Model, this open-source initiative has the potential to generate nearly all infrastructural components. With DSL-based code generation, higher stakeholders can take direct responsibility for software design implementation.

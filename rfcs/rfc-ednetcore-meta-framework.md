# Proposal for Collaboration on EDNetCore: A Meta Framework for Rapid Definition of Domain Models
## Introduction:

This document presents a proposal for collaboration on an open-source project to develop a meta framework for rapid definition of domain models called EDNetCore. This framework is built on top of the Domain-Driven Design (DDD) and EventStorming methodologies and enables the encapsulation of reusable parts of semantic implementation for generic repositories and UI default renderings.

## Motivation:

The software development industry is experiencing a shift towards highly abstract and conceptual thinking in architectural terms, as evidenced by the disruptive advance of no-code platforms and solutions. This trend demands a focus on the concepts of solutions, their contextual role, and relationships, rather than the implementation details such as UI or persistence concerns. This shift places pressure on the industry to compete in creativity at a higher level, where the minority of highly specialized developers will act as maintainers of sub-stacks with similar knowledge of systems and subsystems as the modern average developer.

The pressure of the analog-to-digital transition is immense and will utilize every novel niche with disrupting potential and fulfill it. The shortage of endemic highly skilled developers is continuous and omnipresent, and this project aims to democratize the no-code approach by empowering developers to focus on what matters, the Domain Model.

## Framework Description:

EDNetCore is a meta framework for rapid definition of domain models and is an abstraction on top of DDD and EventStorming, implementing their semantic and lingo. It enables the encapsulation of reusable parts of implementation for generic repositories and UI default renderings. In combination with other open-source initiatives, EDNetCore can generate almost everything infrastructural and have default Flutter material interpreter app for multi-platform deployment or default React material interpreter app optimized for web deployment of EDNetCore domain models.
```dart
import 'package:ednet_core/ednet_core.dart';

/// Entities and Value objects
class Vote extends Entity<Vote> {}
class Votes extends Entities<Vote> {}
class Initiative extends Entity<Initiative> {}
class Citizen extends Entity<Citizen> {}
class Proposal extends Entity<Proposal> {}
class Address extends ValueObject<Address> {}
// ...

/// Commands
class VoteForProposalCommand extends IEntitiesCommand {}
class VoteAgainstProposalCommand extends IEntitiesCommand {}
class CommentProposalCommand extends IEntitiesCommand {}
// ... 

/// Side effects as Command reactions  - Events
class ProposalCommentedReaction implements ICommandReaction {}
// ...

/// Events
class VotedForProposalEvent extends IEntitiesEvent {}
class VotedAgainstProposalEvent extends IEntitiesEvent {}
// ...
```

EDNetDsl is used to describe any domain model, and EDNetCMS interprets it on various platforms using appropriate default model interpreters. By only manipulating a YAML file of user stories high-level concepts and their basic relationships, as not more complex as a basic ER diagram, we can generate an entire well-structured, evolveable MVP of domain model in discussion and deploy it on the platform of our choosing.
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
    to: Country
    fromToName: country
    fromToMin: 1
    fromToMax: 1
    toFromName: addresses
    toFromMin: 0
    toFromMax: N
    category: relationship
    internal: false
    fromToId: false
    toFromId: false
    
  - from: User
    to: Company
    fromToName: company
    fromToMin: 1
    fromToMax: 1
    toFromName: employees
    toFromMin: 0
    toFromMax: N
    category: relationship
    internal: false
    fromToId: true
    toFromId: false
  
```

## Project Ambition:

The project's ambition is not small, and there is a job to be done across all levels of seniority. There are amounts of legacy Dart 1 code waiting to be transformed into modern mixins and extensions. Large scale architectural concerns around performant peer-to-peer capabilities with universal platform as a constraint must be addressed. Furthermore, the definition, implementation, and concrete specialization of the rest of DDD and EventStorming artifacts, such as policies and events, aggregate roots, systems, etc., are yet to be integrated.

The implementation of code generation for our DSL will empower higher stakeholders like Product managers to take more direct responsibility for the implementation on the software design level fully. They will understand how we derived our language and serve as active participants in the process.

Working with highly structured graphs like are metamodels of domain models have bound us to utilize resources like DBPedia for generic interpretation or at least building of library of highly contextualized specializations of available public semantic models. Or, in plain language - we can and shall use public knowledge dbs and their ontologies to model all that there is, or to spark a life in our structured knowledge so that we persist our custom interactions of our custom contexts. 

## Conclusion:

The EDNetCore meta framework for rapid definition of domain models, built on top of DDD and EventStorming, aims to democratize the no-code approach to software development by empowering developers to focus on what matters, the Domain Model. This open-source initiative offers the potential to generate almost everything infrastructural, and with the implementation of code generation for our DSL, we will enable higher stakeholders to take more direct responsibility for the implementation of software design.
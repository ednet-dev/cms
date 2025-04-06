# EDNet CMS Roadmap

## Overview

EDNet CMS aims to revolutionize content management in Flutter by creating a comprehensive,
user-centric, and highly extensible system. Our focus is on leveraging principles of human biology,
psychology, and digital product limitations to create an intuitive content management experience.

### Development Strategy

We follow iterative refinement and enhancement of features, ensuring a robust and adaptive CMS.

## In-Progress & Future Milestones

### 0.1.0 Domain Model Foundation - IN PROGRESS

- **Goal**: Establish the foundational domain model framework for EDNet CMS.
  - [x] Define Roadmap and first Spiral MVP.
  - [x] Create a basic CMS for the EDNet CMS.
  - [x] Enable user to evolve content model organically.
  - [ ] Implement accessibility features.
  - [ ] Implement a simple registration and login system.
  - [ ] Welcome returning or authenticated users.
  - [ ] Setup CI/CD pipeline for Flutter Web.
  - [ ] Implement in vivo domain model editing via canvas graph editor with multiple visualization layouts.
  - [ ] Support domain model sharing, collaboration, versioning, and evolution.

### 0.2.0 Content Types - IN PROGRESS

- **Goal**: Support various content types in an accessible way.
  - [ ] Implement image handling and display.
  - [ ] Implement video playback and management.
  - [ ] Implement audio playback and management.
  - [ ] Support documents and complex text formatting.
  - [ ] Implement backup, restore, import, and export functionalities.
  - [ ] Implement links, tags, and categories for better discoverability.
  - [ ] Develop a robust search functionality.

### 0.3.0 Security & Permissions - IN PROGRESS

- **Goal**: Establish a secure user management system.
  - [ ] Define users, roles, and permissions.
  - [ ] Implement security measures and protocols.
  - [ ] Strengthen security for unsecure environments.

### 0.4.0 User Experience - IN PROGRESS

- **Goal**: Enhance user interface and experience.
  - [ ] Implement menus, widgets, themes, and notifications.
  - [ ] Basic gamification framework.
  - [ ] Achievement systems and user progression tracking.
  - [ ] Reward mechanisms.

### 0.5.0 Platform Integration - IN PROGRESS

- **Goal**: Prepare the system for large-scale deployment.
  - [ ] Implement logs, API, CLI, Docker, Kubernetes, and CI/CD improvements.
  - [ ] Develop plugin architecture and settings management.
  - [ ] Implement comprehensive analytics tools.

### 0.6.0 Advanced Features - IN PROGRESS

- **Goal**: Integrate advanced technologies for enhanced functionality.
  - [ ] Basic AI integration.
  - [ ] Advanced AI content analysis and recommendations.
  - [ ] Initial blockchain integration research.
  - [ ] Blockchain-based content verification.
  - [ ] Implement P2P capabilities for distributed content management.
  - [ ] Enhance domain modeling with Event Storming capabilities.

### 1.0.0 Official Release - PLANNED

- **Goal**: Officially launch EDNet CMS.
  - [ ] Finalize core functionality and fix remaining issues.
  - [ ] Complete comprehensive documentation.
  - [ ] Establish support, marketing, finance, and legal structures.
  - [ ] Create official website and community resources.

## Long-term Vision

### 2.0.0 Extended Reality - PLANNED

- **Goal**: Explore AR/VR applications in content management.
  - [ ] AR content visualization.
  - [ ] VR content creation and manipulation.
  - [ ] Immersive content consumption experiences.

### 3.0.0 Internet of Things - PLANNED

- **Goal**: Expand CMS functionality to IoT devices.
  - [ ] IoT device content management.
  - [ ] Sensor data integration.
  - [ ] Real-time IoT content updates.

### 4.0.0 Quantum Computing - PLANNED

- **Goal**: Explore quantum computing implications in semantic CMS operating on all data.
  - [ ] Quantum-resistant security measures.
  - [ ] Quantum algorithms for content analysis.
  - [ ] Quantum-powered search capabilities.

## Completed Features

### Core Domain Model - DONE

- [x] User-defined content concepts with attributes.
- [x] User-defined concept relationships.
- [x] Domain model editing with concept selection.
- [x] Domain model CRUD operations.
- [x] Domain model validation.
- [x] Domain model export and import.

### Query System - DONE

- [x] Implemented expression-based query system in ednet_core v1.0.0.
- [x] Type-safe query building with composable expressions.
- [x] Support for advanced filtering and relationship traversal.
- [x] Integration with Drift database.

### Documentation & Community - DONE

- [x] Developed initial documentation, tutorials, and examples.
- [x] Created comprehensive articles on domain-specific languages.
- [x] Added articles on Event Sourcing and Meta-Modeling.
- [x] Implemented rules for software development best practices.

### Current WIP

- [x] Rebranded ednet_event_storming to EDNetFlow (ednet_flow)
- [x] Implemented multiple domain visualization layout algorithms:
  - [x] Circular Layout: Arranges nodes in a circular pattern
  - [x] Grid Layout: Positions nodes in a regular grid structure
  - [x] Dijkstra Layout: Positions based on shortest path distances
  - [x] Network Flow Layout: Visualizes data flow through a system
  - [x] Ranked Embedding Layout: Creates hierarchical structures with clear levels
  - [x] MST (Minimum Spanning Tree) Layout: Creates clean tree visualizations
- [ ] Integrate visualization components with ednet_one_interpreter
- [ ] Create unified interface for in-vivo domain model editing
- [ ] Implement realtime model updates during editing sessions

## Core Responsibilities

The CMS package focuses on:
1. **Domain Model Integration**: Interpreting domain models defined with ednet_core
2. **Content Generation**: Transforming models into usable Flutter applications
3. **User Interface Components**: Providing accessible UI components for content visualization
4. **Content Watching**: Enabling real-time updates to domain models

## Integration with Monorepo Packages

The CMS package integrates with other packages in the monorepo as follows:

- **ednet_core**: Foundation for domain modeling concepts, entities, and relationships
- **ednet_code_generation**: Code generation tools to create domain model implementations
- **content**: Pre-defined content types and structures for common use cases
- **types**: Core type definitions used across the ecosystem
- **drift**: Database integration for persistent storage of content
- **ednet_flow**: Visualization tools for domain models, event flows, and process modeling
- **ednet_one_interpreter**: Application that interprets and visualizes domain models
- **ednet_p2p**: Peer-to-peer capabilities for distributed content management
- **openapi**: API integration for connecting with external systems

## Milestones

### 1.0 Core Functionality - COMPLETED

- [x] Content watcher builder to detect and process .ednet.yaml files
- [x] Integration with code generation pipeline
- [x] Basic entity visualization widgets
- [x] Domain model builder for transforming domain models into UI components

### 1.1 Enhanced Content Management - IN PROGRESS

- [ ] Rich text editor components with accessibility features
- [ ] Media handling (images, videos, audio) with accessibility support
- [ ] Content versioning and history tracking
- [ ] Collaborative editing capabilities through ednet_p2p integration

### 1.2 Expanded Visualization - PLANNED

- [ ] Enhanced graph visualization of domain models
- [ ] Interactive editing of domain models through visual interfaces
- [ ] Custom layout algorithms for different domain visualization needs
- [ ] Integration with ednet_flow for process visualization

### 1.3 External System Integration - PLANNED

- [ ] OpenAPI integration for connecting to external services
- [ ] Import/export functionality with common CMS formats
- [ ] Webhook support for event-driven architecture
- [ ] OAuth integration for identity management

### 1.4 Advanced Search and Discovery - PLANNED

- [ ] Full-text search across content types
- [ ] Faceted search with filters based on domain model attributes
- [ ] Content recommendations based on user behavior
- [ ] Tagging and categorization system

### 1.5 Performance Optimization - PLANNED

- [ ] Lazy loading of domain model components
- [ ] Caching strategies for frequently accessed content
- [ ] Optimized rendering of large domain models
- [ ] Reduced memory footprint for mobile devices

## Detailed Development Tasks

### Content Builder Improvements

- [ ] Enhanced error reporting for malformed YAML
- [ ] Support for schema validation of domain models
- [ ] Hot reload support for domain model changes
- [ ] Incremental code generation to avoid full rebuilds

### User Interface Components

- [ ] Theme customization for content visualization
- [ ] Responsive layouts for various screen sizes
- [ ] Animation support for transitions between content states
- [ ] Custom rendering plugins for specialized content types

### Integration Features

- [ ] Event sourcing with ednet_core to track content changes
- [ ] Drift integration for offline-first content management
- [ ] P2P synchronization of content changes across devices
- [ ] OpenAPI client generation for external API consumption

### Developer Experience

- [ ] Comprehensive documentation and examples
- [ ] Visual debugging tools for domain model exploration
- [ ] CLI tools for content management operations
- [ ] Test utilities for domain model validation

## Long-term Vision

The long-term vision for EDNet CMS is to serve as a comprehensive platform for building content-centric applications that are:

1. **Domain-Driven**: Strongly aligned with business concepts and language
2. **Accessible**: Usable by everyone, regardless of abilities
3. **Collaborative**: Supporting real-time multi-user editing and interactions
4. **Extensible**: Easily customizable for domain-specific needs
5. **Cross-Platform**: Running seamlessly on web, mobile, and desktop

By leveraging the strengths of other packages in the monorepo, EDNet CMS aims to provide a cohesive experience for both developers and end-users, making complex domain models accessible through intuitive interfaces.
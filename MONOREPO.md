# EDNetDev Monorepo Configuration

## Overview
This document describes the configuration and management of the EDNetDev monorepo using Melos.

## Package Structure
```
packages/
├── core/                 # Base package
├── code_generation/      # First level
├── types/               # First level
├── ednet_flow/          # First level
├── openapi/             # First level
├── cms/                 # Second level
├── ednet_core_flutter/  # Second level
├── drift/               # Second level
├── content/             # Apps
└── apps/*              # Other apps
```

## Dependency Hierarchy
1. **Core Package (Base Layer)**
   - ednet_core

2. **First Level Dependencies**
   - ednet_code_generation (depends on core)
   - ednet_core_types (depends on core)
   - ednet_flow (depends on core)
   - ednet_openapi (depends on core)

3. **Second Level Dependencies**
   - ednet_cms (depends on core, code_generation)
   - ednet_core_flutter (depends on core)
   - ednet_drift (depends on core)

4. **Applications**
   - content package
   - other applications

## Melos Configuration

### Core Features

1. **Version Control**
   ```yaml
   command:
     version:
       linkToCommits: true
       branch: main
       workspaceChangelog: true
   ```
   - Generates commit links in changelogs
   - Restricts versioning to main branch
   - Creates workspace-level changelog

2. **Bootstrap Configuration**
   ```yaml
   command:
     bootstrap:
       runPubGetInParallel: true
       enforceLockfile: true
       environment:
         sdk: ">=3.0.0 <4.0.0"
   ```
   - Enables parallel pub get execution
   - Enforces lockfile consistency
   - Defines SDK constraints

### Available Scripts

1. **Analysis and Formatting**
   - `melos run analyze` - Run Flutter analyze across all packages
   - `melos run analyze:core` - Analyze core package
   - `melos run format` - Format all code
   - `melos run format:core` - Format core package

2. **Testing**
   - `melos run test` - Run all tests with coverage
   - `melos run test:core` - Run core package tests
   - `melos run test:dart` - Run Dart tests for specific packages
   - `melos run test:filter` - Run tests in packages matching SCOPE filter

3. **Dependency Management**
   - `melos run outdated` - Check for outdated dependencies
   - `melos run upgrade` - Upgrade dependencies
   - `melos run clean` - Clean build artifacts

4. **Publishing Workflow**
   - `melos run publish:all` - Publish all packages in order
   - `melos run publish:check` - Check versions and dependencies
   - Individual package publishing commands for each component

## Development Workflow

1. **Initial Setup**
   ```bash
   melos bootstrap
   ```

2. **Development Cycle**
   ```bash
   melos run analyze
   melos run test
   melos run format
   ```

3. **Publishing Process**
   ```bash
   melos run publish:check
   melos run publish:all
   ```

## Best Practices

1. **Dependency Management**
   - Use published versions in `pubspec.yaml`
   - Let Melos handle local development overrides
   - Follow the defined dependency hierarchy

2. **Version Control**
   - Commit changes with conventional commit messages
   - Use the main branch for versioning
   - Maintain changelog entries

3. **Quality Assurance**
   - Run tests before publishing
   - Ensure formatting consistency
   - Check for outdated dependencies regularly

## IDE Integration

```yaml
ide:
  intellij:
    enabled: true
```

Provides IntelliJ IDEA integration for improved monorepo development experience. 
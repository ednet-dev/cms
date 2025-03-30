# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-03-30

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`ednet_code_generation` - `v1.0.1`](#ednet_code_generation---v101)
 - [`ednet_cms` - `v0.0.3-dev.8`](#ednet_cms---v003-dev8)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `ednet_cms` - `v0.0.3-dev.8`

---

#### `ednet_code_generation` - `v1.0.1`

 - First stable API release (1.0.1)


## 2025-03-30

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`ednet_core_types` - `v1.0.1`](#ednet_core_types---v101)

---

#### `ednet_core_types` - `v1.0.1`

 - First stable API release (1.0.1)


## 2025-03-30

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`ednet_core` - `v1.0.1`](#ednet_core---v101)
 - [`ednet_code_generation` - `v0.0.5+1`](#ednet_code_generation---v0051)
 - [`ednet_cms` - `v0.0.3-dev.7`](#ednet_cms---v003-dev7)
 - [`ednet_core_types` - `v0.0.1+1`](#ednet_core_types---v0011)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `ednet_code_generation` - `v0.0.5+1`
 - `ednet_cms` - `v0.0.3-dev.7`
 - `ednet_core_types` - `v0.0.1+1`

---

#### `ednet_core` - `v1.0.1`

 - First stable API release (1.0.1)

 - **DOCS**(core): Entity line docs.
 - **DOCS**(core): README.md for each domain.


## 2025-01-15

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`ednet_core` - `v0.1.0`](#ednet_core---v010)

---

#### `ednet_core` - `v0.1.0`


## 2024-12-07

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`ednet_core` - `v0.0.1+11`](#ednet_core---v00111)

---

#### `ednet_core` - `v0.0.1+11`

 - TBD-CHANGELOG


## 2023-06-28

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.3-dev.5`](#ednet_cms---v003-dev5)
- [`ednet_code_generation` - `v0.0.5`](#ednet_code_generation---v005)
- [`ednet_core` - `v0.0.1+10`](#ednet_core---v00111)

---

#### `ednet_cms` - `v0.0.3-dev.5`

- **REFACTOR**(ednet_cms): remove unnecessary this.
- **PERF**(ednet_cms): generate only for content/\*.yaml.
- **FIX**: pub dependencies instead of local absolute path.
- **FIX**(ednet_cms): correct syntax for executables in pubspec.yaml.
- **FEAT**(ednet_cms): build or watch domain model with 'dart run ednet_cms:build' or 'dart run ednet_cms:watch'.
- **FEAT**(ednet_cms): ContentWatcherBuilder for more performant way of building the cms.
- **FEAT**(ednet_cms): example.yaml -> example.ednet.yaml.
- **FEAT**(ednet_cms): invoke EDNetCodeGenerator with build_runner targeting client.
- **FEAT**(ednet_cms): init CmsBuilder.
- **FEAT**(ednet_cms): ednet_cms feature.

#### `ednet_code_generation` - `v0.0.5`

- **FIX**: pub dependencies instead of local absolute path.
- **FEAT**(ednet_code_generation): EDNetCodeGenerator invoked from 3rd party package.
- **FEAT**(ednet_code_generation): refactor package from command line only and init EDNetCodeGenerator for programmatically generated domain models.
- **FEAT**(ednet_code_generation): feature.

#### `ednet_core` - `v0.0.1+10`

- **FIX**: ednet_core bug.

# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2023-03-14

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.3-dev.3`](#ednet_cms---v003-dev3)
- [`ednet_code_generation` - `v0.0.3+1`](#ednet_code_generation---v0031)

---

#### `ednet_cms` - `v0.0.3-dev.3`

- **FIX**: pub dependencies instead of local absolute path.

#### `ednet_code_generation` - `v0.0.3+1`

- **FIX**: pub dependencies instead of local absolute path.

## 2023-03-14

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.3-dev.2`](#ednet_cms---v003-dev2)

---

#### `ednet_cms` - `v0.0.3-dev.2`

- **FIX**(ednet_cms): correct syntax for executables in pubspec.yaml.
- **FEAT**(ednet_cms): build or watch domain model with 'dart run ednet_cms:build' or 'dart run ednet_cms:watch'.

## 2023-03-13

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.3-dev.1`](#ednet_cms---v003-dev1)
- [`ednet_code_generation` - `v0.0.3`](#ednet_code_generation---v003)

---

#### `ednet_cms` - `v0.0.3-dev.1`

- **PERF**(ednet_cms): generate only for content/\*.yaml.
- **FEAT**(ednet_cms): ContentWatcherBuilder for more performant way of building the cms.
- **FEAT**(ednet_cms): example.yaml -> example.ednet.yaml.
- **FEAT**(ednet_cms): invoke EDNetCodeGenerator with build_runner targeting client.

#### `ednet_code_generation` - `v0.0.3`

- **FEAT**(ednet_code_generation): EDNetCodeGenerator invoked from 3rd party package.
- **FEAT**(ednet_code_generation): refactor package from command line only and init EDNetCodeGenerator for programmatically generated domain models.

## 2023-03-10

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.3-dev.0`](#ednet_cms---v003-dev0)

---

#### `ednet_cms` - `v0.0.3-dev.0`

- **FEAT**(ednet_cms): init CmsBuilder.

## 2023-03-10

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_cms` - `v0.0.2`](#ednet_cms---v002)
- [`ednet_code_generation` - `v0.0.2`](#ednet_code_generation---v002)
- [`ednet_core` - `v0.0.1+8`](#ednet_core---v0018)

---

#### `ednet_cms` - `v0.0.2`

- **FEAT**(ednet_cms): ednet_cms feature.

#### `ednet_code_generation` - `v0.0.2`

- **FEAT**(ednet_code_generation): feature.

#### `ednet_core` - `v0.0.1+8`

- **FIX**: ednet_core bug.

## 2023-03-10

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`ednet_core` - `v0.0.1+7`](#ednet_core---v0017)
- [`ednet_cms` - `v0.0.1+7`](#ednet_cms---v0017)
- [`ednet_code_generation` - `v0.0.1+7`](#ednet_code_generation---v0017)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

- `ednet_cms` - `v0.0.1+7`
- `ednet_code_generation` - `v0.0.1+7`

---

#### `ednet_core` - `v0.0.1+7`

- Bump "ednet_core" to `0.0.1+7`.

## EDNetCMS

**0.0.1+6** 2023-03-10

- Debug Github CI/CD

**0.0.1+5** 2023-03-10

- Tag based GitHub Actions publishing of core, gen and cms

**0.0.1+4** 2023-03-10

- streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.
  **0.0.1+3** 2023-03-10
- monorepo extended with:
  - core,
  - ednet_core_gen
- cms:
  - init build system
  - EDNetDSL JSON schema for JSON and YAML dialects
  - init ednet context domains:
    - authentication
    - direct_democracy
    - legislation
    - example domain model

**0.0.1+2**

- Bump pub version to 0.0.1+2 to test CI/CD

**0.0.1+1**

- Configure CI/CD with Codemagic and publish EDNetCMS to pub.dev

## EDNetCore

**0.0.1+4** 2023-03-10

- streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

**0.0.1+3** 2023-03-08

- EDNetDSL JSON schema for JSON and YAML dialects
- example yaml domain model

**0.0.1+2** 2023-03-08

- refactor to modern Dart
  - all Api suffixes of interfaces to IName
  - ConceptEntity -> Entity
  - nullability functional unstable solution
- reset version

## EDNetCodeGeneration

**0.0.1+4** 2023-03-10

- streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

**0.0.1+3** 2023-05-01

- refactor to modern Dart
- integrate in ednet cms monorepo
- reset version

# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

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
+ Debug Github CI/CD

**0.0.1+5** 2023-03-10
+ Tag based GitHub Actions publishing of core, gen and cms

**0.0.1+4** 2023-03-10
+ streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.
  **0.0.1+3** 2023-03-10
+ monorepo extended with:
    - core,
    - ednet_core_gen
+ cms:
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
+ streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

**0.0.1+3** 2023-03-08
+ EDNetDSL JSON schema for JSON and YAML dialects
+ example yaml domain model

**0.0.1+2** 2023-03-08
+ refactor to modern Dart
    + all Api suffixes of interfaces to IName
    + ConceptEntity -> Entity
    + nullability functional unstable solution
+ reset version

## EDNetCodeGeneration
**0.0.1+4** 2023-03-10
+ streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

**0.0.1+3** 2023-05-01
+ refactor to modern Dart
+ integrate in ednet cms monorepo
+ reset version



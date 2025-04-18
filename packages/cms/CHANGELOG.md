## 1.0.0

 - First stab## 1.0.0le API release (1.0.0)

## 0.0.3-dev.8

 - Update a dependency to the latest release.

## 0.0.3-dev.7

 - Update a dependency to the latest release.

## 0.0.3-dev.5

 - **REFACTOR**(ednet_cms): remove unnecessary this.
 - **PERF**(ednet_cms): generate only for content/*.yaml.
 - **FIX**: pub dependencies instead of local absolute path.
 - **FIX**(ednet_cms): correct syntax for executables in pubspec.yaml.
 - **FEAT**(ednet_cms): build or watch domain model with 'dart run ednet_cms:build' or 'dart run ednet_cms:watch'.
 - **FEAT**(ednet_cms): ContentWatcherBuilder for more performant way of building the cms.
 - **FEAT**(ednet_cms): example.yaml -> example.ednet.yaml.
 - **FEAT**(ednet_cms): invoke EDNetCodeGenerator with build_runner targeting client.
 - **FEAT**(ednet_cms): init CmsBuilder.
 - **FEAT**(ednet_cms): ednet_cms feature.

## 0.0.3-dev.4

 - **PERF**: generate only for content/*.yaml.
 - **FIX**: pub dependencies instead of local absolute path.
 - **FIX**: correct syntax for executables in pubspec.yaml.
 - **FEAT**: build or watch domain model with 'dart run ednet_cms:build' or 'dart run ednet_cms:watch'.
 - **FEAT**: ContentWatcherBuilder for more performant way of building the cms.
 - **FEAT**: example.yaml -> example.ednet.yaml.
 - **FEAT**: invoke EDNetCodeGenerator with build_runner targeting client.
 - **FEAT**: init CmsBuilder.
 - **FEAT**: ednet_cms feature.

## 0.0.3-dev.3

 - **FIX**: pub dependencies instead of local absolute path.

## 0.0.3-dev.2

 - **FIX**(ednet_cms): correct syntax for executables in pubspec.yaml.
 - **FEAT**(ednet_cms): build or watch domain model with 'dart run ednet_cms:build' or 'dart run ednet_cms:watch'.

## 0.0.3-dev.1

 - **PERF**(ednet_cms): generate only for content/*.yaml.
 - **FEAT**(ednet_cms): ContentWatcherBuilder for more performant way of building the cms.
 - **FEAT**(ednet_cms): example.yaml -> example.ednet.yaml.
 - **FEAT**(ednet_cms): invoke EDNetCodeGenerator with build_runner targeting client.

## 0.0.3-dev.0

 - **FEAT**(ednet_cms): init CmsBuilder.

## 0.0.2

 - **FEAT**(ednet_cms): ednet_cms feature.

## 0.0.1+7
+ Debug Github CI/CD

## 0.0.1+6
+ Debug Github CI/CD

## 0.0.1+5
+ Tag based GitHub Actions publishing of core, gen and cms
 
## 0.0.1+4
+ streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

## 0.0.1+3
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
      
## 0.0.1+2
- Bump pub version to 0.0.1+2 to test CI/CD

## 0.0.1+1
- Configure CI/CD with Codemagic and publish EDNetCMS to pub.dev

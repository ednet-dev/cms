## `YAMLSOURCE.MD`

### Class/Artifact Overview

**YamlSource** is a configuration utility responsible for determining the location of a YAML-based domain model definition. It checks for a local path and, if found, returns that path. Otherwise, it throws an exception indicating that the YAML file is not found. This class can be used anywhere within the EDNet Core library to centralize the discovery of YAML configuration files.

### Properties/Fields

| **Name**     | **Type**    | **Description**                                                                                                          |
|--------------|-------------|--------------------------------------------------------------------------------------------------------------------------|
| `localPath`  | `String`    | Default local directory name where the YAML file is expected to be located.                                              |
| `remoteUrl`  | `String`    | An external GitHub repository URL pointing to a sample or remote version of the YAML-based domain configuration files.   |

### Constructors

**Default Constructor**
```dart
YamlSource();
```
- **Description**: Instantiates a `YamlSource` object with predefined `localPath` and `remoteUrl`.
- **Parameters**: None.
- **Behavior/Initialization**:
  - Sets `localPath` to `"domain_model_definition"`.
  - Sets `remoteUrl` to `"https://github.com/context-dev/example-configuration-domain.git"`.

### Methods

#### `Future<String> getYamlPath()`
- **Signature**:
  ```dart
  Future<String> getYamlPath() async
  ```
- **Description**:  
  Attempts to locate the YAML definition file in the local path. If the directory exists, returns the `localPath`; otherwise, throws a `FileSystemException`.
- **Parameters**: None.
- **Returns**:
  - `Future<String>`: The file path where the YAML configuration is located.
- **Exceptions**:
  - `FileSystemException`: Thrown when the expected local directory does not exist.
- **Side Effects**:
  - None beyond checking the presence of a local directory.

### Example Usage

```dart
import 'dart:io';
import 'package:ednet_core/configuration/yaml_source.dart';

void main() async {
  final yamlSource = YamlSource();

  try {
    // Attempt to locate the local YAML file path
    String path = await yamlSource.getYamlPath();
    print('YAML Path found at: $path');

    // (Hypothetical) Read the file content
    // var fileContent = File('$path/config.yaml').readAsStringSync();
    // print(fileContent);

  } on FileSystemException catch (e) {
    print('Error: ${e.message}');
    // Fallback logic could go here, e.g., attempting to fetch from remoteUrl
  }
}
```

#### Edge-Case Usage
- **Edge case**: The `domain_model_definition` directory is missing.
  ```dart
  void main() async {
    // If you rename or remove the local directory, this will throw an exception
    final yamlSource = YamlSource();

    try {
      await yamlSource.getYamlPath();
    } catch (e) {
      // Expect a FileSystemException here
      print('Caught exception as expected: $e');
    }
  }
  ```

### Dependencies & Cross-References

- **Dart I/O**: Uses `dart:io` (`Directory`, `FileSystemException`) to check the existence of a local directory and throw an appropriate exception if missing.
- **EDNet Core**: Part of the `configuration` sub-library. Although it does not currently reference other EDNet Core artifacts, it serves as a foundational component for domain model initialization in the broader library.

### Design Notes

- **Simplicity**: By keeping the local path in a final field, the class can remain immutable, and its usage pattern is straightforward.
- **Extensibility**: `remoteUrl` is included for future use cases where remote retrieval or synchronization of the YAML file might be required.
- **Integration**: `YamlSource` is intended to be used early in the initialization process of an EDNet Core application to ensure required domain definitions are available.


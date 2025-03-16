# 1. `BOOTSTRAP_DOMAIN_MODEL_FROM_YAML.MD`

## Artifact Overview
This file (`bootstrap_domain_model_from_yaml.dart`) includes two primary elements:

1. A **constant** `yaml` – a multiline string containing an example or template YAML domain model definition.
2. A **function** `loadYaml(...)` – a utility to read YAML from a file path.

### `yaml`
- **Type**: `String` (constant).
- **Content**: A sample YAML snippet that outlines domain model sections (`attributes`, `valueObjects`, `entities`, `boundedContexts`, etc.).
- **Usage**: Possibly used as an inline example or fallback content if no external YAML is found.

#### Example Usage
```dart
// Direct usage within the code:
print(yaml); // prints the entire YAML definition
```

#### Dependencies & Cross-references
- **Not** directly referencing other EDNet parts. It's a standalone string constant.

#### Design Notes
- Illustrates a potential structure for a domain model file. Real usage might parse this or override it with local definitions.

---

### `String loadYaml({String domainModelName, String filePath})`
- **Signature**:
  ```dart
  String loadYaml({
    String domainModelName = "domain_model_name",
    String filePath = "domain_model_definition",
  })
  ```
- **Description**: Attempts to read a YAML file from the given `filePath` directory, constructing the full filename as `"$filePath/$domainModelName.yaml"`, and returns its contents as a string.
- **Parameters**:
    - `domainModelName`: Default `"domain_model_name"`. The base filename (sans extension).
    - `filePath`: Default `"domain_model_definition"`. Directory or path.
- **Returns**:  
  A string containing the YAML file’s contents.
- **Exceptions**:
    - Could throw a `FileSystemException` if the file is missing or unreadable.
- **Side Effects**: None beyond reading from the filesystem.

#### Example Usage
```dart
void main() {
  try {
    final content = loadYaml(
      domainModelName: "my_app",
      filePath: "my_config",
    );
    print("YAML content loaded:\n$content");
  } catch (e) {
    print("Could not load YAML: $e");
  }
}
```

#### Dependencies & Cross-references
- Relies on `dart:io` (specifically `File`), but the snippet does not explicitly import it.
- Could be combined with EDNet’s domain or configuration logic from **Part 1 – `YamlSource`** if desired.

#### Design Notes
- Meant as a utility for DSL or domain-bootstrapping scenarios, reading external YAML definitions for further parsing.

---

# 2. `DOMAIN_MODEL_GRAPH.MD`

**File**: `domain_model_graph.dart` is empty in the provided snippet.  
No classes or functions to document.

---

# 3. `GRAPH_VISUALITAZION_WIDGET.MD`

**File**: `graph_visualitazion_widget.dart` is empty in the provided snippet.  
No classes or functions to document.

---

# 4. `TRANSFORMATION.MD`

## Artifact Overview
`transformation.dart` contains a set of **top-level string transformation functions**. These utility methods are commonly used across EDNet for naming, code generation, or text manipulation. We document them collectively under the “transformation” artifact.

---

### `String dropEnd(String text, String end)`
- **Description**: If `text` ends with a given substring `end`, removes that substring. If not found, returns `text` unchanged.
- **Parameters**:
    - `text`: The full string.
    - `end`: The substring to drop from the end.
- **Returns**:  
  A new string with `end` removed if it was found at the last index, otherwise the original `text`.
- **Edge Cases**:
    - If `endPosition` < 0 (meaning `end` not found), no change is applied.
- **Example**:
  ```dart
  final result = dropEnd("HelloWorld", "World"); 
  // result == "Hello"
  ```

#### Design Notes
- Ensures a simpler approach than `text.replaceAll()` if you only want to remove a trailing substring.

---

### `String plural(String text)`
- **Description**: Returns a “pluralized” form of `text`. For example:
    - If ends with `x` => `+ "es"`
    - If ends with `z` => `+ "zes"`
    - If ends with `y` => replace `y` with `"ies"`
    - Else just `+ "s"`
- **Parameters**:
    - `text`: The singular form or base word.
- **Returns**:
    - A rough pluralization.
- **Example**:
  ```dart
  plural("box"); // "boxes"
  plural("story"); // "stories"
  plural("cat");   // "cats"
  ```
- **Edge Cases**:
    - If `text` is empty, returns an empty string.
    - Doesn’t handle complex English plurals (“mouse” => “mice”).

---

### `String firstLetterLower(String text)`
- **Description**: Converts the **first** character of `text` to lowercase, leaves the rest unchanged.
- **Parameters**:
    - `text`: The original string.
- **Returns**:
    - A new string with the initial letter in lowercase.
- **Example**:
  ```dart
  firstLetterLower("HelloWorld"); // "helloWorld"
  ```
- **Edge Cases**:
    - If `text` is empty, returns empty string.

---

### `String firstLetterUpper(String text)`
- **Description**: Converts the first character of `text` to uppercase, leaves the rest unchanged.
- **Parameters**:
    - `text`: The string to modify.
- **Returns**:
    - A new string with uppercase initial letter.
- **Example**:
  ```dart
  firstLetterUpper("helloWorld"); // "HelloWorld"
  ```

---

### `String camelCaseSeparator(String text, String separator)`
- **Description**: Breaks a CamelCase or PascalCase string into segments, joined by a custom separator. For instance, `"HelloWorld"` => `"Hello_World"` if `separator = "_"`.
- **Parameters**:
    - `text`: The input, presumably CamelCase or PascalCase.
    - `separator`: The string inserted between each “capital start.”
- **Returns**:
    - The segmented string, e.g. `"Hello_World"` or `"Hello-World"`.
- **Implementation**:
    - Uses a regex `([A-Z])`, collects match indexes, then splits and re-joins.
- **Example**:
  ```dart
  camelCaseSeparator("HelloWorld", "_"); // "Hello_World"
  ```

#### Design Notes
- This is a simplistic approach — it splits each uppercase letter except the first into a separate segment.

---

### `String camelCaseLowerSeparator(String text, String separator)`
- **Description**: Similar to `camelCaseSeparator`, but **lowercases** the entire result afterward.
- **Parameters**:
    - `text`: CamelCase or PascalCase
    - `separator`: e.g. `_`
- **Returns**:
    - The separated + lowercased string, e.g. `"hello_world"`.
- **Example**:
  ```dart
  camelCaseLowerSeparator("HelloWorld", "_"); // "hello_world"
  ```

---

### `String camelCaseFirstLetterUpperSeparator(String text, String separator)`
- **Description**: First calls `camelCaseSeparator`, then makes the entire result’s first letter uppercase.
- **Parameters**:
    - `text`: The input string in CamelCase.
    - `separator`: The separator to insert (e.g. `' '`).
- **Example**:
  ```dart
  camelCaseFirstLetterUpperSeparator("helloWorld", " ");
  // "Hello World"
  ```

---

## Example Usage (Collectively)
```dart
void main() {
  print(dropEnd("HelloWorld", "World")); // "Hello"
  print(plural("story"));                // "stories"
  print(firstLetterLower("Sample"));     // "sample"
  print(firstLetterUpper("sample"));     // "Sample"

  print(camelCaseSeparator("HelloWorld", "_")); // "Hello_World"
  print(camelCaseLowerSeparator("HelloWorld", "_")); // "hello_world"
  print(camelCaseFirstLetterUpperSeparator("helloWorld", " ")); // "Hello World"
}
```

## Dependencies & Cross-references
- Pure Dart string manipulations. No direct references to EDNet domain or meta models, but heavily used by code generation in **Part 3** to transform concept codes, property codes, etc.

## Design Notes
- Simple, pattern-based transformations for naming or code generation. Not a complete or perfect approach for the English language, but sufficient for typical EDNet usage patterns (like generating class names, plural forms, etc.).



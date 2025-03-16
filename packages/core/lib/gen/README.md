## 1) `IONEAPPLICATION.MD`

### Class/Artifact Overview
**`IOneApplication`** is an abstract interface describing how an “application” interacts with `Domains` and `DomainModels`. It suggests that an “application” typically manages multiple domain sets and can retrieve `DomainModels` by name.

### Properties/Fields

| **Name**            | **Type**        | **Description**                                                                |
|---------------------|-----------------|--------------------------------------------------------------------------------|
| `domains`          | `Domains`       | Returns a list/collection of all domains known to this application.           |
| `groupedDomains`   | `Domains`       | A possibly grouped/aggregated set of domains. The grouping logic is not shown. |

### Methods

#### `DomainModels getDomainModels(String domain, String model)`
- **Description**: Fetches a `DomainModels` object associated with the given `domain` and `model` code.
- **Parameters**:
    - `domain`: The domain code/name.
    - `model`: The model code/name.
- **Returns**: A `DomainModels` instance matching the identifiers.
- **Side Effects**: None stated.

### Example Usage
```dart
class MyApplication implements IOneApplication {
  // imagine fields or constructor

  @override
  Domains get domains => ...

  @override
  Domains get groupedDomains => ...

  @override
  DomainModels getDomainModels(String domain, String model) {
    // your custom logic or a map-based lookup
  }
}
```

### Dependencies & Cross-references
- Relies on `Domains` (documented in Part 2).
- Exposes domain structures and `DomainModels` references.

### Design Notes
- A high-level interface bridging an “application layer” to EDNet’s domain layer.
- Encourages consistent retrieval of domain constructs.

---

## 2) `GENCONCEPTGEN.MD`

### Function Overview
**`genConceptGen`** is a top-level function generating Dart code for a concept’s “generic” base classes (e.g., `SomeConceptGen` and `SomeConceptsGen`). It is part of EDNet’s automated code generation.

```dart
String genConceptGen(Concept concept, String library)
```

### Parameters
- **`concept`** (`Concept`): The metamodel concept to generate code for.
- **`library`** (`String`): Name/path of the library to be referenced in generated code.

### Returns
- **`String`**: The generated Dart code as a multi-line string, including abstract classes with `Entity` superclasses and stubs for commands, events, and policies.

### Example Usage
```dart
final conceptCode = genConceptGen(someConcept, 'my_library');
print(conceptCode); // shows generated abstract class code
```

### Dependencies & Cross-references
- Uses `Concept`, `Model`, `Domain` from EDNet’s metamodel (Part 2).
- Internally calls private helpers like `_generateChildrenSetup`, `_generateWithIdConstructor`, etc.
- Typically invoked by code generation scripts that build the domain classes from YAML/JSON definitions.

### Design Notes
- Central to EDNet’s “model-driven” approach, producing boilerplate for concepts (like attribute getters/setters, child access, compareTo).

---

## 3) `GENCONCEPT.MD`

### Function Overview
**`genConcept`** produces specific (non-abstract) Dart classes for a concept, usually appended to a buffer for domain customization.

```dart
String genConcept(Concept concept, String library)
```

### Parameters
- **`concept`** (`Concept`): The concept being materialized into code.
- **`library`** (`String`): The name/path of the Dart library to reference.

### Returns
- **`String`**: The Dart code string, including `class SomeConcept extends SomeConceptGen` and `class SomeConcepts extends SomeConceptsGen`.

### Example Usage
```dart
final specificConceptCode = genConcept(myConcept, 'my_library');
print(specificConceptCode);
```

### Dependencies & Cross-references
- Relies on the previously generated abstract classes from `genConceptGen`.
- References `Concept`, `Model`, `Domain`.

### Design Notes
- Provides the user-extension points: “// added after code gen - begin/end” for custom code.

---

## 4) `GENMODELS.MD`

### Function Overview
**`genModels`** creates a Dart class `<Domain>Models` extending `DomainModels`, loading each `Model` from JSON/YAML definitions.

```dart
String genModels(Domain domain, String library)
```

### Parameters
- **`domain`** (`Domain`): The domain to generate model-handling code for.
- **`library`** (`String`): The name/path of the library.

### Returns
- **`String`**: Source code for a `DomainModels` subclass, instantiating each `Model`.

### Example Usage
```dart
final domainModelsCode = genModels(myDomain, 'my_library');
print(domainModelsCode);
```

### Dependencies & Cross-references
- Uses `Domain`, `Model`, `DomainModels`.
- Typically calls `fromJsonToModel(...)` to create `Model` objects from YAML or JSON.

### Design Notes
- This auto-generated class is typically named `<Domain>Models`, e.g. `ExampleModels` for domain “Example,” and it calls `add(modelEntries)` for each discovered model.

---

## 5) `GENDOMAIN.MD`

### Function Overview
**`genDomain`** creates a domain-specific subclass of the auto-generated domain models, e.g., `<Domain>Domain extends <Domain>Models`.

```dart
String genDomain(Domain domain, String library)
```

### Parameters
- **`domain`** (`Domain`): The domain to generate a specialized class for.
- **`library`** (`String`): The library name/path.

### Returns
- **`String`**: Generated Dart code for the domain class.

### Example Usage
```dart
final domainClassCode = genDomain(myDomain, 'my_library');
print(domainClassCode);
```

### Dependencies & Cross-references
- The returned class extends the code from `genModels`.

### Design Notes
- Creates a partial extension point for domain-level customization (like additional methods or overrides).

---

## 6) `GENEDNETLIBRARY.MD`

### Function Overview
**`genEDNetLibrary`** constructs a library file referencing all concept parts (both “specific” and “generated”) for a single `Model`.

```dart
String genEDNetLibrary(Model model)
```

### Parameters
- **`model`** (`Model`): The model containing concepts to link.

### Returns
- **`String`**: The library’s Dart source, including multiple `part` directives for each concept’s code.

### Example Usage
```dart
final librarySource = genEDNetLibrary(myModel);
print(librarySource);
```

### Dependencies & Cross-references
- Uses `Domain`, `Model`, and their naming patterns (`domainCodeLowerUnderscore`, etc.).
- Injects the `license` string from the same file.

### Design Notes
- Collates the concept classes, bridging “generated” and “user-specific” partial code into a single library.

---

## 7) `GENEDNETLIBRARYAPP.MD`

### Function Overview
**`genEDNetLibraryApp`** produces a minimal “app” library file (like `<domain>_<model>_app`) with a license header. This is a skeleton for further expansions.

```dart
String genEDNetLibraryApp(Model model)
```

### Parameters
- **`model`** (`Model`)

### Returns
- **`String`**: A short library definition with a license and an empty block comment.

### Example Usage
```dart
final appLibrarySource = genEDNetLibraryApp(myModel);
print(appLibrarySource);
```

### Dependencies & Cross-references
- Accesses `license` from `ednet_library.dart`.

### Design Notes
- Often used for bootstrapping a separate “app” library (UI or application-specific).

---

## 8) `GENENTRIES.MD`

### Function Overview
**`genEntries`** generates a Dart class `<Model>Entries` implementing `ModelEntries`. It creates new `Entities` for each “entry concept.”

```dart
String genEntries(Model model, String library)
```

### Parameters
- **`model`** (`Model`): The model from which “entry” concepts are extracted.
- **`library`** (`String`): Not directly used in the snippet, but consistent with generation pattern.

### Returns
- **`String`**: Source code for a `<Model>Entries` class with override methods: `newEntries()`, `newEntities()`, `newEntity()`.

### Example Usage
```dart
final entriesCode = genEntries(myModel, 'my_library');
print(entriesCode);
```

### Dependencies & Cross-references
- Creates a class that extends `ModelEntries`.
- Each concept’s code is appended to produce typed `Entities` instances.

### Design Notes
- In EDNet, each “entry concept” typically has a top-level `Entities` set, tracked by `<Model>Entries`.

---

## 9) `GENMODEL.MD`

### Function Overview
**`genModel`** produces a specialized `<Model>Model` class extending `<Model>Entries`, adding methods like `fromJsonTo<Model>Entry()`, `init<ConceptPlural>()`, etc.

```dart
String genModel(Model model, String library)
```

### Parameters
- **`model`** (`Model`)
- **`library`** (`String`)

### Returns
- **`String`**: Dart code for `<Model>Model`, including an `init()` method that calls `init<ConceptPlural>()` for each entry concept.

### Example Usage
```dart
final code = genModel(myModel, 'my_library');
print(code);
```

### Dependencies & Cross-references
- Extends the code from `genEntries` output, i.e. `<Model>Entries`.
- Uses domain naming conventions from the meta-model.

### Design Notes
- This is typically where the user can add “in-model” initialization logic for testing or demonstration.

---

## 10) `GENREPOSITORY.MD`

### Function Overview
**`genRepository`** builds a repository class that extends `CoreRepository`, adding domains and domain classes for each domain in the repository.

```dart
String genRepository(CoreRepository repo, String library)
```

### Parameters
- **`repo`** (`CoreRepository`): The EDNet repository object.
- **`library`** (`String`): The library name that will be part of the file.

### Returns
- **`String`**: Dart code for the repository class, e.g. `<LibraryName>Repo`, including a constructor that adds each domain.

### Example Usage
```dart
final repoCode = genRepository(myRepo, 'example_domain_model');
print(repoCode);
```

### Dependencies & Cross-references
- Based on EDNet’s `CoreRepository`.
- For each `Domain` in `repo.domains`, it calls `add( <Domain>Domain(domain) )`.

### Design Notes
- This ties multiple domains under a single “repo” class, often used as an overarching aggregator in EDNet apps.

---

## 11) `GENEDNETGEN.MD`

### Function Overview
**`genEDNetGen`** is a utility to generate a snippet for a test file that calls `repository.gen(...)` plus optional data initialization.

```dart
String genEDNetGen(Model model)
```

### Parameters
- **`model`** (`Model`)

### Returns
- **`String`**: A test script’s Dart code, referencing the model in a typical `main()` with `genCode` / `initData`.

### Example Usage
```dart
final testSnippet = genEDNetGen(myModel);
print(testSnippet);
```

### Dependencies & Cross-references
- Ties to the user’s typical `CoreRepository`, calling `repository.gen('domain_model')`.

### Design Notes
- Mainly used for demonstration or testing harness scaffolding.

---

## 12) `GENEDNETTEST.MD`

### Function Overview
**`genEDNetTest`** generates a large test file string for a given `Concept` in a `Model`. It includes an entire battery of unit tests (add, remove, JSON, undo/redo, etc.).

```dart
String genEDNetTest(CoreRepository repo, Model model, Concept entryConcept)
```

### Parameters
- **`repo`** (`CoreRepository`): The repository containing all domains.
- **`model`** (`Model`): The model that includes `entryConcept`.
- **`entryConcept`** (`Concept`): The concept for which the test suite is generated.

### Returns
- **`String`**: A Dart test file string containing dozens of test groups (random entity tests, copy, undo, redo, etc.).

### Example Usage
```dart
final testCode = genEDNetTest(myRepo, myModel, myConcept);
print(testCode); // Outputs a comprehensive test suite
```

### Dependencies & Cross-references
- Relies on concept attributes (including “required,” “identifier,” etc.) for generating test logic.
- Calls EDNet commands (e.g., `AddCommand`, `RemoveCommand`, `SetAttributeCommand`) from Part 2.

### Design Notes
- This is the largest generator function, producing an entire range of standard tests that EDNet typically uses for domain QA.

---

## 13) `GENEDNETWEB.MD`

### Function Overview
**`genEDNetWeb`** creates a web-based entry point snippet (Dart code) for loading data from a repository, then presumably displaying or interacting with it.

```dart
String genEDNetWeb(Model model)
```

### Parameters
- **`model`** (`Model`)

### Returns
- **`String`**: Source code with a `main()` that calls `initData(repository)` and `showData(repository)`.

### Example Usage
```dart
final webSnippet = genEDNetWeb(myModel);
print(webSnippet);
```

### Dependencies & Cross-references
- `CoreRepository`, domain classes from the EDNet environment.

### Design Notes
- A minimal scaffolding for a web-based UI—placeholder for additional code.
- Typically customized further.

---

## 14) `CREATEINITENTRYENTITIESRANDOMLY.MD`

### Function Overview
**`createInitEntryEntitiesRandomly`** helps generate random “entry entities” for a particular `entryConcept`, typically used in model initialization.

```dart
String createInitEntryEntitiesRandomly(Concept entryConcept)
```

### Parameters
- **`entryConcept`** (`Concept`): The concept that’s designated as an “entry” in the model.

### Returns
- **`String`**: A Dart snippet that loops `ENTRY_ENTITIES_COUNT` times, calling `createInitEntryEntityRandomly`.

### Example Usage
```dart
final snippet = createInitEntryEntitiesRandomly(myEntryConcept);
print(snippet); // code to create 2 random initial entities
```

### Dependencies & Cross-references
- Internally calls `createInitEntryEntityRandomly(...)`.
- Ties to random generation logic in `random_data.dart`.

### Design Notes
- Usually placed in a code generator for domain seeding or testing.

---

## 15) `CREATETESTENTRYENTITIESRANDOMLY.MD`

### Function Overview
**`createTestEntryEntitiesRandomly`** is similar to `createInitEntryEntitiesRandomly`, but for test usage. It calls `createTestEntryEntityRandomly` multiple times.

```dart
String createTestEntryEntitiesRandomly(Concept entryConcept, model)
```

### Parameters
- **`entryConcept`** (`Concept`)
- **`model`** (Object representing the domain model, used for references)

### Returns
- **`String`**: Dart code snippet for adding test entities with random attributes.

### Example Usage
```dart
final testSnippet = createTestEntryEntitiesRandomly(concept, someModel);
```

### Dependencies & Cross-references
- Calls `createTestEntryEntityRandomly`.

### Design Notes
- Each generated entity references external parents if required, used for constructing realistic domain test data sets.

---

## 16) `CREATEINITENTRYENTITYRANDOMLY.MD`

### Function Overview
**`createInitEntryEntityRandomly`** produces a single random “init” entity in code, possibly linking required external parents and optionally child entities.

```dart
String createInitEntryEntityRandomly(Concept entryConcept, {
  int? suffix, 
  bool withChildren = true
})
```

### Parameters
- **`entryConcept`** (`Concept`)
- **`suffix`** (`int?`) for naming the local variable, e.g. `myEntity1`, `myEntity2`.
- **`withChildren`** (`bool`): If `true`, also creates random child entities.

### Returns
- **`String`**: Dart snippet building the entity with random attributes, adding it to the corresponding `Entities` collection.

### Example Usage
```dart
final snippet = createInitEntryEntityRandomly(myConcept, suffix: 1, withChildren: false);
```

### Dependencies & Cross-references
- Calls `setInitAttributesRandomly`.
- If concept has child references, calls `createChildEntitiesRandomly`.

### Design Notes
- Used for domain initialization scripts.
- The snippet references “entryEntities.add(entity).”

---

## 17) `CREATETESTENTRYENTITYRANDOMLY.MD`

### Function Overview
**`createTestEntryEntityRandomly`** is analogous to `createInitEntryEntityRandomly`, but tailored for test scenarios. It calls `setTestAttributesRandomly` instead of `setInitAttributesRandomly`.

```dart
String createTestEntryEntityRandomly(Concept entryConcept, {
  int? suffix, 
  bool withChildren = true, 
  model
})
```

### Parameters
- **`entryConcept`** (`Concept`), optional `suffix`, `withChildren`, and `model` references.

### Returns
- **`String`**: Dart code building the random entity for test usage.

### Example Usage
```dart
final snippet = createTestEntryEntityRandomly(myConcept, suffix: 2, model: myModel);
```

### Dependencies & Cross-references
- Uses `setTestAttributesRandomly` and `createChildEntitiesRandomly`.

### Design Notes
- Typically invoked by `createTestEntryEntitiesRandomly` to produce multiple random test entities.

---

## 18) `CREATECHILDENTITIESRANDOMLY.MD`

### Function Overview
**`createChildEntitiesRandomly`** recursively creates child entities inside a parent, including link-backs to the parent’s code.

```dart
String createChildEntitiesRandomly(
  String parentVar,
  String parentCode,
  Concept parentConcept,
  String childCode,
  Concept childConcept
)
```

### Parameters
- **`parentVar`**: The variable name of the parent entity.
- **`parentCode`**: The parent concept code property.
- **`parentConcept`** / **`childConcept`**: The metamodel `Concept`s.
- **`childCode`**: Name of the child relationship.

### Returns
- **`String`**: A code snippet that loops `CHILD_ENTITIES_COUNT` times, generating child entities with random data.

### Example Usage
*Internally used by other random creation methods, not typically called alone.*

### Dependencies & Cross-references
- Ties to `setInitAttributesRandomly`.

### Design Notes
- Provides nested random data generation to fill parent-child structures.

---

## 19) `SETINITATTRIBUTESRANDOMLY.MD`

### Function Overview
**`setInitAttributesRandomly`** appends code to set each attribute on an entity with random initial values (if `increment` is null).

```dart
String setInitAttributesRandomly(Concept concept, String entity)
```

### Parameters
- **`concept`**: The concept containing attributes.
- **`entity`**: The variable name for the entity.

### Returns
- **`String`**: A snippet like `..name = 'home' ..price = 384; ...`.

### Example Usage
```dart
final codeSegment = setInitAttributesRandomly(myConcept, 'myEntity');
```

### Dependencies & Cross-references
- Calls `genAttributeTextRandomly` for each attribute.

### Design Notes
- Helps build the chain of `..attribute = randomValue`.

---

## 20) `SETTESTATTRIBUTESRANDOMLY.MD`

### Function Overview
**`setTestAttributesRandomly`** parallels `setInitAttributesRandomly` but specifically for test usage.

```dart
String setTestAttributesRandomly(Concept concept, String entity)
```

### Example Usage
```dart
final snippet = setTestAttributesRandomly(myConcept, 'testEntity');
```

### Design Notes
- Typically sets random data for testing scenarios, possibly ignoring increments or unique constraints differently from “init.”

---

## 21) `SETINITATTRIBUTERANDOMLY.MD`

### Function Overview
**`setInitAttributeRandomly`** handles a single attribute assignment for initialization (skipping increment logic if `increment` is set).

```dart
String setInitAttributeRandomly(Attribute attribute, String entity)
```

### Example Usage
```dart
final codeLine = setInitAttributeRandomly(myAttribute, 'myEntity');
```

### Design Notes
- A building block used by `setInitAttributesRandomly`.

---

## 22) `SETTESTATTRIBUTERANDOMLY.MD`

### Function Overview
**`setTestAttributeRandomly`** sets a single attribute with random test data, returning a partial code snippet.

```dart
String setTestAttributeRandomly(Attribute attribute, String entity)
```

### Example Usage
```dart
final line = setTestAttributeRandomly(attr, 'testEntity');
```

---

## 23) `GENATTRIBUTETEXTRANDOMLY.MD`

### Function Overview
**`genAttributeTextRandomly`** returns a literal (e.g. `'home'`, `123`, `Uri.parse('...')`) to represent a random Dart value for a given attribute type.

```dart
String genAttributeTextRandomly(Attribute attribute)
```

### Example Usage
```dart
final randomValueCode = genAttributeTextRandomly(stringAttribute); 
// e.g. "'cream'"
```

### Dependencies & Cross-references
- Invokes the random data methods in `random_data.dart`.

### Design Notes
- Switches on `attribute.type?.code` to produce relevant random data.

---

## 24) `RANDOMBOOL.MD`

### Function Overview
**`randomBool`** returns a random boolean using `dart:math`.

```dart
bool randomBool()
```

### Example Usage
```dart
final b = randomBool(); // e.g. true or false
```

### Design Notes
- Basic wrapper around `Random().nextBool()`.

---

## 25) `RANDOMDOUBLE.MD`

### Function Overview
**`randomDouble`** returns a random double in `[0, max)`.

```dart
double randomDouble(num max)
```

### Parameters
- `max`: upper bound

### Example Usage
```dart
final d = randomDouble(100); // e.g. 73.294...
```

---

## 26) `RANDOMINT.MD`

### Function Overview
**`randomInt`** returns a random integer in `[0, max)`.

```dart
int randomInt(int max)
```

### Example Usage
```dart
final i = randomInt(10); // e.g. 7
```

---

## 27) `RANDOMNUM.MD`

### Function Overview
**`randomNum`** returns either an int or a double, possibly negative, up to `max`.

```dart
num randomNum(int max)
```

### Example Usage
```dart
final n = randomNum(100); // e.g. -34 or 12.78
```

### Design Notes
- Incorporates `randomSign` to allow negative numbers.

---

## 28) `RANDOMSIGN.MD`

### Function Overview
**`randomSign`** sometimes returns `-1`, else `1`, used to produce negative values randomly.

```dart
int randomSign()
```

### Example Usage
```dart
final sign = randomSign(); // 1 or -1
```

---

## 29) `RANDOMWORD.MD`

### Function Overview
**`randomWord`** picks a random string from `wordList`.

```dart
String randomWord()
```

### Example Usage
```dart
final w = randomWord(); // e.g. "coffee"
```

### Design Notes
- `wordList` is a large static list of strings.

---

## 30) `RANDOMURI.MD`

### Function Overview
**`randomUri`** picks a random string from `uriList`.

```dart
String randomUri()
```

### Example Usage
```dart
final uri = randomUri(); // e.g. "http://www.dartlang.org/"
```

---

## 31) `RANDOMEMAIL.MD`

### Function Overview
**`randomEmail`** returns a random email address from an internal `emailList`.

```dart
String randomEmail()
```

### Example Usage
```dart
print(randomEmail()); // e.g. "mike@garcia.com"
```

---

## 32) `RANDOMLISTELEMENT.MD`

### Function Overview
**`randomListElement`** picks a random element from any given `List`.

```dart
dynamic randomListElement(List list)
```

### Example Usage
```dart
final chosen = randomListElement(['apple','banana','cherry']);
```

### Dependencies & Cross-references
- Underpins the more specialized random functions (e.g. `randomWord`).

---

## 33) `FINDNONIDATTRIBUTE.MD`

### Function Overview
**`findNonIdAttribute`** searches a `Concept` for the first attribute that is **not** an identifier.

```dart
Attribute? findNonIdAttribute(Concept concept)
```

### Example Usage
```dart
final nonId = findNonIdAttribute(myConcept);
if (nonId != null) {
  print('Found a non-ID attribute named ${nonId.code}');
}
```

---

## 34) `FINDNONREQUIREDATTRIBUTE.MD`

### Function Overview
**`findNonRequiredAttribute`** returns the first attribute in a `Concept` that is not marked `required`.

```dart
Attribute? findNonRequiredAttribute(Concept concept)
```

### Example Usage
```dart
final optionalAttr = findNonRequiredAttribute(myConcept);
```

---

## 35) `FINDREQUIREDNONIDATTRIBUTE.MD`

### Function Overview
**`findRequiredNonIdAttribute`** returns the first attribute that is `required` but not an identifier.

```dart
Attribute? findRequiredNonIdAttribute(Concept concept)
```

### Example Usage
```dart
final mustHave = findRequiredNonIdAttribute(myConcept);
```

---

## 36) `FINDIDATTRIBUTE.MD`

### Function Overview
**`findIdAttribute`** finds the first attribute that has `identifier == true`.

```dart
Attribute? findIdAttribute(Concept concept)
```

### Example Usage
```dart
final idAttr = findIdAttribute(myConcept);
```

---

## 37) `STRINGEXTENSION.MD`

### Class/Artifact Overview
**`StringExtension`** is a Dart extension on `String`, providing a single method `capitalize()`.

```dart
extension StringExtension on String {
  String capitalize() => ...
}
```

### Methods

#### `String capitalize()`
- **Description**: Returns a new string with the first character uppercase, if possible, leaving the rest unchanged.
- **Example**:
  ```dart
  final s = 'hello'.capitalize(); // "Hello"
  ```

### Dependencies & Cross-references
- Standalone extension, not deeply integrated with other EDNet parts.

### Design Notes
- Utility for code-generation or naming transformations.
- Only present in `ednet_model_specific.dart`.



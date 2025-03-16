## `[BOUNDED_CONTEXT_MAP].MD`

### Class/Artifact Overview
`BoundedContextMap` manages a collection of `BoundedContext` instances. It extends a generic `Entities<BoundedContext>` class to store, add, and remove contexts from an internal collection.

### Properties/Fields
- Inherits all properties from `Entities<BoundedContext>`.

### Constructors
- **Implicit default constructor**: Provided automatically by Dart. Typically called internally by domain code that manages sets of contexts.

### Methods

#### `void addContext(BoundedContext context)`
- **Parameters**
    - `context`: The `BoundedContext` instance to add.
- **Returns**: Nothing (void).
- **Description**: Adds a new bounded context to this collection.
- **Throws**: Potential domain or validation exceptions if constraints are violated.
- **Side Effects**: May notify EDNet domain observers about the newly added context.

#### `void removeContext(BoundedContext context)`
- **Parameters**
    - `context`: The `BoundedContext` instance to remove.
- **Returns**: Nothing (void).
- **Description**: Removes the specified bounded context from the collection.

### Example Usage
```dart
void main() {
  final contexts = BoundedContextMap();
  final bc1 = BoundedContext(name: 'ContextA', domains: Domains());
  contexts.addContext(bc1);
  
  // ...
  contexts.removeContext(bc1);
}
```

### Dependencies & Cross-references
- **Extends**: `Entities<BoundedContext>`
- **Uses**: `BoundedContext`
- **Part of**: The domain/bounded-context sub-module.

### Design Notes
- Designed to keep bounded contexts in a strongly-typed collection, ensuring consistent domain-level operations.
- In a larger DDD architecture, a `BoundedContextMap` is often used to discover or iterate over contexts that make up a system.

---

## `[BOUNDED_CONTEXT].MD`

### Class/Artifact Overview
`BoundedContext` represents a strategic bounded context in domain-driven design. It extends `Entity<BoundedContext>`, adding properties for context name and the associated `Domains`.

### Properties/Fields

| **Name**    | **Type**         | **Description**                                       |
|-------------|------------------|-------------------------------------------------------|
| `name`      | `String`         | The name that identifies this bounded context.       |
| `domains`   | `Domains`        | Aggregates domain definitions within this context.   |
| `contexts`  | `dynamic` (getter)| Placeholder (returns `null` in the source).          |

> All other state/behavior is inherited from `Entity<BoundedContext>`.

### Constructors

```dart
BoundedContext({required this.name, required this.domains});
```
- **Parameters**:
    - `name`: The context’s name.
    - `domains`: The collection of domain definitions that belong to this bounded context.
- **Behavior**: Sets the final fields. The `contexts` getter is not yet implemented.

### Methods
- Inherits all default entity behaviors (`setAttribute`, `getAttribute`, `toJson`, etc.) from `Entity<BoundedContext>`.
- Has a trivial `get contexts => null;` placeholder.

### Example Usage
```dart
void main() {
  final myDomains = Domains();
  // ... populate domains ...
  final bc = BoundedContext(name: 'UserManagement', domains: myDomains);

  print(bc.name); // "UserManagement"
  // bc.setAttribute(...) inherited from Entity
}
```

### Dependencies & Cross-references
- **Extends**: `Entity<BoundedContext>` (see `ENTITY.MD`)
- **Uses**: `Domains` (provided by EDNet’s domain or meta-model layer)
- Could be integrated with `BoundedContextMap` for collection management.

### Design Notes
- Central artifact in domain-driven design, grouping `Domains` under a single logical boundary.

---

## `[APPLICATION].MD`

### Class/Artifact Overview
`Application` is a simple marker-type `Entity<Application>` representing a high-level application within the domain. Minimal logic is provided in the snippet.

### Properties/Fields
- Inherits state from `Entity<Application>`.

### Constructors
- **Implicit**: No custom constructor is shown; it is default-provided by Dart.

### Methods
- All inherited from `Entity<Application>`.

### Example Usage
```dart
void main() {
  final app = Application();
  app.code = 'MyApp';
  print(app.code);
}
```

### Dependencies & Cross-references
- **Extends**: `Entity<Application>`
- Often aggregated into `Applications` (see `APPLICATIONS.MD`).

### Design Notes
- This class is intentionally minimal; typically, real logic is introduced via domain or model expansions for each specific application.

---

## `[APPLICATIONS].MD`

### Class/Artifact Overview
`Applications` is a collection of `Application` objects. It extends `Entities<Application>` and provides a domain-typed container.

### Properties/Fields
- Inherits collection logic from `Entities<Application>`.

### Constructors
- **Implicit**: The default constructor is used, typically invoked within the domain modeling layer.

### Methods
- Inherits `add`, `remove`, `contains`, etc., from `Entities<Application>`.

### Example Usage
```dart
void main() {
  final apps = Applications();
  apps.add(Application()..code = 'AppA');
  apps.add(Application()..code = 'AppB');
  
  print(apps.length); // 2
}
```

### Dependencies & Cross-references
- **Extends**: `Entities<Application>`
- **Uses**: `Application`

### Design Notes
- Maintains strong typing for a collection of domain-defined “Application” entities.

---

## `[BOUNDED_CONTEXT_RELATION_TYPE].MD`

### Enum Overview
`BoundedContextRelationType` enumerates known relationship types among bounded contexts in a strategic DDD sense.

### Values
- `PUBLISHER_SUBSCRIBER`
- `PARTNERS`
- `SHARED_KERNEL`
- `CUSTOMER_SUPPLIER`
- `CONFORMIST`
- `ANTICORRUPTION_LAYER`
- `OPEN_HOST_SERVICE`
- `PUBLISHED_LANGUAGE`
- `SEPARATE_WAYS`
- `BIG_BALL_OF_MUD`

### Example Usage
```dart
void main() {
  var relationType = BoundedContextRelationType.PUBLISHER_SUBSCRIBER;
  print(relationType); // "BoundedContextRelationType.PUBLISHER_SUBSCRIBER"
}
```

### Dependencies & Cross-references
- Used by `IBoundedContextRelation` (see `IBOUNDED_CONTEXT_RELATION.MD`).

### Design Notes
- Aligns with standard DDD bounded context relationship patterns (per Eric Evans and Vaughn Vernon).

---

## `[I_BOUNDED_CONTEXT_RELATION].MD`

### Interface Overview
`IBoundedContextRelation` describes a relation between two bounded contexts, providing a `type`, `source`, `target`, and a `register` method.

### Properties/Fields
- **`type`**: A `BoundedContextRelationType` describing how contexts relate.
- **`source`**: The origin `BoundedContext`.
- **`target`**: The target `BoundedContext`.

### Methods

#### `void register()`
- Registers or finalizes the relation in the domain. Implementation specifics vary by concrete subclass.

### Example Usage
```dart
class CustomRelation implements IBoundedContextRelation {
  @override
  BoundedContextRelationType get type => BoundedContextRelationType.PARTNERS;
  
  @override
  BoundedContext get source => myBoundedContext1;

  @override
  BoundedContext get target => myBoundedContext2;

  @override
  void register() {
    print('Registering Partners Relationship');
  }
}
```

### Dependencies & Cross-references
- **Uses**: `BoundedContext`, `BoundedContextRelationType`
- **Implemented by**: `PublisherSubscriberRelation` in this code base.

### Design Notes
- Interface for all bounded-context relationship patterns; fosters extensibility for additional relation types.

---

## `[PUBLISHER_SUBSCRIBER_RELATION].MD`

### Class/Artifact Overview
`PublisherSubscriberRelation` implements `IBoundedContextRelation` using the `PUBLISHER_SUBSCRIBER` type. In the snippet, `source` and `target` are unimplemented placeholders (throwing `UnimplementedError`).

### Properties/Fields
- **type**: Returns `BoundedContextRelationType.PUBLISHER_SUBSCRIBER`.
- **source / target**: Currently throw `UnimplementedError`.

### Constructors
- **Implicit**: No explicit constructor defined; uses Dart’s default.

### Methods

#### `BoundedContextRelationType get type`
- Returns `BoundedContextRelationType.PUBLISHER_SUBSCRIBER`.

#### `void register()`
- Currently an empty implementation. Typically used to finalize or persist the relationship.

### Example Usage
```dart
void main() {
  final relation = PublisherSubscriberRelation();
  print(relation.type); // "BoundedContextRelationType.PUBLISHER_SUBSCRIBER"
  relation.register(); // Does nothing in default implementation
}
```

### Dependencies & Cross-references
- **Implements**: `IBoundedContextRelation`.
- **Uses**: `BoundedContextRelationType`.

### Design Notes
- Example reference implementation. In a real system, you would override `source`/`target` to return actual `BoundedContext` instances or rely on constructor injection.

---

## `[CRITERIA].MD`

### Class/Artifact Overview
`Criteria<T>` encapsulates query filtering, pagination, and sorting logic for retrieving entities in a domain. It can hold multiple `Criterion` objects, combining them with logical operands.

### Properties/Fields

| **Name**           | **Type**          | **Description**                                                                           |
|--------------------|-------------------|-------------------------------------------------------------------------------------------|
| `chainingOperand`  | `Operand`         | Logical operand (`AND`, `OR`) used to combine multiple sets of criteria.                  |
| `innerOperand`     | `Operand`         | Nested operand used within each subset of criteria.                                       |
| `criteria`         | `List<Criterion>` | The actual list of individual criteria.                                                  |
| `limit`            | `int`             | Max number of items to retrieve (0 indicates no limit).                                   |
| `skip`             | `int`             | Number of items to skip before retrieving.                                               |
| `sortOrder`        | `SortOrder`       | Specifies ascending or descending ordering.                                              |
| `sortAttribute`    | `String`          | Attribute to sort on.                                                                    |
| `currentPage`      | `int`             | Index of the current page (starting at 1).                                               |
| `pageSize`         | `int`             | Number of items per page.                                                                |

### Constructors

```dart
Criteria({
  this.chainingOperand = Operand.AND,
  this.innerOperand = Operand.AND,
  this.criteria = const [],
  this.limit = 0,
  this.skip = 0,
  this.sortOrder = SortOrder.ASCENDING,
  this.sortAttribute = 'id',
  this.currentPage = 1,
  this.pageSize = 10,
});
```

- Assigns default values to all fields.

### Methods

#### `void addCriterion(Criterion criterion)`
- Adds a new filter criterion to the `criteria` list.

#### `Criteria getNextPageCriteria()`
- Returns a new `Criteria` object, advanced to the next page based on `pageSize` and `currentPage`.

#### `Criteria getPreviousPageCriteria()`
- Returns a new `Criteria` object, moved back one page.

_See source for additional set/remove/clear methods on the underlying `criteria` list._

### Example Usage
```dart
void main() {
  final crit = Criteria<Person>()
    ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
    ..setLimit(100);

  final nextPage = crit.getNextPageCriteria();
  print(nextPage.skip); // e.g., 10 if pageSize=10
}
```

### Dependencies & Cross-references
- **Uses**: `Criterion`, `Operand`, `SortOrder`
- Potentially used by repositories or query engines in EDNet to fetch filtered records.

### Design Notes
- A flexible, chainable object for specifying queries, which can be extended for more advanced filtering logic (e.g., sub-criteria groups).

---

## `[CRITERION].MD`

### Class/Artifact Overview
`Criterion` represents a single condition (attribute + operand + value) within a `Criteria` object.

### Properties/Fields

| **Name**     | **Type**   | **Description**                                          |
|--------------|------------|----------------------------------------------------------|
| `attribute`  | `String`   | The attribute name (e.g., "age", "status").             |
| `operand`    | `Operand`  | Operator (e.g., EQUAL, GREATER_THAN).                   |
| `value`      | `dynamic`  | The value to compare with (could be `int`, `String`, etc.). |

### Constructors

```dart
Criterion(this.attribute, this.operand, this.value);
```
- **Parameters**: `attribute`, `operand`, `value`.

### Methods
- No additional methods; used primarily as a data holder.

### Example Usage
```dart
void main() {
  final c = Criterion('status', Operand.EQUAL, 'ACTIVE');
  // Typically added to a Criteria instance
}
```

### Dependencies & Cross-references
- **Used by**: `Criteria` to build multi-part queries.
- **Uses**: `Operand`.

### Design Notes
- Keeps filtering logic straightforward and decoupled from the repository layer.
- Attaches no side effects; purely a value object.

---

## `[OPERAND].MD`

### Class/Artifact Overview
`Operand` encapsulates an operator type in a query or expression context. It wraps an `OperandType` and provides common static constants (`EQUAL`, `GREATER_THAN`, etc.).

### Properties/Fields
- **`operandType`**: An `OperandType` enumeration object describing the operator’s semantics.

### Static Constants
- `Operand.EQUAL`
- `Operand.GREATER_THAN`
- `Operand.LESS_THAN`
- `Operand.SORT`
- `Operand.LIMIT`
- `Operand.SKIP`
- `Operand.AND`
- `Operand.OR`

### Constructors
```dart
const Operand(this.operandType);
```
- Usually used via one of its static constants.

### Methods
- Inherits `==` operator and `hashCode` from `Object`.
- No additional methods in the snippet.

### Example Usage
```dart
void main() {
  var op = Operand.EQUAL;
  print(op.operandType.value); // "EQUAL"
}
```

### Dependencies & Cross-references
- **Uses**: `OperandType`.
- Referenced in `Criterion` and `Criteria`.

### Design Notes
- Encourages a strongly typed approach to query operands rather than raw strings.

---

## `[OPERAND_TYPE].MD`

### Class/Artifact Overview
`OperandType` is an enum-like class holding a `String value` (e.g. "EQUAL", "GREATER_THAN", etc.). Each static constant is a unique instance.

### Static Constants
- `OperandType.EQUAL`
- `OperandType.GREATER_THAN`
- `OperandType.LESS_THAN`
- `OperandType.SORT`
- `OperandType.LIMIT`
- `OperandType.SKIP`
- `OperandType.AND`
- `OperandType.OR`

### Properties/Fields
- `value` (`String`): Descriptive name or code for the operand type.

### Constructors
```dart
const OperandType(this.value);
```

### Example Usage
```dart
void main() {
  var t = OperandType.EQUAL;
  print(t.value); // "EQUAL"
}
```

### Dependencies & Cross-references
- **Used by**: `Operand`.

### Design Notes
- Acts as a lightweight alternative to a standard Dart `enum`, providing extended flexibility for expansions or reflection.

---

## `[SORT_ORDER].MD`

### Class/Artifact Overview
`SortOrder` represents ascending or descending sorting.

### Static Constants
- `SortOrder.ASCENDING` => `'ASCENDING'`
- `SortOrder.DESCENDING` => `'DESCENDING'`

### Properties
- `value` (`String`): "ASCENDING" or "DESCENDING"

### Constructors
```dart
const SortOrder(this.value);
```

### Example Usage
```dart
void main() {
  final order = SortOrder.DESCENDING;
  print(order.value); // "DESCENDING"
}
```

### Dependencies & Cross-references
- **Used by**: `Criteria`.
- Another enum-like class with string values.

### Design Notes
- Similar to `OperandType`, it’s implemented as a class with static constant instances.

---

## `[SERIALIZABLE].MD`

### Mixin Overview
`Serializable` is a mixin that provides a `toJson()` method contract and a static `fromJson(...)` stub.

### Methods

#### `Map<String, dynamic> toJson();`
- Must be implemented by any class using the mixin.

#### `static fromJson(Map<String, dynamic> json)`
- A placeholder function. Implementation details are left to the final class.

### Example Usage
```dart
class MyEntity with Serializable {
  @override
  Map<String, dynamic> toJson() {
    return {'example': 'data'};
  }
}

void main() {
  final e = MyEntity();
  print(e.toJson()); // {example: data}
}
```

### Dependencies & Cross-references
- Stand-alone mixin, can be applied to any entity or data class.

### Design Notes
- Encourages a consistent approach to JSON serialization across domain objects.

---

## `[DOMAIN_MODELS].MD`

### Class/Artifact Overview
`DomainModels` implements `IDomainModels`, providing a container for multiple model entries (`ModelEntries`) in a single domain. It can store references to various models, handle sessions, and manage command reactions.

### Properties/Fields

| **Name**           | **Type**         | **Description**                                                                                    |
|--------------------|------------------|----------------------------------------------------------------------------------------------------|
| `_domain`          | `Domain`         | The domain this container belongs to.                                                              |
| `_modelEntriesMap` | `Map<String, ModelEntries>` | Maps model codes to their `ModelEntries`.                                                           |
| `_actionReactions` | `List<ICommandReaction>`     | Holds any registered `ICommandReaction` objects that respond when commands execute.                |

### Constructors
```dart
DomainModels(this._domain)
  : _modelEntriesMap = <String, ModelEntries>{},
    _actionReactions = <ICommandReaction>[];
```

### Methods

- **`void addModelEntries(ModelEntries modelEntries)`**  
  Validates matching domain codes and inserts new `modelEntries` into `_modelEntriesMap`.

- **`Model? getModel(String modelCode)`**  
  Delegates to `_domain.getModel(...)`.

- **`ModelEntries? getModelEntries(String modelCode)`**  
  Returns the stored `ModelEntries` for the given code.

- **`DomainSession newSession()`**  
  Creates a new domain session (`DomainSession`) bound to this `DomainModels`.

- **`void startCommandReaction(ICommandReaction reaction)`**  
  Registers a reaction that will be triggered whenever a command is completed.

- **`void cancelCommandReaction(ICommandReaction reaction)`**  
  Removes a previously registered reaction.

- **`void add(IModelEntries modelEntries)`**  
  Satisfies `IDomainModels` interface—delegates to `addModelEntries`.

- **`void notifyCommandReactions(ICommand action)`**  
  Calls `react(action)` on each `ICommandReaction` in `_actionReactions`.

### Example Usage
```dart
void main() {
  final domain = Domain('MyDomain'); // hypothetical
  final domainModels = DomainModels(domain);

  final someModelEntries = SomeModelEntries(...);
  domainModels.addModelEntries(someModelEntries);

  final session = domainModels.newSession();
  // session usage ...
}
```

### Dependencies & Cross-references
- **Implements**: `IDomainModels`
- **Uses**: `Domain`, `ModelEntries`, `ICommandReaction`, `DomainSession`

### Design Notes
- Core aggregator for model-level data and behaviors.
- Reactions mechanism allows a domain-driven approach to respond to completed commands.

---

## `[I_DOMAIN_MODELS].MD`

### Interface Overview
`IDomainModels` defines methods to manage multiple `IModelEntries`, retrieve the domain, start new sessions, and handle command reactions.

### Methods

- `void add(IModelEntries modelEntries);`
- `Domain get domain;`
- `Model? getModel(String modelCode);`
- `IModelEntries? getModelEntries(String modelCode);`
- `IDomainSession newSession();`
- `void startCommandReaction(ICommandReaction reaction);`
- `void cancelCommandReaction(ICommandReaction reaction);`
- `void notifyCommandReactions(ICommand action);`

### Example Usage
```dart
void initializeDomain(IDomainModels dm) {
  final entries = SomeModelEntries();
  dm.add(entries);
  final session = dm.newSession();
  // ...
}
```

### Dependencies & Cross-references
- **Extended by**: `DomainModels`
- Ties the domain’s data storage, session lifecycle, and reactive command system together.

### Design Notes
- Ensures a consistent contract for any “domain models” container or aggregator.

---

## `[AGGREGATE_ROOT].MD`

### Class/Artifact Overview
`AggregateRoot` is an abstract class extending `Entity<AggregateRoot>`. It marks an entity that can serve as the root of an aggregate in DDD.

### Properties/Fields
- Inherits from `Entity<AggregateRoot>`.

### Constructors
- **Abstract**: Cannot be instantiated directly; used as a base for domain aggregates.

### Example Usage
```dart
class Order extends AggregateRoot {
  // ...
}

void main() {
  final order = Order();
  // ...
}
```

### Dependencies & Cross-references
- **Extends**: `Entity<AggregateRoot>`
- Common DDD pattern for grouping related entities under a single root entity.

### Design Notes
- Aggregates ensure a transactional consistency boundary. This class formalizes the concept in EDNet code.

---

## `[ADD_COMMAND].MD`

### Class/Artifact Overview
`AddCommand` extends `IEntitiesCommand` to handle the addition of an entity to a collection.

### Properties/Fields
- Inherits from `IEntitiesCommand`, which includes `name`, `entities`, `entity`, and command state tracking.

### Constructors
```dart
AddCommand(
  DomainSession session,
  Entities entities,
  Entity entity
) : super('add', session, entities, entity) {
  category = 'entity';
}
```

- Sets command name to `"add"`, category to `"entity"`.

### Methods
- Inherits `doIt()`, `undo()`, `redo()` from `IEntitiesCommand`:
    - `doIt()` => calls `entities.add(entity)`
    - `undo()` => calls `entities.remove(entity)`
    - `redo()` => calls `entities.add(entity)` again

### Example Usage
```dart
void main() {
  final session = DomainSession(...);
  final people = People(); // extends Entities
  final person = Person()..code = 'P001';

  final addCmd = AddCommand(session, people, person);
  addCmd.doIt();  // adds 'person' to 'people'
}
```

### Dependencies & Cross-references
- **Extends**: `IEntitiesCommand`
- **Uses**: `DomainSession`, `Entities`, `Entity`, `ICommand`

### Design Notes
- Part of the command pattern in EDNet, ensuring consistent add/remove transaction logic.

---

## `[I_BASIC_COMMAND].MD`

### Class/Artifact Overview
`IBasicCommand` is an abstract class implementing `ICommand`. It provides core fields (`name`, `category`, `description`, `state`) and basic command lifecycle checks (`started`, `done`, `undone`, `redone`).

### Properties/Fields

| **Name**           | **Type**      | **Description**                                            |
|--------------------|---------------|------------------------------------------------------------|
| `name`             | `String`      | Command name, e.g. `"add"`, `"remove"`, `"set"`.           |
| `category`         | `String`      | Further classification (e.g., `"entity"`, `"attribute"`).  |
| `state`            | `String`      | Tracks command progression: `"started"`, `"done"`, etc.    |
| `description`      | `String`      | Command description.                                       |
| `session`          | `DomainSession` | The domain session executing this command.               |
| `partOfTransaction`| `bool`        | Whether it’s included in a transaction.                    |
| `events`           | `List<Event>` | Domain events triggered by command lifecycle.              |

### Constructors
```dart
IBasicCommand(
  this.name,
  this.session, {
  this.description = 'Basic command',
});
```
- Sets default `description`.

### Methods

| **Name**   | **Return** | **Description**                                                                                  |
|------------|-----------|--------------------------------------------------------------------------------------------------|
| `bool doIt()`   | `bool`  | Abstract - do the main action.                                                                 |
| `bool undo()`   | `bool`  | Abstract - revert the main action.                                                             |
| `bool redo()`   | `bool`  | Abstract - reapply the main action after an undo.                                              |
| `getEvents()`   | `List<Event>` | Return any events triggered by this command.                                              |
| `display()`     | `void`  | Simple console print for debugging.                                                            |

Also includes checks for `started`, `done`, `undone`, `redone`.

### Example Usage
```dart
class CustomCommand extends IBasicCommand {
  CustomCommand(DomainSession session)
      : super('custom', session, description: 'Custom action');

  @override
  bool doIt() {
    if (state == 'started') {
      // ... do something ...
      state = 'done';
      return true;
    }
    return false;
  }

  // override undo(), redo(), etc.
}
```

### Dependencies & Cross-references
- **Implements**: `ICommand`
- **Used by**: `IEntitiesCommand`, `IEntityCommand`, `Transaction`

### Design Notes
- Central base class for implementing EDNet’s command architecture.
- Encourages consistent naming, categorization, and result tracking.

---

## `[I_COMMAND].MD`

### Interface Overview
`ICommand` defines the minimal contract for a command in the EDNet domain-driven approach.

### Properties/Fields
- **name**, **category**, **description**
- **successEvent**, **failureEvent**
- State checks: **done**, **undone**, **redone**

### Methods
- `bool doIt()`
- `bool undo()`
- `bool redo()`
- `List<Event> getEvents()`

### Example Usage
```dart
void process(ICommand command) {
  if (command.doIt()) {
    print('${command.name} done');
  }
}
```

### Dependencies & Cross-references
- **Implemented by**: `IBasicCommand` (and its subclasses)
- **Used by**: The domain session and the Past/transaction mechanism.

### Design Notes
- Foundation of the command pattern in EDNet, enabling consistent undo/redo semantics.

---

## `[I_ENTITIES_COMMAND].MD`

### Class/Artifact Overview
`IEntitiesCommand` extends `IBasicCommand` to handle commands that operate on an `Entities` collection (adding or removing entities).

### Properties/Fields

| **Name**     | **Type**     | **Description**                                                      |
|--------------|-------------|-----------------------------------------------------------------------|
| `entities`   | `Entities`   | The collection on which the command operates.                        |
| `entity`     | `Entity`     | The entity to be added or removed.                                   |

### Constructors
```dart
IEntitiesCommand(
  String name,
  DomainSession session,
  this.entities,
  this.entity
) : super(name, session);
```

### Methods

- **`doIt()`**
    - If `name == 'add'`, calls `entities.add(entity)`.
    - If `name == 'remove'`, calls `entities.remove(entity)`.
    - Otherwise throws `CommandException`.
- **`undo()`**
    - Reverse of `doIt()`: remove if added, add if removed.
- **`redo()`**
    - Re-applies the original `doIt()` logic.

### Example Usage
```dart
final addCmd = AddCommand(session, people, newPerson);
addCmd.doIt(); // adds newPerson to people
```

### Dependencies & Cross-references
- **Extends**: `IBasicCommand`
- **Used by**: `AddCommand`, `RemoveCommand`

### Design Notes
- Abstract logic for any command operating on collections of entities in the domain.

---

## `[I_ENTITY_COMMAND].MD`

### Class/Artifact Overview
`IEntityCommand` extends `IBasicCommand` for commands dealing with a single entity’s property (attribute, parent, or child).

### Properties/Fields
- `entity`: The target entity.
- `property`: The property name to set.
- `before`: The value of the property before the command.
- `after`: The value to set.

### Constructors
```dart
IEntityCommand(
  DomainSession session,
  this.entity,
  this.property,
  this.after
) : before = entity.getAttribute(property),
    super('set', session);
```
- By default, `name = 'set'`.

### Methods

- **`doIt()`**
    - If `category == 'attribute'`, calls `entity.setAttribute(...)`.
    - If `category == 'parent'`, calls `entity.setParent(...)`.
    - If `category == 'child'`, calls `entity.setChild(...)`.
- **`undo()`** and **`redo()`**
    - Reverse and reapply the property set.

### Example Usage
```dart
void main() {
  final person = Person()..setAttribute('age', 30);
  final session = DomainSession(...);
  final command = SetAttributeCommand(session, person, 'age', 31);

  command.doIt(); // sets 'age' to 31
  command.undo(); // reverts to 30
}
```

### Dependencies & Cross-references
- **Extends**: `IBasicCommand`
- Concrete classes: `SetAttributeCommand`, `SetParentCommand`, `SetChildCommand`.

### Design Notes
- Standard approach to track changes on a single property at a time with full undo/redo support.

---

## `[I_TRANSACTION].MD`

### Interface Overview
`ITransaction` extends `ICommand` to represent a group of commands executed as a single atomic unit. It adds:
- `void add(ICommand command);`
- `IPast get past;`

### Example Usage
```dart
class CustomTransaction extends IBasicCommand implements ITransaction {
  // ...
  @override
  void add(ICommand command) => ...;
  @override
  IPast get past => ...;
}
```

### Dependencies & Cross-references
- **Implemented by**: `Transaction`

### Design Notes
- Transactions group multiple commands into a single do/undo/redo cycle.

---

## `[REMOVE_COMMAND].MD`

### Class/Artifact Overview
`RemoveCommand` extends `IEntitiesCommand` for removing an entity from a collection.

### Properties/Fields
- Inherits from `IEntitiesCommand`.

### Constructors
```dart
RemoveCommand(
  DomainSession session,
  Entities entities,
  Entity entity
) : super('remove', session, entities, entity) {
  category = 'entity';
}
```

### Methods
- `doIt()` => calls `entities.remove(entity)`.
- `undo()` => adds it back.
- `redo()` => removes again.

### Example Usage
```dart
void main() {
  final removeCmd = RemoveCommand(session, people, personToRemove);
  removeCmd.doIt();
}
```

### Dependencies & Cross-references
- **Extends**: `IEntitiesCommand`
- Complements `AddCommand`.

### Design Notes
- Mirrors `AddCommand` logic for removal.

---

## `[SET_ATTRIBUTE_COMMAND].MD`

### Class/Artifact Overview
`SetAttributeCommand` extends `IEntityCommand` specifically for updating an entity’s attribute (`category = 'attribute'`).

### Constructors
```dart
SetAttributeCommand(
  DomainSession session,
  Entity entity,
  String property,
  Object after
) : super(session, entity, property, after) {
  category = 'attribute';
}
```

### Methods
- `doIt()`, `undo()`, `redo()` => use standard logic from `IEntityCommand`.

### Example Usage
```dart
void main() {
  final cmd = SetAttributeCommand(session, myEntity, 'title', 'New Title');
  cmd.doIt();
}
```

### Dependencies & Cross-references
- **Extends**: `IEntityCommand`

### Design Notes
- Specialized for setting a single attribute, which is the most common property update scenario.

---

## `[SET_CHILD_COMMAND].MD`

### Class/Artifact Overview
`SetChildCommand` extends `IEntityCommand` for modifying child relationships of an entity.

### Constructors
```dart
SetChildCommand(
  DomainSession session,
  Entity entity,
  String property,
  Object after
) : super(session, entity, property, after) {
  category = 'child';
}
```

### Methods
- Follows the same pattern as `SetAttributeCommand`, but calls `entity.setChild(...)`.

### Example Usage
```dart
final cmd = SetChildCommand(session, parentEntity, 'items', childEntities);
cmd.doIt();
```

### Design Notes
- Used when reassigning or replacing a child collection within a parent entity.

---

## `[SET_PARENT_COMMAND].MD`

### Class/Artifact Overview
`SetParentCommand` extends `IEntityCommand` to change an entity’s parent reference.

### Constructors
```dart
SetParentCommand(
  DomainSession session,
  Entity entity,
  String property,
  Object after
) : super(session, entity, property, after) {
  category = 'parent';
}
```

### Methods
- Uses `entity.setParent(...)` under the hood.

### Example Usage
```dart
final cmd = SetParentCommand(session, childEntity, 'folder', newParentEntity);
cmd.doIt();
```

### Design Notes
- Key for re-parenting an entity to a different parent in hierarchical or composite relationships.

---

## `[TRANSACTION].MD`

### Class/Artifact Overview
`Transaction` extends `IBasicCommand` and implements `ITransaction`. It maintains a private `Past` of commands and executes them together.

### Properties/Fields
- `_commands` (`Past`): Manages the collection of sub-commands.
- `name`, `session`, `state`, etc. from `IBasicCommand`.

### Constructors
```dart
Transaction(String name, DomainSession session)
  : _commands = Past(),
    super(name, session);
```

### Methods

- **`add(ICommand command)`**: Adds a sub-command to `_commands`.
- **`doIt()`**:
    - Calls `_commands.doAll()`.
    - If successful, sets `state = 'done'` and notifies command reactions.
- **`undo()`**:
    - Calls `_commands.undoAll()`; sets `state = 'undone'`.
- **`redo()`**:
    - Calls `_commands.redoAll()`; sets `state = 'redone'`.

### Example Usage
```dart
void main() {
  final tx = Transaction('BulkOps', session);
  tx.add(AddCommand(session, people, personA));
  tx.add(AddCommand(session, people, personB));
  
  tx.doIt();   // adds both
  tx.undo();   // removes both
  tx.redo();   // adds both again
}
```

### Dependencies & Cross-references
- **Implements**: `ITransaction`
- **Uses**: `Past` to track internal commands.

### Design Notes
- Simplifies multi-step domain modifications with a single undo/redo boundary.

---

## `[FILTER_CRITERIA].MD`

### Class/Artifact Overview
`FilterCriteria` is a simpler or alternate approach to filtering, referencing a single attribute/operator/value.

### Properties

| **Name**      | **Type**   | **Description**                         |
|---------------|------------|-----------------------------------------|
| `attribute`   | `String`   | The attribute name to filter on.        |
| `operator`    | `String`   | Operator string (e.g., `">="`, `"=="`). |
| `value`       | `dynamic`  | The value to compare with.             |

### Constructors
```dart
FilterCriteria({
  required this.attribute,
  required this.operator,
  required this.value,
});
```

### Example Usage
```dart
final simpleFilter = FilterCriteria(
  attribute: 'status',
  operator: '==',
  value: 'active'
);
```

### Dependencies & Cross-references
- Standalone in the code snippet. Could be integrated with a repository or query engine.

### Design Notes
- Overlaps conceptually with `Criterion`; usage may depend on the developer’s preference or system needs.

---

## `[ENTITIES].MD`

### Class/Artifact Overview
`Entities<E extends Entity<E>>` manages a strongly-typed collection of `Entity<E>` objects. It implements `IEntities<E>` and provides extensive add/remove logic, validation, JSON serialization, and child-parent navigation.

### Properties/Fields

- `_concept` (`Concept?`): The metamodel concept describing these entities.
- `_entityList` (`List<E>`): The main storage of entities.
- `_oidEntityMap`, `_codeEntityMap`, `_idEntityMap`: Index structures for quick lookup by `oid`, `code`, or `id`.
- `exceptions` (`ValidationExceptions`): Collects validation errors.
- `source` (`Entities<E>?`): Optional reference to a source collection for propagation.

(Additionally: `pre`, `post`, `propagateToSource`, cardinality constraints, etc.)

### Constructors
- **Implicit**: Instantiates with empty lists and maps. Usually set `concept` afterwards.

### Key Methods

- **`bool add(E entity)`**
    - Validates, checks uniqueness, and adds to `_entityList`.
- **`bool remove(E entity)`**
    - Removes the entity if `preRemove` validations pass.
- **`E? singleWhereCode(String code)`**
    - Lookup by entity’s code.
- **`E? singleWhereOid(Oid oid)`**
    - Lookup by entity’s Oid.
- **`String toJson()`** / **`void fromJson(String entitiesJson)`**
    - Serialize/deserialize the entire set.

(Dozens of additional utility methods—select, skip, take, order, etc.)

### Example Usage
```dart
void main() {
  final people = Entities<Person>()..concept = personConcept;
  final alice = Person()..code = 'A001';
  people.add(alice);

  final found = people.singleWhereCode('A001');
  print(found?.code); // 'A001'

  final json = people.toJson();
  // ...
  people.fromJson(json); // re-load
}
```

### Dependencies & Cross-references
- **Implements**: `IEntities<E>`
- **Uses**: `Entity`, `Concept`, `ValidationExceptions`

### Design Notes
- A central data structure in EDNet for handling sets of domain entities.
- Built-in validation flow (`preAdd`, `postAdd`, etc.) aligns with the EDNet metamodel approach.

---

## `[ENTITY].MD`

### Class/Artifact Overview
`Entity<E extends Entity<E>>` is the fundamental unit of data in EDNet. It stores attributes, parent references, child collections, and policy evaluations.

### Properties/Fields

- `_concept` (`Concept?`): Points to the metamodel `Concept` describing this entity.
- `_oid` (`Oid`): Unique object identifier.
- `_code` (`String?`): Secondary human-friendly key.
- `_whenAdded`, `_whenSet`, `_whenRemoved` (`DateTime?`): Tracking life-cycle timestamps.
- `_attributeMap`, `_referenceMap`, `_parentMap`, `_childMap`, `_internalChildMap`: Internal data structures for entity state.
- `exceptions` (`ValidationExceptions`): Validation errors.

### Constructors
- **Implicit** default. Usually, you call `entity.concept = someConcept;` after creation to finalize initialization.

### Key Methods
- `getAttribute`, `setAttribute`
- `getParent`, `setParent`, `removeParent`
- `getChild`, `setChild`
- `toJson`, `fromJson`
- `copy()`: Deep copy of the entity.
- `display()`: Console debugging.
- `evaluatePolicies()`: Uses a `PolicyEvaluator` to check policy compliance (internally).

### Example Usage
```dart
void main() {
  final user = Entity<User>()..concept = userConcept;
  user.setAttribute('name', 'Alice');
  user.setParent('organization', orgEntity);
  
  print(user.getAttribute('name'));     // 'Alice'
  print(user.getParent('organization')); // orgEntity

  final userCopy = user.copy();
}
```

### Dependencies & Cross-references
- **Implements**: `IEntity<E>`
- **Used by**: `Entities`, `SetAttributeCommand`, etc.
- Relies heavily on meta-model elements (Attributes, Parents, Children) for structure.

### Design Notes
- The core building block: each `Entity` knows how to manage its own attribute data, relationships, and life-cycle events.
- The presence of policy evaluation logic allows domain-level constraints to be embedded.

---

## `[ID].MD`

### Class/Artifact Overview
`Id` implements `IId<Id>` to represent an entity identifier composed of parent references and attribute values flagged as identifiers in the metamodel.

### Properties/Fields
- `_concept` (`Concept`): The concept for this identifier.
- `_referenceMap`, `_attributeMap`: Maps for storing reference-based and attribute-based parts of the identifier.

### Constructors
```dart
Id(this._concept)
  : _referenceMap = <String, Reference?>{},
    _attributeMap = <String, Object?>{};
```

### Key Methods
- `setReference(...)`, `getReference(...)`
- `setAttribute(...)`, `getAttribute(...)`
- `bool equals(Id id)`: Checks if all reference/attribute parts match.
- `int compareTo(Id id)`: Orders IDs by references first, then by attributes.

### Example Usage
```dart
final myId = Id(userConcept);
myId.setAttribute('username', 'alice');
myId.setReference('tenant', Reference('12345', 'Tenant', 'Tenant'));
```

### Dependencies & Cross-references
- **Implements**: `IId<Id>`
- **Used by**: `Entity` for unique identification, `Entities` for indexing.

### Design Notes
- Composite IDs can combine multiple attributes and references, enabling multi-part uniqueness checks.

---

## `[I_ENTITIES].MD`

### Interface Overview
`IEntities<E extends IEntity<E>>` defines a read/write iterable collection of entity objects with specialized methods for domain logic (e.g. `selectWhere`, `toJson`, `validate`, etc.).

### Key Methods
- `bool add(E entity)`
- `bool remove(E entity)`
- `E? singleWhereOid(Oid oid)`
- `E? singleWhereCode(String code)`
- `String toJson()`
- `void fromJson(String entitiesJson)`
- etc.

### Example Usage
```dart
void manipulate(IEntities<Person> people) {
  final p = Person()..code = 'P101';
  people.add(p);
  // ...
}
```

### Dependencies & Cross-references
- **Implemented by**: `Entities<E>`

### Design Notes
- Ensures consistent collection-level functionality across all typed sets of entities.

---

## `[I_ENTITY].MD`

### Interface Overview
`IEntity<E extends IEntity<E>>` outlines the contract for any entity, including attribute/parent/child getters & setters, JSON serialization, etc.

### Key Methods
- `K? getAttribute<K>(String attributeCode)`
- `bool setAttribute(String name, Object? value)`
- `Object? getParent(String name)`
- `bool setParent(String name, entity)`
- `Object? getChild(String name)`
- `bool setChild(String name, Object entities)`
- `String toJson()`
- `void fromJson<K extends Entity<K>>(String entityJson)`

### Example Usage
```dart
void inspectEntity(IEntity e) {
  print(e.getAttribute('title'));
}
```

### Dependencies & Cross-references
- **Implemented by**: `Entity<E>`

### Design Notes
- Provides a uniform API for all domain entities, simplifying reflection, serialization, and domain logic.

---

## `[I_ID].MD`

### Interface Overview
`IId<T>` defines a typed identifier for an entity. It must:
- Provide parent references, attribute values, length, compare capabilities.

### Example Usage
```dart
void showId(IId id) {
  print('ID length: ${id.length}');
}
```

### Dependencies & Cross-references
- **Implemented by**: `Id`

### Design Notes
- Distinguishes an ID object from the rest of entity state, enabling composable unique identities.

---

## `[ERROR_EXCEPTIONS].MD`

*(Single combined file for all exceptions in `exceptions.dart`, given they are closely related and consistently used across the domain.)*

### Class/Artifact Overview
These exceptions extend `EDNetException` or implement `Exception` to provide specific error contexts within EDNet:

- **`EDNetException`**  
  Base for EDNet domain-level exceptions.

- **`CommandException`**  
  Thrown when issues occur in command execution.

- **`AddException`**  
  More specific command exception for add operations.

- **`CodeException`**  
  Reflects issues with codes or code-based uniqueness.

- **`ConceptException`**  
  Thrown when concept-related errors occur (e.g. invalid concept usage).

- **`IdException`**  
  For ID-related errors.

- **`JsonException`**  
  For JSON parse/format/structural problems.

- **`OidException`**  
  For problems with `Oid`.

- **`OrderException`**  
  For sorting or ordering issues in domain collections.

- **`ParentException`**  
  For invalid or missing parent references.

- **`RemoveException`**  
  For errors removing an entity from a collection.

- **`TypeException`**  
  For type mismatch problems (e.g. an attribute init expecting int but got a string).

- **`UpdateException`**  
  For failures to update an entity or property.

- **`ConceptError`**  
  Another specialized `CommandException`.

### Example Usage
```dart
try {
  entities.add(someEntity);
} on AddException catch(e) {
  print('Failed to add entity: ${e.message}');
}
```

### Dependencies & Cross-references
- **Extend**: `EDNetException` or `CommandException`
- **Used throughout**: `Entities`, `Entity`, commands, etc.

### Design Notes
- Provides fine-grained error handling within EDNet’s domain operations, clarifying root causes for domain-level failures.

---

## `[I_VALIDATION_EXCEPTIONS].MD`

### Interface Overview
`IValidationExceptions` captures a list of `ValidationException` instances, typically created when entity constraints are violated.

### Methods
- `int get length`
- `void add(ValidationException exception)`
- `void clear()`
- `List<ValidationException> toList()`

### Example Usage
```dart
void checkValidation(IValidationExceptions ex) {
  if (ex.length > 0) {
    for (var e in ex.toList()) {
      print(e.message);
    }
  }
}
```

### Dependencies & Cross-references
- **Implemented by**: `ValidationExceptions`
- **Uses**: `ValidationException`

### Design Notes
- Standard interface to store and iterate over multiple validation errors.

---

## `[VALIDATION_EXCEPTION].MD`

### Class/Artifact Overview
`ValidationException` is thrown to indicate a domain validation violation. It captures a category and a message.

### Properties/Fields
- `category` (`String`): The nature or grouping of the error (e.g. `"required"`, `"unique"`).
- `message` (`String`): Detailed description.

### Constructors
```dart
ValidationException(this.category, this.message)
```
- Prints the exception upon creation in the snippet.

### Example Usage
```dart
if (someRequiredField == null) {
  throw ValidationException('required', 'someRequiredField cannot be null.');
}
```

### Dependencies & Cross-references
- **Used by**: `ValidationExceptions`, `Entities.add()`, etc.

### Design Notes
- Synchronous way to handle invalid domain states. Typically aggregated in `ValidationExceptions`.

---

## `[VALIDATION_EXCEPTIONS].MD`

### Class/Artifact Overview
`ValidationExceptions` implements `IValidationExceptions`. It collects multiple `ValidationException` objects and provides iteration/clearing.

### Properties/Fields
- `_exceptionList` (`List<ValidationException>`)

### Methods
- `void add(ValidationException exception)`
- `int get length`
- `void clear()`
- `List<ValidationException> toList()`

### Example Usage
```dart
final vEx = ValidationExceptions();
vEx.add(ValidationException('unique', 'Value must be unique'));
if (vEx.length > 0) {
  // handle
}
```

### Dependencies & Cross-references
- **Implements**: `IValidationExceptions`
- **Uses**: `ValidationException`

### Design Notes
- One-stop container to gather all relevant validation problems during an operation.

---

## `[EVENT].MD`

### Class/Artifact Overview
`Event` is a domain event triggered by a command or other domain action.

### Properties/Fields
- `name`, `description`
- `handlers` (`List<String>`)
- `entity` (`Entity?`)
- `data` (`Map<String, dynamic>`)

### Constructors
- **Main**: `Event(this.name, this.description, this.handlers, this.entity, [this.data = const {}])`
- **SuccessEvent**, **FailureEvent**: Named constructors indicating success/failure results.

### Methods

#### `void trigger(DomainSession session)`
- Default logs `"session handler"` in the snippet.

### Example Usage
```dart
final evt = Event.SuccessEvent('AddUser', 'Added new user', [], userEntity);
evt.trigger(session);
```

### Dependencies & Cross-references
- Typically orchestrated by `ICommand` objects.

### Design Notes
- Minimal logic in the snippet; real usage could dispatch events to an event bus or domain event handler system.

---

## `[I_COMMAND_REACTION].MD`

### Interface Overview
`ICommandReaction` declares a single method, `void react(ICommand action)`, for responding to completed commands.

### Example Usage
```dart
class LogReaction implements ICommandReaction {
  @override
  void react(ICommand action) {
    print('Command finished: ${action.name}');
  }
}
```

### Dependencies & Cross-references
- **Used by**: `DomainModels` or `Past` to register observer-likes that react to commands.

### Design Notes
- Observer pattern for domain events: multiple reactions can be listening to command completions.

---

## `[I_PAST].MD`

### Interface Overview
`IPast` extends `ISourceOfPastReaction` and manages a historical list of `ICommand` objects with undo/redo capabilities.

### Methods
- `void add(ICommand command)`
- `bool doIt()`
- `bool undo()`
- `bool redo()`
- ...
- `List<ICommand> get commands`

### Dependencies & Cross-references
- **Implemented by**: `Past`

### Design Notes
- Allows chainable, user-driven undo/redo.
- Tied to the command pattern to preserve domain actions.

---

## `[I_PAST_COMMAND].MD`

### Interface Overview
`IPastCommand` is a reaction interface for the *past itself*, receiving notifications about `undo`/`redo` possibility changes.

### Methods
- `void reactCannotUndo()`
- `void reactCanUndo()`
- `void reactCanRedo()`
- `void reactCannotRedo()`

### Example Usage
```dart
class PastUI implements IPastCommand {
  @override
  void reactCanUndo() => print('Undo enabled');
  // ...
}
```

### Design Notes
- Another observer pattern: informs UI or other layers that undo/redo is (un)available.

---

## `[I_SOURCE_OF_COMMAND_REACTION].MD`

### Interface Overview
`ISourceOfCommandReaction` notifies registered `ICommandReaction` instances about command completions.

### Methods
- `void startCommandReaction(ICommandReaction reaction)`
- `void cancelCommandReaction(ICommandReaction reaction)`
- `void notifyCommandReactions(ICommand action)`

### Design Notes
- Typically implemented by domain-wide structures (e.g. `DomainModels`).

---

## `[I_SOURCE_OF_PAST_REACTION].MD`

### Interface Overview
`ISourceOfPastReaction` has methods to register or unregister `IPastCommand` observers and to notify them about undo/redo availability changes.

### Methods
- `void startPastReaction(IPastCommand reaction)`
- `void cancelPastReaction(IPastCommand reaction)`
- `void notifyCannotUndo()`
- `void notifyCanUndo()`
- `void notifyCanRedo()`
- `void notifyCannotRedo()`

### Design Notes
- Usually implemented by `Past`.

---

## `[PAST].MD`

### Class/Artifact Overview
`Past` implements `IPast`. It keeps a chronological list of `IBasicCommand` objects (`commands`), plus a `cursor` to track the current undo/redo state.

### Properties/Fields

| **Name**         | **Type**                 | **Description**                                     |
|------------------|--------------------------|-----------------------------------------------------|
| `commands`       | `List<IBasicCommand>`    | Full list of recorded commands.                     |
| `cursor`         | `int`                    | Current position for undo/redo.                    |
| `pastReactions`  | `List<IPastCommand>`     | Observers of undo/redo state changes.              |

### Key Methods
- **`add(ICommand action)`**: Inserts a command, trimming the redo stack if needed.
- **`doIt()`, `undo()`, `redo()`**: Moves the cursor forward/backward, calling each command’s `doIt()/undo()/redo()`.
- **`doAll()`, `undoAll()`, `redoAll()`**: Helper methods to run or revert everything in `commands`.
- **`startPastReaction(...)`, `cancelPastReaction(...)`**: Manage `IPastCommand` observers.

### Example Usage
```dart
void main() {
  final past = Past();
  final addCmd = AddCommand(session, people, personA);
  
  past.add(addCmd);
  past.doIt();    // calls addCmd.doIt()
  past.undo();    // calls addCmd.undo()
  past.redo();    // calls addCmd.redo()
}
```

### Dependencies & Cross-references
- **Implements**: `IPast`
- Manages `IBasicCommand` objects, not direct `ICommand` references (although the snippet upcasts them).

### Design Notes
- Central store for domain-level undo/redo.
- The `cursor` approach is a well-known technique for incremental undo stacks.

---

## `[I_MODEL_ENTRIES].MD`

### Interface Overview
`IModelEntries` outlines how a set of `Entities` is grouped under a “model.” It can retrieve or create concepts, get entries, and handle JSON import/export.

### Key Methods
- `Model get model;`
- `Concept? getConcept(String conceptCode);`
- `IEntities getEntry(String entryConceptCode);`
- `String toJson();`
- `void fromJson(String json);`
- etc.

### Dependencies & Cross-references
- **Implemented by**: `ModelEntries`

### Design Notes
- Sits at the intersection of domain modeling, storing multiple “entry points.”

---

## `[MODEL_ENTRIES].MD`

### Class/Artifact Overview
`ModelEntries` implements `IModelEntries`, holding a map of `String -> Entities`. Each key corresponds to an “entry concept” in a `Model`.

### Properties/Fields
- `_model` (`Model`): The model these entries belong to.
- `_entryEntitiesMap` (`Map<String, Entities>`): Storage for each entry.

### Constructors
```dart
ModelEntries(this._model) {
  _entryEntitiesMap = newEntries();
}
```
- `newEntries()` initializes an empty `Entities` container for each entry concept.

### Key Methods
- `getEntry(String entryConceptCode)`
- `fromEntryToJson(...)`, `toJson()`
- `populateEntryReferences(...)` resolves relationships across these entries.
- `clear()`: Clears all stored entities.

### Example Usage
```dart
final modelEntries = ModelEntries(myModel);
final userEntities = modelEntries.getEntry('User');
userEntities.add(userEntity);
```

### Dependencies & Cross-references
- **Implements**: `IModelEntries`
- **Uses**: `Entities`, `Concept`, `Model`, `Domain`

### Design Notes
- Provides a central place to store & manage multiple `Entities` sets under a single model scope.
- The reference population methods ensure cross-entity relationships are wired up properly.

---

## `[OID].MD`

### Class/Artifact Overview
`Oid` is a unique object identifier with millisecond-precision plus an auto-increment. It implements `Comparable<Oid>` for ordering.

### Properties/Fields
- `_increment` (`static int`): A class-level counter for each new OID.
- `_timeStamp` (`int`): The sum of current time in milliseconds since epoch plus an increment offset.

### Constructors
- **`Oid()`**: Creates an Oid with the current millisecond + _increment.
- **`Oid.ts(int timeStamp)`**: Directly set the `_timeStamp`.

### Methods
- `int compareTo(Oid other) => _timeStamp.compareTo(other._timeStamp)`
- `bool equals(Oid oid)`: Checks if `_timeStamp` matches.
- `String toString()`: Returns the numeric timestamp.

### Example Usage
```dart
final oid1 = Oid();
final oid2 = Oid();
print(oid1.compareTo(oid2)); // could be < 0 if oid1 < oid2
```

### Dependencies & Cross-references
- **Used by**: `Entity` for unique identification.

### Design Notes
- Simple yet effective approach for local unique IDs in many domain scenarios.

---

## `[ATTRIBUTE_POLICY].MD`

### Class/Artifact Overview
`AttributePolicy` extends `Policy` and checks a specific attribute’s value against a custom validator function. It belongs to the domain’s “policy” subpackage.

### Properties/Fields
- `attributeName` (`String`): The attribute to validate.
- `validator` (`bool Function(dynamic)`) : A function that returns true if the attribute is valid.

### Constructors
```dart
AttributePolicy({
  required String name,
  required String description,
  required this.attributeName,
  required this.validator,
  PolicyScope? scope,
}) : super(name, description, (e) { ... }, scope: scope);
```

### Methods
- **`bool evaluate(Entity entity)`**: Retrieves the specified attribute or relationship, checks it with `validator`.

### Example Usage
```dart
final agePolicy = AttributePolicy(
  name: 'AgePolicy',
  description: 'Must be at least 18',
  attributeName: 'age',
  validator: (value) => value >= 18
);
```

### Dependencies & Cross-references
- **Extends**: `Policy` (see `POLICY.MD`)
- **Uses**: `PolicyScope` optionally.

### Design Notes
- Encourages fine-grained attribute-level validation.
- Often combined in a composite policy or policy engine.

---

## `[ATTRIBUTE_VALIDATORS].MD`

### Class/Artifact Overview
`AttributeValidators` holds a series of **static** reusable validator functions, such as `isNotNull`, `isGreaterThan(...)`, `matchesRegex(...)`, etc.

### Example Usage
```dart
final nameNotNull = AttributeValidators.isNotNull;
bool result = nameNotNull(entity.getAttribute('name'));
```

### Dependencies & Cross-references
- Typically used when constructing `AttributePolicy` or other custom checks.

### Design Notes
- Provides a convenient library of closures for attribute validation.
- May be extended by domain-specific validators.

---

## `[COMPOSITE_POLICY].MD`

### Class/Artifact Overview
`CompositePolicy` implements `IPolicy` by combining multiple sub-policies. It can require **all**, **any**, **none**, or a **majority** of them to pass.

### Properties/Fields
- `name`, `description`
- `policies` (`List<IPolicy>`)
- `type` (`CompositePolicyType`) – `all`, `any`, `none`, or `majority`.
- `scope` (`PolicyScope?`)

### Methods
- **`bool evaluate(Entity entity)`**: Aggregates sub-policy results based on `type`.
- **`PolicyEvaluationResult evaluateWithDetails(...)`**: Provides a list of violations, if any.

### Example Usage
```dart
final composite = CompositePolicy(
  name: 'RequiredPolicies',
  description: 'All must pass',
  policies: [policy1, policy2],
  type: CompositePolicyType.all
);
```

### Dependencies & Cross-references
- **Implements**: `IPolicy`
- **Uses**: `CompositePolicyType`

### Design Notes
- Allows building higher-level validations from simpler sub-policies.
- You can nest composites for complex logic trees.

---

## `[COMPOSITE_POLICY_TYPE].MD`

### Enum Overview
`CompositePolicyType` enumerates how to aggregate sub-policy evaluations:
- `all` (all must pass)
- `any` (at least one passes)
- `none` (none should pass)
- `majority` (over half pass)

### Example Usage
```dart
final type = CompositePolicyType.all;
```

### Design Notes
- Interacts with `CompositePolicy` to define the pass/fail aggregation strategy.

---

## `[I_POLICY].MD`

### Interface Overview
`IPolicy` mandates `name`, `description`, optional `scope`, and two evaluation methods:
- `bool evaluate(Entity entity)`
- `PolicyEvaluationResult evaluateWithDetails(Entity entity)`

### Example Usage
```dart
class CustomPolicy implements IPolicy {
  // ...
  @override
  bool evaluate(Entity entity) => true;
  @override
  PolicyScope? get scope => null;
  // ...
}
```

### Design Notes
- Minimizes coupling by letting each policy define its own validation logic.
- The `PolicyScope` can limit which entities the policy applies to.

---

## `[POLICY].MD`

### Class/Artifact Overview
`Policy` is a basic concrete implementation of `IPolicy`, taking a `bool Function(Entity)` as the core evaluator.

### Properties/Fields
- `_evaluationFunction` (`bool Function(Entity)`)
- `scope` (`PolicyScope?`)

### Constructors
```dart
Policy(
  this.name,
  this.description,
  this._evaluationFunction, {
  this.scope
});
```

### Methods
- **`evaluate(Entity entity)`** => calls `_evaluationFunction`
- **`evaluateWithDetails(Entity entity)`** => returns success/failure plus optional violations.

### Example Usage
```dart
final policy = Policy(
  'NonEmptyName',
  'Name cannot be empty',
  (entity) => (entity.getAttribute('name') ?? '').isNotEmpty
);
```

### Design Notes
- A straightforward, single-check policy.

---

## `[POLICY_WITH_DEPENDENCIES].MD`

### Class/Artifact Overview
`PolicyWithDependencies` extends the idea of a policy but uses an `expression` string plus a set of `dependencies` to evaluate.

### Properties/Fields
- `expression` (`String`)
- `dependencies` (`Set<String>`)

### Methods
- `bool evaluate(Entity entity)`:  
  Dynamically evaluates the expression using `ExpressionEvaluator`.

### Example Usage
```dart
final p = PolicyWithDependencies(
  'SalaryAboveMinimum',
  'Salary must exceed 3000 if status == "fulltime"',
  'status == "fulltime" ? salary > 3000 : true',
  {'status', 'salary'}
);
```

### Dependencies & Cross-references
- **Implements**: `IPolicy`
- **Uses**: `ExpressionEvaluator` (external or custom) for evaluating the expression.

### Design Notes
- Enables dynamic policy definitions (e.g., from external config).

---

## `[POLICY_ENGINE].MD`

### Class/Artifact Overview
`PolicyEngine` holds a list of `Policy` objects and can determine which apply to a given entity, then execute them.

### Properties/Fields
- `policies` (`List<Policy>`)
- `session` (`DomainSession?`): Unused or partially used in snippet.

### Methods
- `void addPolicy(Policy policy)`
- `List<Policy> getApplicablePolicies(Entity entity)`
- `void executePolicyGes(Entity entity)`

### Example Usage
```dart
final engine = PolicyEngine(session);
engine.addPolicy(myPolicy);
final applicable = engine.getApplicablePolicies(entity);
for (var p in applicable) { /* ... */ }
```

### Dependencies & Cross-references
- **Uses**: `Policy`
- Usually integrated with the domain session or model to evaluate constraints.

### Design Notes
- Could be extended to auto-run or chain policies in certain domain events.

---

## `[POLICY_EVALUATION_TRACER].MD`

### Class/Artifact Overview
`PolicyEvaluationTracer` logs an evaluation trace (start, end, attribute checks, relationship checks). This helps debug complex policies.

### Key Elements
- `_traceEntries` (`List<TraceEntry>`)
- `_depth` (`int`): Helps format nested traces.

### Methods
- `void startEvaluation(String policyName, Entity entity)`
- `void endEvaluation(String policyName, bool result)`
- `void addAttributeCheck(...)`
- `void addRelationshipCheck(...)`
- `String getTrace()`
- `void clear()`

### Example Usage
```dart
final tracer = PolicyEvaluationTracer();
tracer.startEvaluation('AgePolicy', someEntity);
// ... 
tracer.endEvaluation('AgePolicy', true);
print(tracer.getTrace());
```

### Dependencies & Cross-references
- **Used by**: `PolicyEvaluator`

### Design Notes
- A dedicated debug tool for policy validations.
- `TraceEntry` objects store each step for human-readable output.

---

## `[TRACE_ENTRY].MD`

### Class/Artifact Overview
`TraceEntry` is a record of a single event in `PolicyEvaluationTracer`.

### Properties/Fields
- `type` (`TraceEntryType`)
- `policyName`, `entityInfo`
- `attributeName`, `attributeValue`
- `relationshipName`, `relationshipValue`
- `result` (`bool?`)
- `depth` (`int`)

### Constructors
```dart
TraceEntry({
  required this.type,
  this.policyName,
  this.entityInfo,
  ...
  required this.depth,
});
```

### Example Usage
```dart
final entry = TraceEntry(
  type: TraceEntryType.start,
  policyName: 'AgePolicy',
  entityInfo: 'Person(oid=123)',
  depth: 0,
);
```

### Dependencies & Cross-references
- **Used by**: `PolicyEvaluationTracer`
- **Uses**: `TraceEntryType`

### Design Notes
- Baked with new, end, attribute, and relationship trace states (`TraceEntryType`).

---

## `[TRACE_ENTRY_TYPE].MD`

### Enum Overview
`TraceEntryType` enumerates:
- `start`
- `end`
- `attributeCheck`
- `relationshipCheck`

### Example Usage
```dart
final t = TraceEntryType.start;
```

### Design Notes
- Helps format or interpret the `TraceEntry` logs in `PolicyEvaluationTracer`.

---

## `[POLICY_EVALUATOR].MD`

### Class/Artifact Overview
`PolicyEvaluator` runs policies from a `PolicyRegistry` (and logs them via `PolicyEvaluationTracer`).

### Properties/Fields
- `_policyRegistry` (`PolicyRegistry`)
- `_tracer` (`PolicyEvaluationTracer`)

### Methods
- `PolicyEvaluationResult evaluate(Entity entity, {String? policyKey})`
- `_evaluateSinglePolicy(...)`
- `_evaluateAllPolicies(...)`
- `String getEvaluationTrace()`

### Example Usage
```dart
final evaluator = PolicyEvaluator(registry);
final result = evaluator.evaluate(entity);
if (!result.success) {
  print(result.violations);
}
print(evaluator.getEvaluationTrace());
```

### Dependencies & Cross-references
- **Uses**: `PolicyRegistry`, `PolicyEvaluationTracer`, `PolicyEvaluationResult`, `PolicyViolation`

### Design Notes
- A single entry point for applying named or all policies to an entity.
- Produces a structured trace for debugging.

---

## `[POLICY_EVALUATION_RESULT].MD`

### Class/Artifact Overview
`PolicyEvaluationResult` holds a `success` boolean and a list of `PolicyViolation`.

### Properties
- `success` (`bool`)
- `violations` (`List<PolicyViolation>`)

### Example Usage
```dart
final result = PolicyEvaluationResult(false, [
  PolicyViolation('MinAgePolicy', 'Age is below allowed minimum')
]);
```

### Dependencies & Cross-references
- **Used by**: `PolicyEvaluator`
- **Holds**: `PolicyViolation`

### Design Notes
- Standard way to return policy checks, either all pass or a set of violation messages.

---

## `[POLICY_VIOLATION].MD`

### Class/Artifact Overview
`PolicyViolation` captures a failed policy’s key and message.

### Properties
- `policyKey` (`String`)
- `message` (`String`)

### Example Usage
```dart
final v = PolicyViolation('EmailPolicy', 'Email is invalid');
```

### Design Notes
- Simple data holder for describing which policy was broken and why.

---

## `[POLICY_REGISTRY].MD`

### Class/Artifact Overview
`PolicyRegistry` organizes policies in a `Map<String, IPolicy>` keyed by a string. It can retrieve, remove, or evaluate them collectively.

### Properties/Fields
- `_policies` (`Map<String, IPolicy>`)

### Methods
- `void registerPolicy(String key, IPolicy policy)`
- `IPolicy? getPolicy(String key)`
- `void removePolicy(String key)`
- `bool evaluateNamedPolicy(String key, Entity entity)`
- `List<String> evaluateAllPolicies(Entity entity)`

### Example Usage
```dart
final registry = PolicyRegistry();
registry.registerPolicy('AgeCheck', agePolicy);
bool valid = registry.evaluateNamedPolicy('AgeCheck', entity);
```

### Dependencies & Cross-references
- **Used by**: `PolicyEvaluator`
- **Holds**: `IPolicy` objects

### Design Notes
- Central store for all domain policies, enabling flexible additions or updates.

---

## `[POLICY_REGISTRATION_EXCEPTION].MD`

### Class/Artifact Overview
`PolicyRegistrationException` is thrown when attempting to register a duplicate policy key.

### Properties
- `message` (`String`)

### Constructors
```dart
PolicyRegistrationException(this.message);
```

### Example Usage
```dart
try {
  registry.registerPolicy('SameKey', policyA);
  registry.registerPolicy('SameKey', policyB);
} on PolicyRegistrationException catch (e) {
  print(e);
}
```

### Design Notes
- Prevents overwriting existing policies unintentionally.

---

## `[POLICY_NOT_FOUND_EXCEPTION].MD`

### Class/Artifact Overview
`PolicyNotFoundException` is thrown when a registry lookup fails for a specified key.

### Properties
- `message` (`String`)

### Example Usage
```dart
try {
  registry.evaluateNamedPolicy('NoSuchKey', entity);
} on PolicyNotFoundException catch(e) {
  print('Policy not found: $e');
}
```

### Design Notes
- Differentiates a missing policy from other domain errors.

---

## `[POLICY_SCOPE].MD`

### Class/Artifact Overview
`PolicyScope` sets conditions and a set of concepts to which a policy applies.

### Properties
- `applicableConcepts` (`Set<String>`)
- `conditions` (`Map<String, dynamic>`)

### Methods
- `bool isWithinScope(Entity entity)`: Checks if the entity’s concept code is in `applicableConcepts` and if all `conditions` match the entity’s attributes.

### Example Usage
```dart
final scope = PolicyScope({'Person'}, {'country': 'USA'});
if (scope.isWithinScope(entity)) { ... }
```

### Dependencies & Cross-references
- **Used by**: `Policy`, `CompositePolicy`, `TimeBasedPolicy`, etc.

### Design Notes
- A quick filter to skip or apply policies only to matching entities.

---

## `[POLICY_VIOLATION_EXCEPTION].MD`

### Class/Artifact Overview
`PolicyViolationException` is thrown when one or more policy violations occur, bundling them in a list.

### Properties
- `violations` (`List<PolicyViolation>`)

### Constructors
```dart
PolicyViolationException(this.violations);
```

### Example Usage
```dart
throw PolicyViolationException([
  PolicyViolation('RequiredName', 'Name cannot be empty')
]);
```

### Design Notes
- Allows halting domain operations if critical policies fail, returning a consolidated set of messages.

---

## `[RELATIONSHIP_POLICY].MD`

### Class/Artifact Overview
`RelationshipPolicy` extends `Policy` to validate an entity’s parent or child relationships using a custom `bool Function(Entity, dynamic)` validator.

### Properties
- `relationshipName` (`String`)
- `relationshipType` (`RelationshipType`)

### Methods
- `bool evaluate(Entity entity)`: Retrieves the relevant relationship (parent or child) and invokes the `validator`.

### Example Usage
```dart
final mustHaveChildren = RelationshipPolicy(
  name: 'HasChildren',
  description: 'Entity must have at least 1 child item',
  relationshipName: 'items',
  relationshipType: RelationshipType.child,
  validator: RelationshipValidators.hasMinimumChildren(1),
);
```

### Dependencies & Cross-references
- **Extends**: `Policy`
- **Uses**: `RelationshipType`, `RelationshipValidators`

### Design Notes
- Focuses on validating structural relationships, e.g. “child count must be >= 1.”

---

## `[RELATIONSHIP_TYPE].MD`

### Enum Overview
`RelationshipType` can be:
- `parent`
- `child`

### Example Usage
```dart
final type = RelationshipType.parent;
```

### Design Notes
- Combined with `relationshipName` to specify which relationship to evaluate.

---

## `[RELATIONSHIP_VALIDATORS].MD`

### Class/Artifact Overview
`RelationshipValidators` provides static functions to check relationship-based conditions: minimum/maximum children, parent attribute checks, etc.

### Example Usage
```dart
bool valid = RelationshipValidators.hasMinimumChildren(1)(entity, entity.getChild('items'));
```

### Design Notes
- Similar style to `AttributeValidators`, but for parent/child validations.

---

## `[TIME_BASED_POLICY].MD`

### Class/Artifact Overview
`TimeBasedPolicy` implements `IPolicy`, verifying a date/time attribute (`timeAttributeName`) against a `TimeValidator`.

### Properties
- `timeAttributeName` (`String`)
- `validator` (`TimeValidator`)
- `clock` (`Clock`)

### Methods
- `bool evaluate(Entity entity)`: Ensures the attribute is a `DateTime` and calls `validator(attributeTime, clock.now())`.

### Example Usage
```dart
final policy = TimeBasedPolicy(
  name: 'CreatedRecently',
  description: 'Must be created within last 24 hours',
  timeAttributeName: 'whenAdded',
  validator: TimeValidators.isWithinLast(Duration(hours: 24))
);
```

### Dependencies & Cross-references
- **Implements**: `IPolicy`
- **Uses**: `TimeValidators`, `Clock`

### Design Notes
- Encourages time-based constraints (e.g., “must be at least X old” or “cannot be older than Y days”).

---

## `[TIME_VALIDATOR].MD` & `[TIME_VALIDATORS].MD`

### Overview
- `TimeValidator` is a function type: `(DateTime attributeTime, DateTime currentTime) => bool`.
- `TimeValidators` is a collection of static methods returning `TimeValidator` closures (`isBefore`, `isAfter`, `isWithinLast`, etc.).

### Example Usage
```dart
final tv = TimeValidators.isWithinLast(Duration(days: 7));
bool result = tv(someDate, DateTime.now());
```

### Design Notes
- Provide domain-friendly time checks, used in `TimeBasedPolicy`.

---

## `[SYSTEM_CLOCK].MD` & `[CLOCK].MD`

### Class/Artifact Overview
- `Clock` is an abstract class with one method `DateTime now()`.
- `SystemClock` implements `Clock` using `DateTime.now()` directly.

### Example Usage
```dart
final clock = SystemClock();
print(clock.now()); // real system time
```

### Design Notes
- Allows injecting alternative time sources (for testing or custom date/time logic).

---

## `[DART_BASIC_TYPE].MD`

### Enum Overview
`DartBasicType` enumerates:
- `bool`, `int`, `double`, `string`, `list`, `map`, `set`, `dynamic`

### Example
```dart
final type = DartBasicType.bool;
```

### Design Notes
- Not deeply used in the snippet, but presumably for describing attribute types.

---

## `[REFERENCE].MD`

### Class/Artifact Overview
`Reference` holds a textual OID (`parentOidString`) plus concept codes for cross-entity linking. Often used by `Entity` to store a parent reference.

### Properties/Fields
- `parentOidString` (`String`)
- `parentConceptCode` (`String`)
- `entryConceptCode` (`String`)

### Methods
- `Oid get oid`: Parses `parentOidString` into an `Oid`.

### Example Usage
```dart
final ref = Reference('12345', 'Person', 'Person');
final parentOid = ref.oid;
```

### Design Notes
- Decouples referencing from direct object pointers, aligning with JSON-based or external references.

---

## `[FROM_JSON_TO_MODEL].MD`

### Function Overview
`fromJsonToModel(String json, Domain domain, String modelCode, Map? yaml)` parses a JSON or YAML-based structure into a `Model`. It constructs `Concept`s, their `Attributes`, and relations.

### Signature
```dart
Model fromJsonToModel(
  String json,
  Domain domain,
  String modelCode,
  Map? yaml
)
```

- Returns a populated `Model`.

### Key Steps
1. Read `concepts` and `relations` from JSON or YAML.
2. For each concept, create a `Concept` in `model`.
3. For each relation, set up parent-child references.

### Example Usage
```dart
final model = fromJsonToModel(jsonString, myDomain, 'MyModel', null);
```

### Dependencies & Cross-references
- **Uses**: `Model`, `Concept`, `Attribute`, `Parent`, `Child`, etc.
- Relies on the EDNet meta-model to define domain structures.

### Design Notes
- Central parser for generating the in-memory domain model from external definitions (JSON or YAML).
- Tightly integrated with the EDNet meta-model approach.

---

## `[VALUE_OBJECT].MD`

### Class/Artifact Overview
`ValueObject` is an abstract class requiring `Map<String, dynamic> toJson();`. `SimpleValueObject` is a concrete example with name, description, version, and attributes.

### **`ValueObject`**
- Minimal contract: `toJson()`.

### **`SimpleValueObject`**
- Has `name`, `description`, `version`, and `attributes` (a list of `ValueObjectAttribute`).

### Example Usage
```dart
final vo = SimpleValueObject(
  name: 'Address',
  description: 'Street address',
  version: '1.0',
  attributes: [ValueObjectAttribute(key: 'street', value: '123 Main')]
);
print(vo.toJson());
```

### Dependencies & Cross-references
- Self-contained, can be used or referenced by entities or domain objects if needed.

### Design Notes
- Pattern for describing domain concepts that are pure data structures without identity, in line with typical DDD “Value Object” definitions.

---

## `[VALUE_OBJECT_ATTRIBUTE].MD`

### Class/Artifact Overview
`ValueObjectAttribute` pairs a `key` and a `value`. Used in `SimpleValueObject.attributes`.

### Example Usage
```dart
final attr = ValueObjectAttribute(key: 'city', value: 'New York');
```

### Design Notes
- A small wrapper clarifying attribute semantics within a value object.

---

## `[I_DOMAIN_SESSION].MD`

### Interface Overview
`IDomainSession` describes the contract for a domain session, providing:
- `domainModels` (`IDomainModels`)
- `past` (`IPast`)

### Design Notes
- Typically used to group user actions in a single transactional or ephemeral context.
- `DomainSession` is the standard EDNet-based implementation.

---

## `[DOMAIN_SESSION].MD`

### Class/Artifact Overview
`DomainSession` implements `IDomainSession` by bundling a `DomainModels` reference and a `Past` for command history. It also includes a `PolicyEngine`.

### Properties/Fields
- `_domainModels` (`DomainModels`)
- `_past` (`Past`)
- `policyEngine` (`PolicyEngine`)

### Constructors
```dart
DomainSession(this._domainModels)
  : _past = Past(),
    policyEngine = PolicyEngine(null);
```

### Methods
- **`executeCommand(ICommand command)`**:
    - Calls `command.doIt()`. If successful, adds it to `past`.
    - Triggers any events from `command.getEvents()`.

### Example Usage
```dart
void main() {
  final dm = DomainModels(myDomain);
  final session = DomainSession(dm);
  
  final addCmd = AddCommand(session, someEntities, someEntity);
  session.executeCommand(addCmd);
}
```

### Dependencies & Cross-references
- **Implements**: `IDomainSession`
- **Uses**: `DomainModels`, `Past`, `PolicyEngine`

### Design Notes
- A typical usage scenario is one `DomainSession` per user interaction scope.
- Collects undone commands and local domain changes while referencing the broader `DomainModels`.
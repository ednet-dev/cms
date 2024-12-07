# **Concept Architecture in EDNet Core**

## **Overview**

The `Concept` class in EDNet Core serves as the schema definition layer for entities within the framework. Concepts define the **structure**, **relationships**, and **constraints** of entities, acting as blueprints for the underlying domain model. This document provides an in-depth look at the `Concept` class, its internal structures, interactions with other components, and examples illustrating its role in complex domain modeling.

---

## **Key Features**

1. **Blueprint for Entities**
   * Defines attributes, parent-child relationships, and metadata for entities.
2. **Hierarchical Relationships**
   * Supports both **internal** and **external** parent-child relationships.
3. **Attribute Management**
   * Manages attributes by category: identifiers, essential, required, and incremental.
4. **Policy Awareness**
   * Evaluates and enforces **policies** at the concept level.
5. **Serialization and Graph Representation**
   * Translates concept definitions into JSON and graph structures for persistence and analysis.

---

## **Internal Structure**

### **Core Properties**

* **Attributes**: Define the properties an entity can have.
* **Parents/Children**: Specify relationships between entities.

```dart
Attributes attributes;
Parents parents; // Destination parent neighbors
Children children; // Destination child neighbors
```

* **Entry Flag**: Determines if this concept serves as an entry point in the domain.
* dart

bool entry = true;
### **Dynamic Pluralization**

Customizable pluralization for concept names:

```dart
String get codes {
  _codes ??= plural(_code!);
  return _codes!;
}
```
### **Policy Enforcement**

Concept-level policies enforce constraints and validations across attributes and relationships.

---

## **Integration with Model and Entity**

### **Concepts in a Model**

Concepts are part of a model, defining the entities and their interrelationships.

```dart
final model = Model(domain, 'Library');
final concept = Concept(model, 'Book');
concept.attributes.add(Attribute(concept, 'title'));
concept.attributes.add(Attribute(concept, 'author'));
```
### **Entities Instantiated from Concepts**

Entities inherit the schema defined in their associated concept:

```dart
final book = Entity();
book.concept = concept;
book.setAttribute('title', 'Clean Code');
book.setAttribute('author', 'Robert C. Martin');
```
---

## **Examples**

### **1. Defining Attributes and Relationships**

Attributes define properties, and relationships model parent-child hierarchies.

```dart
final concept = Concept(model, 'User');
concept.attributes.add(Attribute(concept, 'username', required: true));
concept.attributes.add(Attribute(concept, 'email', required: true));

final addressConcept = Concept(model, 'Address');
concept.children.add(Child(concept, addressConcept, 'addresses'));
```
---

### **2. Managing Attribute Categories**

Concepts categorize attributes for specialized use cases.

#### **Identifier Attributes**

```dart
List<Attribute> get identifierAttributes => attributes
  .where((attribute) => attribute.identifier)
  .toList();
```
#### **Essential Attributes**

```dart
List<Attribute> get essentialAttributes => attributes
  .where((attribute) => attribute.essential)
  .toList();
```
#### Example:

```dart
final concept = Concept(model, 'Order');
concept.attributes.add(Attribute(concept, 'orderId', identifier: true));
concept.attributes.add(Attribute(concept, 'status', essential: true));

final identifiers = concept.identifierAttributes;
final essentials = concept.essentialAttributes;

print(identifiers.map((attr) => attr.code)); // Output: [orderId]
print(essentials.map((attr) => attr.code));  // Output: [status]
```
---

### **3. Parent-Child Relationships**

Establish hierarchical relationships using `Parent` and `Child`.

#### Parent Example:

```dart
final parentConcept = Concept(model, 'Category');
final childConcept = Concept(model, 'Product');

parentConcept.children.add(Child(parentConcept, childConcept, 'products'));
childConcept.parents.add(Parent(childConcept, parentConcept, 'category'));
```
#### Accessing Relationships:

```dart
final child = parentConcept.getDestinationChild('products');
final parent = childConcept.getDestinationParent('category');

print(child.code); // Output: products
print(parent.code); // Output: category
```
---

### **4. Reflexive and Twin Relationships**

Concepts support **self-referencing** (reflexive) and **twin** relationships.

#### Reflexive Example:

```dart
final concept = Concept(model, 'Employee');
concept.children.add(Child(concept, concept, 'subordinates', reflexive: true));
concept.parents.add(Parent(concept, concept, 'manager', reflexive: true));
```
#### Twin Example:

```dart
final concept1 = Concept(model, 'Person');
final concept2 = Concept(model, 'Person');
concept1.children.add(Child(concept1, concept2, 'siblings', twin: true));
concept2.children.add(Child(concept2, concept1, 'siblings', twin: true));
```
---

### **5. Entry Concept Paths**

Access paths to the entry concept and child relationships.

```dart
final concept = Concept(model, 'Order');
final itemConcept = Concept(model, 'OrderItem');
concept.children.add(Child(concept, itemConcept, 'items'));

print(itemConcept.entryConceptThisConceptInternalPath);
// Output: OrderOrderItem
```
---

## **Serialization and Graph Representation**

### JSON Representation

Serialize concept definitions for persistence or sharing.

```dart
final json = concept.toJson();
print(json);
// Output: {"code":"User","attributes":[...],"parents":[],"children":[]}
```
### Graph Representation

Visualize concept relationships in a graph format.

```dart
final graph = concept.toGraph();
print(graph);
// Output: {"attributes":[...],"parents":[...],"children":[...]}
```
---

## **Advanced Scenarios**

### **Dynamic Model Loading**

Concepts support dynamic loading into models at runtime.

```dart
final model = Model(domain, 'Library');
final json = '{"code":"Book","attributes":[{"code":"title"}, {"code":"author"}]}';

final concept = Concept.safeGetConcept(model, Entity());
concept.fromJson(json);
model.concepts.add(concept);
```
### **Validation and Policies**

Evaluate policies across attributes and relationships.

```dart
final policyResult = concept.evaluatePolicies();
if (!policyResult.success) {
  throw PolicyViolationException(policyResult.violations);
}
```
---

## **Conclusion**

The `Concept` class in EDNet Core defines the **foundation of domain modeling** by establishing the schema, constraints, and relationships for entities. It is an essential part of creating robust, flexible, and reusable domain models, enabling developers to address complex requirements while adhering to best practices in **domain-driven design** (DDD).

For further exploration, visit the [EDNet Core Repository](https://github.com/ednet-dev).

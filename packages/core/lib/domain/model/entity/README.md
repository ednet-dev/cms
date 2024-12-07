# **Entity Architecture in EDNet Core**

## **Overview**

The `Entity` class in EDNet Core serves as the cornerstone of the framework's **domain modeling capabilities**, enabling developers to define and interact with domain objects in a structured and reusable manner. This document provides a detailed explanation of the `Entity` class, its integration with `Concept`, and examples demonstrating how the architecture supports complex modeling requirements.

---

## **Key Features**

1. **Dynamic Attributes and Relationships**
    - Support for runtime attributes (`_attributeMap`) and structured relationships like **parents**, **children**, and **internal children**.

2. **Concept-Driven Behavior**
    - Tightly integrated with the `Concept` class, defining the schema, attributes, and relationships.

3. **Lifecycle Management**
    - Tracks key timestamps (`whenAdded`, `whenSet`, `whenRemoved`) for entity lifecycle events.

4. **Policy Evaluation**
    - Enforces business rules and validations using **pre-defined policies**.

5. **Serialization Support**
    - Includes methods for **JSON serialization**, graph representation, and deserialization.

6. **Undo/Redo and Transactions**
    - Integration with commands allows seamless undo/redo operations.

---

## **Internal Structure**

### **Attributes**

- Stored in `_attributeMap`.
- Managed dynamically based on the associated `Concept`.

```dart
Map<String, Object?> _attributeMap = <String, Object?>{};
```

### **Relationships**

- **Parents**: References to parent entities, managed through `_parentMap` and `_referenceMap`.
- **Children**: Collections of child entities, stored in `_childMap`.
- **Internal Children**: Subset of children managed internally.

```dart
Map<String, Object?> _parentMap = <String, Object?>{};
Map<String, Object?> _childMap = <String, Object?>{};
Map<String, Object?> _internalChildMap = <String, Object?>{};
```

### **Policy Enforcement**

The `PolicyEvaluator` ensures that entities adhere to rules defined at both entity and model levels.

```dart
PolicyEvaluationResult evaluatePolicies({String? policyKey}) {
  return _policyEvaluator.evaluate(this, policyKey: policyKey);
}
```

---

## **Integration with Concept**

Entities are **runtime instances** of a `Concept`. The `Concept` defines:
- **Attributes**: What properties an entity can have.
- **Relationships**: Parent-child and sibling structures.
- **Policies**: Validation rules.

### Example:

```dart
final concept = Concept(model, 'Citizen');
concept.attributes.add(Attribute(concept, 'name'));
concept.attributes.add(Attribute(concept, 'age'));

final citizen = Entity();
citizen.concept = concept;
citizen.setAttribute('name', 'John Doe');
citizen.setAttribute('age', 30);
```

---

## **Examples**

### **1. Basic Entity Creation**

Define and initialize an entity dynamically:

```dart
final concept = Concept(model, 'Product');
concept.attributes.add(Attribute(concept, 'name'));
concept.attributes.add(Attribute(concept, 'price'));

final product = Entity();
product.concept = concept;

product.setAttribute('name', 'Laptop');
product.setAttribute('price', 1200.00);

print(product.toString());
// Output: {Product: {oid: 12345, code: null, name: Laptop, price: 1200.00}}
```

---

### **2. Parent-Child Relationships**

Establish and manage hierarchical relationships.

```dart
final parentConcept = Concept(model, 'Category');
final childConcept = Concept(model, 'Item');

final category = Entity();
category.concept = parentConcept;
category.setAttribute('name', 'Electronics');

final item = Entity();
item.concept = childConcept;
item.setAttribute('name', 'Smartphone');

// Link child to parent
item.setParent('category', category);

print(item.getParent('category').toString());
// Output: {Category: {oid: 67890, code: null, name: Electronics}}
```

---

### **3. Policy Enforcement**

Ensure entities adhere to business rules.

```dart
final concept = Concept(model, 'User');
concept.attributes.add(Attribute(concept, 'email', type: 'String', required: true));

final user = Entity();
user.concept = concept;

try {
  user.setAttribute('email', null); // Will throw an exception
} catch (e) {
  print(e); // Output: User.email cannot be null.
}
```

---

### **4. Serialization and Deserialization**

Save and restore entity state using JSON.

#### Serialization:

```dart
final json = product.toJson();
print(json);
// Output: {"oid":"12345","code":null,"name":"Laptop","price":1200.00}
```

#### Deserialization:

```dart
final restoredProduct = Entity();
restoredProduct.concept = concept;
restoredProduct.fromJson(json);

print(restoredProduct.toString());
// Output: {Product: {oid: 12345, code: null, name: Laptop, price: 1200.00}}
```

---

### **5. Undo/Redo Operations**

Integrate with commands for undoable actions.

```dart
final session = DomainSession();
final addCommand = AddCommand(session, entities, product);

addCommand.doIt();  // Add the product
addCommand.undo();  // Undo the addition
addCommand.redo();  // Redo the addition
```

---

## **Advanced Modeling Scenarios**

### **Composite Relationships**

```dart
final departmentConcept = Concept(model, 'Department');
final employeeConcept = Concept(model, 'Employee');

// Define entities
final department = Entity();
department.concept = departmentConcept;
department.setAttribute('name', 'HR');

final employee = Entity();
employee.concept = employeeConcept;
employee.setAttribute('name', 'Alice');

// Link employee to department
employee.setParent('department', department);

// Serialize composite structure
print(department.toJson());
```

### **Entity Copying**

Deep copy entities with attributes and relationships.

```dart
final copiedProduct = product.copy();
print(copiedProduct.toString());
```

---

## **Conclusion**

The `Entity` class provides a versatile and extensible foundation for defining and managing domain models. Its integration with `Concept` enables a structured, policy-driven approach to entity management, making it ideal for complex domain-driven design (DDD) scenarios.

For further details on the framework's capabilities, refer to the [EDNet Core Documentation](https://github.com/ednet-dev).
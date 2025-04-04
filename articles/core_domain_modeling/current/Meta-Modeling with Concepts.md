# Meta-Modeling with Concepts

Most domain modeling frameworks operate at a single level of abstraction, focusing on the objects in your domain (products, orders, customers). EDNet Core introduces a powerful additional layer: meta-modeling through the `Concept` class, which allows you to model the structure of your domain objects themselves.

## Understanding Meta-Modeling

Meta-modeling is modeling about models - defining the structure, rules, and relationships that apply to your domain objects. Instead of just declaring a `Customer` class, meta-modeling lets you define what attributes and relationships a `Customer` can have, what constraints apply, and how it interacts with other domain concepts.

This approach brings several important benefits:
- Runtime introspection and validation
- Dynamic behavior based on model structure
- Self-documenting domain models
- Adaptable models that can evolve at runtime

## The Concept Class: The Foundation of EDNet's Meta-Model

At the heart of EDNet Core's meta-modeling capabilities is the `Concept` class. A `Concept` defines a type of entity in your domain, including its:

- **Attributes**: The properties or characteristics of entities
- **Parents**: References to other entities (many-to-one relationships)
- **Children**: Collections of related entities (one-to-many relationships)
- **Behaviors**: Rules, constraints, and operations that apply to the concept

```dart
class Concept extends Entity<Concept> {
  bool entry = false;
  bool abstract = false;
  String min = '0';
  String max = 'N';
  bool updateOid = false;
  bool updateCode = false;
  bool updateWhen = false;
  bool canAdd = true;
  bool remove = true;
  String description = 'I am Entity of Concept';
  
  Model model;
  
  Attributes attributes;
  Parents parents;
  Children children;
  
  Parents sourceParents;
  Children sourceChildren;
  
  Concept(this.model, String conceptCode)
    : attributes = Attributes(),
      parents = Parents(),
      children = Children(),
      sourceParents = Parents(),
      sourceChildren = Children() {
    code = conceptCode;
    model.concepts.add(this);
  }
  
  // Implementation details...
}
```

### Building a Domain Model with Concepts

Let's see how to use concepts to build a domain model:

```dart
// Create a domain and model
var domain = Domain('ECommerce');
var model = Model(domain, 'ShopModel');

// Create product concept
var productConcept = Concept(model, 'Product');
productConcept.entry = true;  // Acts as an aggregate root
productConcept.description = 'A product available for sale';

// Add attributes to the product concept
var nameAttr = Attribute('name', productConcept);
nameAttr.type = domain.types.getTypeByCode('String');
nameAttr.required = true;
nameAttr.update = true;
productConcept.attributes.add(nameAttr);

var priceAttr = Attribute('price', productConcept);
priceAttr.type = domain.types.getTypeByCode('double');
priceAttr.required = true;
priceAttr.update = true;
productConcept.attributes.add(priceAttr);

// Create category concept
var categoryConcept = Concept(model, 'Category');
categoryConcept.entry = true;
categoryConcept.description = 'A grouping of related products';

// Add attributes to the category concept
var categoryNameAttr = Attribute('name', categoryConcept);
categoryNameAttr.type = domain.types.getTypeByCode('String');
categoryNameAttr.required = true;
categoryNameAttr.update = true;
categoryConcept.attributes.add(categoryNameAttr);

// Create relationships between concepts
var categoryParent = Parent('category', productConcept);
categoryParent.destinationConcept = categoryConcept;
categoryParent.update = true;
productConcept.parents.add(categoryParent);

var productsChild = Child('products', categoryConcept);
productsChild.destinationConcept = productConcept;
categoryConcept.children.add(productsChild);
```

This meta-model defines both the structure of our domain objects and the relationships between them.

## Special Properties of Concepts

The `Concept` class includes several special properties that control how entities behave:

### Structural Properties

- **entry**: Indicates if this concept acts as an entry point/aggregate root in the domain
- **abstract**: Indicates if this concept is abstract (can't be instantiated directly)
- **min/max**: Cardinality constraints for collections of this concept

### Update Control Properties

- **updateOid**: Whether the entity's OID can be updated
- **updateCode**: Whether the entity's code can be updated
- **updateWhen**: Whether timestamp fields can be updated
- **canAdd**: Whether entities of this concept can be added to collections
- **remove**: Whether entities of this concept can be removed from collections

## Working with Attributes

Attributes define the properties that entities of a concept can have:

```dart
// Create an attribute for a concept
var descriptionAttr = Attribute('description', productConcept);
descriptionAttr.type = domain.types.getTypeByCode('String');
descriptionAttr.required = false;
descriptionAttr.update = true;
descriptionAttr.length = 500;  // Maximum length
productConcept.attributes.add(descriptionAttr);

// Special attribute types
var idAttr = Attribute('sku', productConcept);
idAttr.type = domain.types.getTypeByCode('String');
idAttr.required = true;
idAttr.identifier = true;  // Acts as a business identifier
productConcept.attributes.add(idAttr);

var sequenceAttr = Attribute('sequence', productConcept);
sequenceAttr.type = domain.types.getTypeByCode('int');
sequenceAttr.increment = 1;  // Auto-incrementing field
productConcept.attributes.add(sequenceAttr);
```

Attributes support rich metadata:

- **Type**: The data type of the attribute
- **Required**: Whether the attribute must have a value
- **Update**: Whether the attribute can be changed after creation
- **Identifier**: Whether the attribute forms part of the entity's ID
- **Increment**: For auto-incrementing fields
- **Length**: For string fields
- **Sensitive**: For fields containing sensitive data
- **Essential**: For fields that are essential to the entity's identity
- **Derive**: Whether the attribute is derived from other attributes

## Modeling Relationships

EDNet Core supports rich relationship modeling through `Parent` and `Child` references:

```dart
// Many-to-one relationship (Product belongs to a Category)
var categoryParent = Parent('category', productConcept);
categoryParent.destinationConcept = categoryConcept;
categoryParent.required = true;  // Product must have a category
categoryParent.identifier = false;  // Not part of the product's identity
categoryParent.update = true;  // Can change a product's category
productConcept.parents.add(categoryParent);

// One-to-many relationship (Category has many Products)
var productsChild = Child('products', categoryConcept);
productsChild.destinationConcept = productConcept;
productsChild.internal = false;  // External relationship
categoryConcept.children.add(productsChild);
```

Relationships support various properties:

- **Required**: Whether the relationship must be set
- **Identifier**: Whether the relationship forms part of the entity's ID
- **Update**: Whether the relationship can be changed after creation
- **Internal/External**: Whether the child is owned by the parent
- **Twin**: Whether the relationship is bidirectional
- **Reflexive**: Whether the relationship can point to the same concept

## Runtime Reflection and Introspection

One of the most powerful aspects of EDNet's meta-model is the ability to inspect and manipulate the model at runtime:

```dart
// Finding concepts in a model
final productConcept = model.getConcept('Product');
final allConcepts = model.concepts;
final entryPoints = model.entryConcepts;

// Exploring concept structure
final attributes = productConcept.attributes;
final requiredAttrs = productConcept.requiredAttributes;
final identifierAttrs = productConcept.identifierAttributes;
final parents = productConcept.parents;
final children = productConcept.children;

// Checking properties
final isEntry = productConcept.entry;
final hasId = productConcept.hasId;
final hasAttributeId = productConcept.hasAttributeId;
final hasParentId = productConcept.hasParentId;
final hasTwinParent = productConcept.hasTwinParent;
```

This introspection capability enables powerful features like:
- Automatic UI generation based on the meta-model
- Dynamic validation rules
- Reflective serialization and deserialization
- Meta-programming techniques

## Advanced Meta-Modeling Features

### Entry Concepts and Aggregate Roots

The `entry` property identifies concepts that act as domain entry points (aggregate roots):

```dart
// Make Order an entry concept
orderConcept.entry = true;

// Get the entry concept for a non-entry concept
var orderLineConcept = model.getConcept('OrderLine');
var entryConcept = orderLineConcept.entryConcept;  // Returns Order
```

### Internal Paths and Navigation

EDNet Core provides utilities for navigating the object graph:

```dart
// Get the path from the entry concept to this concept
final path = orderLineConcept.entryConceptThisConceptInternalPath;
// Returns "Order_orderLines_OrderLine"

// Get all child paths from this concept
final childPaths = orderConcept.childCodeInternalPaths;
// Returns ["Order_orderLines_OrderLine", ...]
```

### Sensitive Data Handling

Concepts can mark certain properties or relationships as sensitive:

```dart
// Mark an attribute as sensitive
var creditCardAttr = Attribute('creditCardNumber', customerConcept);
creditCardAttr.sensitive = true;
customerConcept.attributes.add(creditCardAttr);

// Check if an attribute is sensitive
boolean isSensitive = customerConcept.isAttributeSensitive('creditCardNumber');
```

## Practical Example: Dynamic Form Generation

Meta-modeling enables powerful dynamic UI generation. Here's a simple example of generating a form based on a concept:

```dart
Widget buildFormForConcept(Concept concept, Entity entity) {
  return Column(
    children: [
      Text(concept.label ?? concept.code, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),
      
      // Generate form fields for all attributes
      for (var attribute in concept.attributes.whereType<Attribute>())
        if (!attribute.sensitive && attribute.update)
          buildAttributeField(attribute, entity),
      
      // Generate fields for parent references
      for (var parent in concept.parents.whereType<Parent>())
        if (parent.update)
          buildParentField(parent, entity),
      
      SizedBox(height: 16),
      ElevatedButton(
        child: Text('Save'),
        onPressed: () => saveEntity(entity),
      ),
    ],
  );
}

Widget buildAttributeField(Attribute attribute, Entity entity) {
  final value = entity.getAttribute(attribute.code);
  
  // Generate appropriate field based on type
  if (attribute.type?.code == 'String') {
    return TextFormField(
      decoration: InputDecoration(labelText: attribute.label ?? attribute.code),
      initialValue: value as String?,
      validator: attribute.required 
        ? (value) => value == null || value.isEmpty ? 'Required' : null
        : null,
      onChanged: (newValue) => entity.setAttribute(attribute.code, newValue),
    );
  } else if (attribute.type?.code == 'bool') {
    return CheckboxListTile(
      title: Text(attribute.label ?? attribute.code),
      value: value as bool? ?? false,
      onChanged: (newValue) => entity.setAttribute(attribute.code, newValue),
    );
  }
  // Additional type handling...
  
  return Container(); // Fallback
}
```

## Real-World Applications of Meta-Modeling

Meta-modeling with concepts is particularly valuable in several scenarios:

### 1. Dynamic Domain Models

When your domain model needs to evolve at runtime:
- Content management systems with custom fields
- Customer-configurable business rules
- Multi-tenant applications with tenant-specific models

### 2. Complex Domain Structures

When your domain has complex structural patterns:
- Deep object hierarchies with common behaviors
- Abstract domain patterns that repeat across entities
- Cross-cutting concerns that affect multiple domain objects

### 3. Generative Applications

When you need to generate code, UIs, or other artifacts:
- Admin panel generation
- API documentation generation
- Code scaffolding
- Database schema evolution

### 4. Domain-Expert Facing Systems

When domain experts need to understand or modify the model:
- Visual domain editors
- Business rule configuration
- Domain model visualization

## Conclusion

EDNet Core's meta-modeling capabilities through the `Concept` class provide a powerful approach to domain modeling that goes beyond traditional object-oriented programming. By modeling not just the objects in your domain but the structure of those objects themselves, you gain flexibility, expressiveness, and powerful runtime capabilities.

This meta-modeling approach enables rich validation, introspection, and dynamic behavior that can evolve with your domain, making it ideal for complex business applications where the domain model is at the heart of the system.

In the next article, we'll explore how EDNet Core implements policies and rules to enforce domain logic across your model.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 
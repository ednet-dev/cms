# EDNetCoreDSL JSON Schema

This is the JSON schema for the execution of the EDNetCoreDSL language in EDNetCore.

## Definitions

### Attribute

Attribute definition for a Concept. Defines a single attribute of a Concept, including its sequence number, category, name, data type, initial value, and whether it is required or contains sensitive information.

- sequence: The order in which the attribute appears in the UI.
- category: The category of the attribute (e.g. identifier, required, attribute).
- name: The name of the attribute.
- type: The data type of the attribute (e.g. String, bool).
- init: The initial value of the attribute.
- essential: Whether this attribute is required.
- sensitive: Whether this attribute contains sensitive information.

### Box
Concept definition. Defines a single Concept, including its name, whether it is the entry Concept, its position and size on the canvas, and an array of attributes defining the Concept.

- name: The name of the Concept.
- entry: Whether this is the entry Concept (Aggregate root) for the model.
- x: The x-coordinate of the top-left corner of the canvas artifact.
- y: The y-coordinate of the top-left corner of the canvas artifact.
- width: The width of the canvas artifact.
- height: The height of the canvas artifact.
- items: An array of attributes defining the Concept.
-

### Relationship
Relationship between two Concepts. Defines a relationship between two Concepts, including the names of the Concepts, the name of the relationship, the minimum and maximum number of instances of the second Concept, the name of the inverse relationship, and whether the relationship involves an identifier from the second Concept.

- from: The name of the first Concept in the relationship.
- to: The name of the second Concept in the relationship.
- fromToName: The name of the relationship.
- fromToMin: The minimum number of instances of the second Concept in the relationship.
- fromToMax: The maximum number of instances of the second Concept in the relationship.
- toFromName: The name of the inverse relationship.
- toFromMin: The minimum number of instances of the first Concept in the inverse relationship.
- toFromMax: The maximum number of instances of the first Concept in the inverse relationship.
- category: The category of the relationship.
- internal: Whether the relationship is internal to the model.
- fromToId: Indicates whether the relationship involves an identifier from the second Concept.
- toFromId: Indicates whether the inverse relationship involves an identifier from the first Concept.

## Properties

### width

The width of the canvas.

### lines

An array of relationships between Concepts.

### height

The height of the canvas.

### boxes

Array of EDNetCore Concepts.

## Required Properties

- width
- lines
- height
- boxes

In the EDNetCore architecture, relationships between concepts are modeled using associations, which can be either
unary (where a concept is associated with itself) or binary (where two concepts are associated with each other). Binary
associations can be further classified into simple binary associations and identifying associations.

Identifying associations are a special type of binary association in which one of the participating concepts (called the
identified concept!) contains an attribute that serves as a unique identifier for instances of the other concept. In
other words, the identifier of the identified concept is used as a foreign key in the identifying concept to establish
the relationship between them.

In the context of the JSON schema,the "fromToId" and "toFromId" properties indicate whether an identifying
association exists between two concepts in a binary relationship. If "fromToId" is true, it means that the first
concept in the relationship contains an attribute that serves as an identifier for instances of the second concept.

Similarly, if "toFromId" is true, it means that the second concept in the relationship contains an attribute that
serves as an identifier for instances of the first concept.

The internal flag indicates whether the relationship is internal or external. An internal relationship is one that connects concepts within the same model, while an external relationship connects concepts from different models.

The inheritance flag indicates whether the relationship represents an inheritance relationship between two concepts. Inheritance relationships indicate that one concept is a specialization of another, and typically involve the use of subclasses and superclasses.

The reflexive flag indicates whether the relationship is reflexive. A reflexive relationship is one where a concept can be related to itself.

The twin flag indicates whether the relationship is a twin relationship. A twin relationship is a special type of relationship where two concepts are related to each other in a mutually exclusive manner. For example, if we have two concepts A and B, a twin relationship would allow A to be related to B and vice versa, but only one of those relationships can exist at a time.

The opposite field is a reference to the opposite neighbor of the relationship. In a bidirectional relationship, there are two neighbors, and this field indicates the opposite neighbor of the current relationship.
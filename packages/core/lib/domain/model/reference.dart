part of ednet_core;

/// A class representing a reference to a parent entity in the domain model.
///
/// The [Reference] class is used to maintain relationships between entities by storing:
/// - The parent entity's OID (Object Identifier)
/// - The parent entity's concept code
/// - The entry concept code of the parent entity
///
/// This class is particularly useful in:
/// - Maintaining entity relationships
/// - Navigating between related entities
/// - Persistence and serialization scenarios
/// - Cross-aggregate references
///
/// Example usage:
/// ```dart
/// final reference = Reference(
///   '1234567890',  // parent OID timestamp
///   'Product',     // parent concept code
///   'Entry'        // entry concept code
/// );
///
/// final parentOid = reference.oid;
/// ```
class Reference implements Serializable {
  /// The string representation of the parent entity's OID timestamp.
  final String parentOidString;

  /// The code identifying the parent entity's concept.
  final String parentConceptCode;

  /// The code identifying the entry concept of the parent entity.
  final String entryConceptCode;

  /// Creates a new [Reference] instance.
  ///
  /// [parentOidString] is the string representation of the parent entity's OID timestamp.
  /// [parentConceptCode] is the code identifying the parent entity's concept.
  /// [entryConceptCode] is the code identifying the entry concept of the parent entity.
  Reference(
      this.parentOidString, this.parentConceptCode, this.entryConceptCode);

  /// Creates a reference from an entity.
  ///
  /// This factory method creates a reference directly from an entity,
  /// making it easier to establish relationships between entities.
  ///
  /// [entity] is the entity to create a reference to.
  /// Returns a new [Reference] to the entity.
  factory Reference.fromEntity(Entity entity) {
    return Reference(
      entity.oid.toString(),
      entity.concept.code,
      entity.concept.entryConcept.code,
    );
  }

  /// Gets the [Oid] object from the parent OID string.
  ///
  /// Converts the string timestamp to an integer and creates a new [Oid] instance.
  /// Throws [TypeException] if the OID string cannot be parsed as an integer.
  Oid get oid {
    int parentTimeStamp;
    try {
      parentTimeStamp = int.parse(parentOidString);
    } on FormatException catch (e) {
      throw TypeException('$parentConceptCode parent oid is not int: $e');
    }
    return Oid.ts(parentTimeStamp);
  }

  /// Returns a string representation of this reference.
  ///
  /// Returns a more detailed string representation that includes
  /// both the parent concept code and the OID.
  @override
  String toString() {
    return '$parentConceptCode:$parentOidString';
  }

  /// Compares this reference with [other] for equality.
  ///
  /// Two references are considered equal if they have:
  /// - The same parent OID string
  /// - The same parent concept code
  /// - The same entry concept code
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Reference) return false;
    
    return parentOidString == (other as Reference).parentOidString &&
        parentConceptCode == other.parentConceptCode &&
        entryConceptCode == other.entryConceptCode;
  }

  /// Computes the hash code for this reference.
  ///
  /// Uses all fields for hash code calculation to ensure proper distribution.
  @override
  int get hashCode => 
      Object.hash(parentOidString, parentConceptCode, entryConceptCode);

  /// Converts this reference to a JSON map.
  ///
  /// This method implements the [Serializable] interface and provides
  /// a standardized way to serialize references for persistence or
  /// communication purposes.
  @override
  Map<String, dynamic> toJson() {
    return {
      'oid': parentOidString,
      'concept': parentConceptCode,
      'entry': entryConceptCode,
    };
  }

  /// Creates a reference from a JSON map.
  ///
  /// This static method provides a standardized way to deserialize
  /// references from JSON data.
  ///
  /// [json] is the JSON map to deserialize.
  /// Returns a new [Reference] instance.
  static Reference fromJson(Map<String, dynamic> json) {
    return Reference(
      json['oid'] as String,
      json['concept'] as String,
      json['entry'] as String,
    );
  }

  /// Converts this reference to a graph structure.
  ///
  /// Returns a map containing all the reference's properties, which can be
  /// useful for serialization or visualization purposes.
  Map<String, dynamic> toGraph() {
    return {
      'parentOidString': parentOidString,
      'parentConceptCode': parentConceptCode,
      'entryConceptCode': entryConceptCode
    };
  }
  
  /// Returns true if this reference can be resolved in the given model entries.
  ///
  /// This method attempts to find the referenced entity in the model entries.
  ///
  /// [modelEntries] is the collection of model entries to search in.
  /// Returns true if the referenced entity exists, false otherwise.
  bool isResolvable(IModelEntries modelEntries) {
    var entity = modelEntries.internalSingle(entryConceptCode, oid);
    return entity != null;
  }

  /// Resolves this reference to the actual entity in the given model entries.
  ///
  /// This method retrieves the referenced entity from the model entries.
  ///
  /// [modelEntries] is the collection of model entries to search in.
  /// Returns the referenced entity if found, null otherwise.
  Entity? resolve(IModelEntries modelEntries) {
    return modelEntries.internalSingle(entryConceptCode, oid);
  }
}

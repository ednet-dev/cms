part of ednet_core;

/// A class representing a reference to a parent entity in the domain model.
///
/// The [Reference] class is used to maintain relationships between entities by storing:
/// - The parent entity's OID (Object Identifier)
/// - The parent entity's concept code
/// - The entry concept code of the parent entity
///
/// This class is particularly useful in maintaining entity relationships and
/// navigating between related entities in the domain model.
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
class Reference {
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
  /// Currently returns just the parent OID string, but this could be enhanced
  /// to provide more detailed information about the reference.
  @override
  String toString() {
    return parentOidString;
  }

  /// Compares this reference with [other] for equality.
  ///
  /// Two references are considered equal if they have:
  /// - The same parent OID string
  /// - The same parent concept code
  /// - The same entry concept code
  @override
  bool operator ==(Object other) {
    return this.parentOidString == (other as Reference).parentOidString &&
        this.parentConceptCode == other.parentConceptCode &&
        this.entryConceptCode == other.entryConceptCode;
  }

  /// Computes the hash code for this reference.
  ///
  /// Currently only uses the parent OID string for hashing, but this could be
  /// enhanced to include all fields for better distribution.
  @override
  int get hashCode => parentOidString.hashCode;

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
}

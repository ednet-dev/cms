part of ednet_core;

/// Interface for domain entity identifiers.
///
/// The [IId] interface defines the contract for entity identifiers in the domain model.
/// An identifier can be composed of:
/// - References to parent entities (through [Reference] objects)
/// - Attribute values that form part of the identifier
///
/// The interface extends [Comparable] to allow identifiers to be ordered.
///
/// Example usage:
/// ```dart
/// class ProductId implements IId<ProductId> {
///   final Concept concept;
///   final Map<String, Reference?> references;
///   final Map<String, Object?> attributes;
///
///   ProductId(this.concept)
///       : references = {},
///         attributes = {};
///
///   @override
///   Concept get concept => concept;
///
///   @override
///   int get referenceLength => references.length;
///
///   @override
///   int get attributeLength => attributes.length;
///
///   @override
///   int get length => referenceLength + attributeLength;
///
///   @override
///   Reference? getReference(String code) => references[code];
///
///   @override
///   void setReference(String code, Reference reference) {
///     references[code] = reference;
///   }
///
///   @override
///   Object? getAttribute(String code) => attributes[code];
///
///   @override
///   void setAttribute(String code, Object attribute) {
///     attributes[code] = attribute;
///   }
///
///   @override
///   int compareTo(ProductId other) {
///     // Implement comparison logic
///     return 0;
///   }
/// }
/// ```
abstract class IId<T> implements Comparable<T> {
  /// Gets the [Concept] that defines the metadata for this identifier.
  Concept get concept;

  /// Gets the number of parent references in this identifier.
  int get referenceLength;

  /// Gets the number of attributes in this identifier.
  int get attributeLength;

  /// Gets the total number of components (references + attributes) in this identifier.
  int get length;

  /// Gets the reference for the given parent [code].
  Reference? getReference(String code);

  /// Sets the reference for the given parent [code].
  void setReference(String code, Reference reference);

  /// Gets the attribute value for the given attribute [code].
  Object? getAttribute(String code);

  /// Sets the attribute value for the given attribute [code].
  void setAttribute(String code, Object attribute);
}

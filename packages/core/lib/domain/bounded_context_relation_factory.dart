part of ednet_core;

/// A factory for creating bounded context relationships.
///
/// This factory provides a centralized way to create relationships between
/// bounded contexts, ensuring consistent creation and initialization.
///
/// Example usage:
/// ```dart
/// final factory = BoundedContextRelationFactory();
/// final relation = factory.createRelation(
///   BoundedContextRelationType.PUBLISHER_SUBSCRIBER,
///   sourceContext,
///   targetContext,
/// );
/// ```
class BoundedContextRelationFactory {
  /// Creates a new relationship between two bounded contexts.
  ///
  /// Parameters:
  /// - [type]: The type of relationship to create
  /// - [source]: The source context
  /// - [target]: The target context
  ///
  /// Returns:
  /// A new relationship of the specified type
  ///
  /// Throws:
  /// - [ContextException] if the relationship type is invalid
  IBoundedContextRelation createRelation(
    BoundedContextRelationType type,
    BoundedContext source,
    BoundedContext target,
  ) {
    switch (type) {
      case BoundedContextRelationType.PUBLISHER_SUBSCRIBER:
        return PublisherSubscriberRelation(source, target);
      case BoundedContextRelationType.PARTNERS:
        return PartnersRelation(source, target);
      case BoundedContextRelationType.SHARED_KERNEL:
        return SharedKernelRelation(source, target);
      case BoundedContextRelationType.CUSTOMER_SUPPLIER:
        return CustomerSupplierRelation(source, target);
      case BoundedContextRelationType.CONFORMIST:
        return ConformistRelation(source, target);
      case BoundedContextRelationType.ANTICORRUPTION_LAYER:
        return AnticorruptionLayerRelation(source, target);
      case BoundedContextRelationType.OPEN_HOST_SERVICE:
        return OpenHostServiceRelation(source, target);
      case BoundedContextRelationType.PUBLISHED_LANGUAGE:
        return PublishedLanguageRelation(source, target);
      case BoundedContextRelationType.SEPARATE_WAYS:
        return SeparateWaysRelation(source, target);
      case BoundedContextRelationType.BIG_BALL_OF_MUD:
        return BigBallOfMudRelation(source, target);
      default:
        throw ContextException('Invalid relationship type: $type');
    }
  }
} 
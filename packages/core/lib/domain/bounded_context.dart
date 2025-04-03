// part of ednet_core;
//
// /// A collection of [BoundedContext] instances that implements the [Entities] interface.
// ///
// /// The [BoundedContextMap] class manages a collection of bounded contexts, which are
// /// fundamental building blocks in Domain-Driven Design (DDD). Each bounded context
// /// represents a boundary within which a particular domain model applies.
// ///
// /// This class provides functionality for:
// /// - Adding and removing bounded contexts
// /// - Managing relationships between contexts
// /// - Validating context boundaries and relationships
// /// - Enforcing DDD patterns and principles
// ///
// /// Example usage:
// /// ```dart
// /// final contextMap = BoundedContextMap();
// /// final context = BoundedContext(
// ///   name: 'OrderManagement',
// ///   domains: Domains(),
// /// );
// /// contextMap.addContext(context);
// /// ```
// class BoundedContextMap extends Entities<BoundedContext> {
//   /// Adds a [BoundedContext] instance to the map of contexts.
//   ///
//   /// This method:
//   /// - Validates the context's boundaries
//   /// - Ensures no overlapping contexts exist
//   /// - Maintains the integrity of the context map
//   ///
//   /// Throws [ContextException] if the context cannot be added.
//   void addContext(BoundedContext context) {
//     add(context);
//   }
//
//   /// Removes a [BoundedContext] instance from the map of contexts.
//   ///
//   /// This method:
//   /// - Validates that no other contexts depend on this one
//   /// - Ensures clean removal of all relationships
//   /// - Maintains the integrity of the context map
//   ///
//   /// Throws [ContextException] if the context cannot be removed.
//   void removeContext(BoundedContext context) {
//     remove(context);
//   }
// }
//
// /// Represents a bounded context in Domain-Driven Design.
// ///
// /// A [BoundedContext] is a boundary within which a particular domain model applies.
// /// It encapsulates:
// /// - A unique [name] identifying the context
// /// - A collection of [domains] that define the context's scope
// /// - Relationships with other bounded contexts
// /// - Domain rules and invariants
// ///
// /// This class implements the [Entity] interface, providing:
// /// - Unique identification via OID
// /// - Lifecycle management
// /// - Relationship management
// /// - Validation and policy enforcement
// ///
// /// Example usage:
// /// ```dart
// /// final context = BoundedContext(
// ///   name: 'OrderManagement',
// ///   domains: Domains(),
// /// );
// /// context.concept = orderManagementConcept;
// /// ```
// class BoundedContext extends Entity<BoundedContext> {
//   /// The unique name identifying this bounded context.
//   /// This name should be descriptive and reflect the context's purpose.
//   final String name;
//
//   /// The collection of domains that define this context's scope.
//   /// Each domain represents a specific aspect of the business.
//   final Domains domains;
//
//   /// The list of relationships this context has with other contexts.
//   final List<IBoundedContextRelation> _relationships = [];
//
//   /// The list of applications within this context.
//   final Applications applications = Applications();
//
//   /// Creates a new bounded context with the given [name] and [domains].
//   ///
//   /// The [name] should be unique and descriptive.
//   /// The [domains] collection defines the scope of this context.
//   BoundedContext({required this.name, required this.domains});
//
//   /// Returns the list of relationships this context has with other contexts.
//   List<IBoundedContextRelation> get relationships => List.unmodifiable(_relationships);
//
//   /// Adds a relationship with another bounded context.
//   ///
//   /// This method:
//   /// - Validates the relationship
//   /// - Ensures no duplicate relationships exist
//   /// - Registers the relationship with both contexts
//   ///
//   /// Parameters:
//   /// - [relation]: The relationship to add
//   ///
//   /// Throws [ContextException] if the relationship cannot be added.
//   void addRelationship(IBoundedContextRelation relation) {
//     if (relation.source != this && relation.target != this) {
//       throw ContextException('Relationship must involve this context');
//     }
//
//     if (_relationships.any((r) =>
//         r.type == relation.type &&
//         r.source == relation.source &&
//         r.target == relation.target)) {
//       throw ContextException('Duplicate relationship');
//     }
//
//     _relationships.add(relation);
//     relation.register();
//   }
//
//   /// Removes a relationship with another bounded context.
//   ///
//   /// This method:
//   /// - Validates the relationship exists
//   /// - Ensures clean removal of the relationship
//   ///
//   /// Parameters:
//   /// - [relation]: The relationship to remove
//   ///
//   /// Throws [ContextException] if the relationship cannot be removed.
//   void removeRelationship(IBoundedContextRelation relation) {
//     if (!_relationships.contains(relation)) {
//       throw ContextException('Relationship not found');
//     }
//
//     _relationships.remove(relation);
//   }
//
//   /// Adds an application to this bounded context.
//   ///
//   /// This method:
//   /// - Validates the application
//   /// - Ensures no duplicate applications exist
//   ///
//   /// Parameters:
//   /// - [application]: The application to add
//   ///
//   /// Throws [ContextException] if the application cannot be added.
//   void addApplication(Application application) {
//     applications.add(application);
//   }
//
//   /// Removes an application from this bounded context.
//   ///
//   /// This method:
//   /// - Validates the application exists
//   /// - Ensures clean removal of the application
//   ///
//   /// Parameters:
//   /// - [application]: The application to remove
//   ///
//   /// Throws [ContextException] if the application cannot be removed.
//   void removeApplication(Application application) {
//     applications.remove(application);
//   }
// }
//
// /// Represents an application within a bounded context.
// ///
// /// An [Application] is a concrete implementation of business functionality
// /// within a bounded context. It provides:
// /// - Application-specific business logic
// /// - Integration with external systems
// /// - User interface components
// /// - Service implementations
// ///
// /// This class extends [Entity] to provide:
// /// - Unique identification
// /// - Lifecycle management
// /// - Relationship tracking
// /// - Validation capabilities
// class Application extends Entity<Application> {
//   /// The name of this application.
//   final String name;
//
//   /// The description of this application.
//   final String description;
//
//   /// Creates a new application with the given [name] and [description].
//   Application({required this.name, required this.description});
// }
//
// /// A collection of [Application] instances within a bounded context.
// ///
// /// The [Applications] class manages a collection of applications,
// /// providing functionality for:
// /// - Adding and removing applications
// /// - Managing application relationships
// /// - Validating application boundaries
// /// - Enforcing application-specific rules
// class Applications extends Entities<Application> {}
//
// /// Defines possible relationships between bounded contexts in DDD.
// ///
// /// These relationships are fundamental patterns in DDD that define how
// /// bounded contexts interact with each other:
// ///
// /// - [PUBLISHER_SUBSCRIBER]: One context publishes events that others subscribe to
// /// - [PARTNERS]: Contexts work together as equals
// /// - [SHARED_KERNEL]: Contexts share some code and data
// /// - [CUSTOMER_SUPPLIER]: One context is a customer of another
// /// - [CONFORMIST]: One context conforms to another's model
// /// - [ANTICORRUPTION_LAYER]: Translates between two contexts
// /// - [OPEN_HOST_SERVICE]: Provides a standardized protocol for integration
// /// - [PUBLISHED_LANGUAGE]: Defines a common language for communication
// /// - [SEPARATE_WAYS]: Contexts are completely independent
// /// - [BIG_BALL_OF_MUD]: Legacy system with unclear boundaries
// enum BoundedContextRelationType {
//   PUBLISHER_SUBSCRIBER,
//   PARTNERS,
//   SHARED_KERNEL,
//   CUSTOMER_SUPPLIER,
//   CONFORMIST,
//   ANTICORRUPTION_LAYER,
//   OPEN_HOST_SERVICE,
//   PUBLISHED_LANGUAGE,
//   SEPARATE_WAYS,
//   BIG_BALL_OF_MUD
// }
//
// /// Defines the interface for relationships between bounded contexts.
// ///
// /// This interface ensures that all context relationships:
// /// - Have a defined [type] of relationship
// /// - Identify their [source] and [target] contexts
// /// - Can be [register]ed with the appropriate contexts
// ///
// /// Example usage:
// /// ```dart
// /// class PublisherSubscriberRelation implements IBoundedContextRelation {
// ///   @override
// ///   BoundedContextRelationType get type =>
// ///       BoundedContextRelationType.PUBLISHER_SUBSCRIBER;
// ///   // ... implement other required methods
// /// }
// /// ```
// abstract class IBoundedContextRelation {
//   /// The type of relationship between contexts.
//   BoundedContextRelationType get type;
//
//   /// The source context in this relationship.
//   BoundedContext get source;
//
//   /// The target context in this relationship.
//   BoundedContext get target;
//
//   /// Registers this relationship with both contexts.
//   /// This ensures both contexts are aware of the relationship
//   /// and can maintain proper boundaries.
//   void register();
// }
//
// /// Implements a publisher-subscriber relationship between contexts.
// ///
// /// In this pattern:
// /// - The source context publishes events
// /// - The target context subscribes to those events
// /// - Communication is asynchronous and decoupled
// ///
// /// This is useful when:
// /// - Contexts need to be loosely coupled
// /// - Events need to be broadcast to multiple subscribers
// /// - Real-time updates are required
// class PublisherSubscriberRelation implements IBoundedContextRelation {
//   final BoundedContext _source;
//   final BoundedContext _target;
//
//   PublisherSubscriberRelation(this._source, this._target);
//
//   @override
//   BoundedContextRelationType get type =>
//       BoundedContextRelationType.PUBLISHER_SUBSCRIBER;
//
//   @override
//   BoundedContext get source => _source;
//
//   @override
//   BoundedContext get target => _target;
//
//   @override
//   void register() {
//     _source.addRelationship(this);
//     _target.addRelationship(this);
//   }
// }
//
// /// Exception thrown when a bounded context operation fails.
// class ContextException implements Exception {
//   final String message;
//   ContextException(this.message);
//
//   @override
//   String toString() => 'ContextException: $message';
// }
//

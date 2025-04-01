part of ednet_core;

/// A collection of [BoundedContext] instances that implements the [Entities] interface.
///
/// The [BoundedContextMap] class manages a collection of bounded contexts, which are
/// fundamental building blocks in Domain-Driven Design (DDD). Each bounded context
/// represents a boundary within which a particular domain model applies.
///
/// This class provides functionality for:
/// - Adding and removing bounded contexts
/// - Managing relationships between contexts
/// - Validating context boundaries and relationships
/// - Enforcing DDD patterns and principles
///
/// Example usage:
/// ```dart
/// final contextMap = BoundedContextMap();
/// final context = BoundedContext(
///   name: 'OrderManagement',
///   domains: Domains(),
/// );
/// contextMap.addContext(context);
/// ```
class BoundedContextMap extends Entities<BoundedContext> {
  /// Adds a [BoundedContext] instance to the map of contexts.
  /// 
  /// This method:
  /// - Validates the context's boundaries
  /// - Ensures no overlapping contexts exist
  /// - Maintains the integrity of the context map
  /// 
  /// Throws [ContextException] if the context cannot be added.
  void addContext(BoundedContext context) {
    add(context);
  }

  /// Removes a [BoundedContext] instance from the map of contexts.
  /// 
  /// This method:
  /// - Validates that no other contexts depend on this one
  /// - Ensures clean removal of all relationships
  /// - Maintains the integrity of the context map
  /// 
  /// Throws [ContextException] if the context cannot be removed.
  void removeContext(BoundedContext context) {
    remove(context);
  }
}

/// Represents a bounded context in Domain-Driven Design.
///
/// A [BoundedContext] is a boundary within which a particular domain model applies.
/// It encapsulates:
/// - A unique [name] identifying the context
/// - A collection of [domains] that define the context's scope
/// - Relationships with other bounded contexts
/// - Domain rules and invariants
///
/// This class implements the [Entity] interface, providing:
/// - Unique identification via OID
/// - Lifecycle management
/// - Relationship management
/// - Validation and policy enforcement
///
/// Example usage:
/// ```dart
/// final context = BoundedContext(
///   name: 'OrderManagement',
///   domains: Domains(),
/// );
/// context.concept = orderManagementConcept;
/// ```
class BoundedContext extends Entity<BoundedContext> {
  /// The unique name identifying this bounded context.
  /// This name should be descriptive and reflect the context's purpose.
  final String name;

  /// The collection of domains that define this context's scope.
  /// Each domain represents a specific aspect of the business.
  final Domains domains;

  /// Creates a new bounded context with the given [name] and [domains].
  /// 
  /// The [name] should be unique and descriptive.
  /// The [domains] collection defines the scope of this context.
  BoundedContext({required this.name, required this.domains});

  /// Returns null as bounded contexts do not have nested contexts.
  /// This is a placeholder for future extensibility.
  get contexts => null;
}

/// Represents an application within a bounded context.
///
/// An [Application] is a concrete implementation of business functionality
/// within a bounded context. It provides:
/// - Application-specific business logic
/// - Integration with external systems
/// - User interface components
/// - Service implementations
///
/// This class extends [Entity] to provide:
/// - Unique identification
/// - Lifecycle management
/// - Relationship tracking
/// - Validation capabilities
class Application extends Entity<Application> {}

/// A collection of [Application] instances within a bounded context.
///
/// The [Applications] class manages a collection of applications,
/// providing functionality for:
/// - Adding and removing applications
/// - Managing application relationships
/// - Validating application boundaries
/// - Enforcing application-specific rules
class Applications extends Entities<Application> {}

/// Defines possible relationships between bounded contexts in DDD.
///
/// These relationships are fundamental patterns in DDD that define how
/// bounded contexts interact with each other:
///
/// - [PUBLISHER_SUBSCRIBER]: One context publishes events that others subscribe to
/// - [PARTNERS]: Contexts work together as equals
/// - [SHARED_KERNEL]: Contexts share some code and data
/// - [CUSTOMER_SUPPLIER]: One context is a customer of another
/// - [CONFORMIST]: One context conforms to another's model
/// - [ANTICORRUPTION_LAYER]: Translates between two contexts
/// - [OPEN_HOST_SERVICE]: Provides a standardized protocol for integration
/// - [PUBLISHED_LANGUAGE]: Defines a common language for communication
/// - [SEPARATE_WAYS]: Contexts are completely independent
/// - [BIG_BALL_OF_MUD]: Legacy system with unclear boundaries
enum BoundedContextRelationType {
  PUBLISHER_SUBSCRIBER,
  PARTNERS,
  SHARED_KERNEL,
  CUSTOMER_SUPPLIER,
  CONFORMIST,
  ANTICORRUPTION_LAYER,
  OPEN_HOST_SERVICE,
  PUBLISHED_LANGUAGE,
  SEPARATE_WAYS,
  BIG_BALL_OF_MUD
}

/// Defines the interface for relationships between bounded contexts.
///
/// This interface ensures that all context relationships:
/// - Have a defined [type] of relationship
/// - Identify their [source] and [target] contexts
/// - Can be [register]ed with the appropriate contexts
///
/// Example usage:
/// ```dart
/// class PublisherSubscriberRelation implements IBoundedContextRelation {
///   @override
///   BoundedContextRelationType get type => 
///       BoundedContextRelationType.PUBLISHER_SUBSCRIBER;
///   // ... implement other required methods
/// }
/// ```
abstract class IBoundedContextRelation {
  /// The type of relationship between contexts.
  BoundedContextRelationType get type;

  /// The source context in this relationship.
  BoundedContext get source;

  /// The target context in this relationship.
  BoundedContext get target;

  /// Registers this relationship with both contexts.
  /// This ensures both contexts are aware of the relationship
  /// and can maintain proper boundaries.
  void register();
}

/// Implements a publisher-subscriber relationship between contexts.
///
/// In this pattern:
/// - The source context publishes events
/// - The target context subscribes to those events
/// - Communication is asynchronous and decoupled
///
/// This is useful when:
/// - Contexts need to be loosely coupled
/// - Events need to be broadcast to multiple subscribers
/// - Real-time updates are required
class PublisherSubscriberRelation implements IBoundedContextRelation {
  @override
  BoundedContextRelationType get type =>
      BoundedContextRelationType.PUBLISHER_SUBSCRIBER;

  @override
  BoundedContext get source => throw UnimplementedError();

  @override
  BoundedContext get target => throw UnimplementedError();

  @override
  void register() {}
}

// based on selected criteria attributes of entity, value object or aggregate root and
// based on selected operands which connect two or more criterion's,
// we can build a query which will be used to find the aggregate root
// or entity or value object
// for example:
// Criteria criteria = Criteria()
//   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
//   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
//   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30));
// this criteria will be used to find all users with name John, age greater than 18 and less than 30

// we can also add a criterion which will be used to sort the results
// Criteria criteria = Criteria()
//   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
//   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
//   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
//   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING));
// this criteria will be used to find all users with name John, age greater than 18 and less than 30
// and sort them by age in ascending order

// we can also add a criterion which will be used to limit the number of results
// Criteria criteria = Criteria()
//   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
//   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
//   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
//   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING))
//   ..addCriterion(Criterion('age', Operand.LIMIT, 10));
// this criteria will be used to find all users with name John, age greater than 18 and less than 30
// and sort them by age in ascending order and limit the number of results to 10

// we can also add a criterion which will be used to skip the first n results
// Criteria criteria = Criteria()
//   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
//   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
//   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
//   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING))
//   ..addCriterion(Criterion('age', Operand.LIMIT, 10))
//   ..addCriterion(Criterion('age', Operand.SKIP, 5));
// this criteria will be used to find all users with name John, age greater than 18 and less than 30
// and sort them by age in ascending order and limit the number of results to 10 and skip the first 5 results
// this will return the 6th to 10th result

// we can also add a criterion which will be used to find the aggregate root by its id
// Criteria criteria = Criteria()
//   ..addCriterion(Criterion('id', Operand.EQUAL, '123'));
// this criteria will be used to find the aggregate root with id 123

// class Criteria<IEntity> extends ValueObject {
//   /// Chaining operand for logical connection between two or more [Criteria] statements.
//   Operand chainingOperand = Operand.AND;
//
//   /// Inner operand for logical connection between two or more criteria.
//   Operand innerOperand = Operand.AND;
//
//   /// List of [Criteria] objects bound by [innerOperand].
//   List<Criterion> criteria = [];
//
//   /// Criteria manages limit, sort and pagination of results.
//   int limit;
//   int skip;
//   SortOrder sortOrder;
//   String sortAttribute;
//
//   /// Criteria objects preserve correct pagination and sort order upon getNextPageCriteria() and getPreviousPageCriteria() calls
//   int currentPage = 1;
//   int pageSize = 10;
//
//   void addCriterion(Criterion criterion) {
//     criteria.add(criterion);
//   }
//
//   void removeCriterion(Criterion criterion) {
//     criteria.remove(criterion);
//   }
//
//   void clearCriteria() {
//     criteria.clear();
//   }
//
//   List<Criterion> getCriteria() {
//     return criteria;
//   }
//
//   bool hasCriteria() {
//     return criteria.isNotEmpty;
//   }
//
//   bool hasCriterion(Criterion criterion) {
//     return criteria.contains(criterion);
//   }
//
//   void setLimit(int limit) {
//     this.limit = limit;
//   }
//
//   void setSkip(int skip) {
//     this.skip = skip;
//   }
//
//   void setSortOrder(SortOrder sortOrder) {
//     this.sortOrder = sortOrder;
//   }
//
//   void setSortAttribute(String sortAttribute) {
//     this.sortAttribute = sortAttribute;
//   }
//
//   int getLimit() {
//     return limit;
//   }
//
//   int getSkip() {
//     return skip;
//   }
//
//   SortOrder getSortOrder() {
//     return sortOrder;
//   }
//
//   String getSortAttribute() {
//     return sortAttribute;
//   }
//
//   void setCurrentPage(int currentPage) {
//     this.currentPage = currentPage;
//   }
//
//   void setPageSize(int pageSize) {
//     this.pageSize = pageSize;
//   }
//
//   int getCurrentPage() {
//     return currentPage;
//   }
//
//   int getPageSize() {
//     return pageSize;
//   }
//
//   Criteria(
//       {this.chainingOperand = Operand.AND,
//       this.limit = 0,
//       this.skip = 0,
//       this.sortOrder = SortOrder.ASCENDING,
//       this.sortAttribute = 'id',
//       this.currentPage = 1,
//       this.pageSize = 10})
//       : super(
//           name: 'Criteria',
//           attributes: User,
//           description: 'Criteria for querying entities.',
//           version: '1.0.0',
//         ) {}
//
//   Criteria getNextPageCriteria() {
//     Criteria criteria = this.copyWith();
//     criteria.setCurrentPage(currentPage + 1);
//     criteria.setSkip((currentPage + 1) * pageSize);
//     return criteria;
//   }
//
//   Criteria getPreviousPageCriteria() {
//     Criteria criteria = this.copyWith();
//     criteria.setCurrentPage(currentPage - 1);
//     criteria.setSkip((currentPage - 1) * pageSize);
//     return criteria;
//   }
// }
//
// class Criterion {
//   final String attribute;
//   final Operand operand;
//   final dynamic value;
//
//   Criterion(this.attribute, this.operand, this.value);
// }

// enum Operand { EQUAL, GREATER_THAN, LESS_THAN, SORT, LIMIT, SKIP }

// class Operand {
//   final OperandType operandType;
//
//   const Operand(this.operandType);
//
//   static const Operand EQUAL = Operand(OperandType.EQUAL);
//   static const Operand GREATER_THAN = Operand(OperandType.GREATER_THAN);
//   static const Operand LESS_THAN = Operand(OperandType.LESS_THAN);
//   static const Operand SORT = Operand(OperandType.SORT);
//   static const Operand LIMIT = Operand(OperandType.LIMIT);
//   static const Operand SKIP = Operand(OperandType.SKIP);
//   static const Operand AND = Operand(OperandType.AND);
//   static const Operand OR = Operand(OperandType.OR);
// }
//
// class OperandType {
//   final String value;
//
//   const OperandType(this.value);
//
//   static const OperandType EQUAL = OperandType('EQUAL');
//   static const OperandType GREATER_THAN = OperandType('GREATER_THAN');
//   static const OperandType LESS_THAN = OperandType('LESS_THAN');
//   static const OperandType SORT = OperandType('SORT');
//   static const OperandType LIMIT = OperandType('LIMIT');
//   static const OperandType SKIP = OperandType('SKIP');
//   static const OperandType AND = OperandType('AND');
//   static const OperandType OR = OperandType('OR');
// }
//
// class SortOrder {
//   final String value;
//
//   const SortOrder(this.value);
//
//   static const SortOrder ASCENDING = SortOrder('ASCENDING');
//   static const SortOrder DESCENDING = SortOrder('DESCENDING');
// }

/// Show how chaining of Criteria works on example of building complex query
/// which will be used to find all users with name John, age greater than 18 and less than 30
/// and sort them by age in ascending order and limit the number of results to 10 and skip the first 5 results

/// Criteria class for building query conditions.
class Criteria<T> {
  Operand chainingOperand;
  Operand innerOperand;
  List<Criterion> criteria;
  int limit;
  int skip;
  SortOrder sortOrder;
  String sortAttribute;
  int currentPage;
  int pageSize;

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

  void addCriterion(Criterion criterion) {
    criteria.add(criterion);
  }

  void removeCriterion(Criterion criterion) {
    criteria.remove(criterion);
  }

  void clearCriteria() {
    criteria.clear();
  }

  List<Criterion> getCriteria() {
    return criteria;
  }

  bool hasCriteria() {
    return criteria.isNotEmpty;
  }

  bool hasCriterion(Criterion criterion) {
    return criteria.contains(criterion);
  }

  void setLimit(int limit) {
    this.limit = limit;
  }

  void setSkip(int skip) {
    this.skip = skip;
  }

  void setSortOrder(SortOrder sortOrder) {
    this.sortOrder = sortOrder;
  }

  void setSortAttribute(String sortAttribute) {
    this.sortAttribute = sortAttribute;
  }

  Criteria getNextPageCriteria() {
    return Criteria(
      chainingOperand: chainingOperand,
      innerOperand: innerOperand,
      criteria: criteria,
      limit: limit,
      skip: (currentPage + 1) * pageSize,
      sortOrder: sortOrder,
      sortAttribute: sortAttribute,
      currentPage: currentPage + 1,
      pageSize: pageSize,
    );
  }

  Criteria getPreviousPageCriteria() {
    return Criteria(
      chainingOperand: chainingOperand,
      innerOperand: innerOperand,
      criteria: criteria,
      limit: limit,
      skip: (currentPage - 1) * pageSize,
      sortOrder: sortOrder,
      sortAttribute: sortAttribute,
      currentPage: currentPage - 1,
      pageSize: pageSize,
    );
  }
}

/// Criterion class representing a single query condition.
class Criterion {
  final String attribute;
  final Operand operand;
  final dynamic value;

  Criterion(this.attribute, this.operand, this.value);
}

/// Operand class for different types of query operations.
class Operand {
  final OperandType operandType;

  const Operand(this.operandType);

  static const Operand EQUAL = Operand(OperandType.EQUAL);
  static const Operand GREATER_THAN = Operand(OperandType.GREATER_THAN);
  static const Operand LESS_THAN = Operand(OperandType.LESS_THAN);
  static const Operand SORT = Operand(OperandType.SORT);
  static const Operand LIMIT = Operand(OperandType.LIMIT);
  static const Operand SKIP = Operand(OperandType.SKIP);
  static const Operand AND = Operand(OperandType.AND);
  static const Operand OR = Operand(OperandType.OR);
}

/// OperandType class representing the types of operations.
class OperandType {
  final String value;

  const OperandType(this.value);

  static const OperandType EQUAL = OperandType('EQUAL');
  static const OperandType GREATER_THAN = OperandType('GREATER_THAN');
  static const OperandType LESS_THAN = OperandType('LESS_THAN');
  static const OperandType SORT = OperandType('SORT');
  static const OperandType LIMIT = OperandType('LIMIT');
  static const OperandType SKIP = OperandType('SKIP');
  static const OperandType AND = OperandType('AND');
  static const OperandType OR = OperandType('OR');
}

/// SortOrder class representing the order of sorting.
class SortOrder {
  final String value;

  const SortOrder(this.value);

  static const SortOrder ASCENDING = SortOrder('ASCENDING');
  static const SortOrder DESCENDING = SortOrder('DESCENDING');
}

// class UserCriteria extends Criteria<User> {
//   UserCriteria() : super(chainingOperand: Operand.AND);
// }
//
// final criteria = Criteria<User>()
//   ..addCriterion(Criterion(User.nameAttribute, Operand.EQUAL, 'John'))
//   ..addCriterion(Criterion(User.ageAttribute, Operand.GREATER_THAN, 18))
//   ..addCriterion(Criterion(User.ageAttribute, Operand.LESS_THAN, 30))
//   ..addCriterion(
//       Criterion(User.ageAttribute, Operand.SORT, SortOrder.ASCENDING))
//   ..addCriterion(Criterion(User.ageAttribute, Operand.LIMIT, 10))
//   ..addCriterion(Criterion(User.ageAttribute, Operand.SKIP, 5));

// part of ednet_core;
//
// /// Defines the core repository interface for domain entities.
// ///
// /// The [IRepository] interface provides a contract for:
// /// - Entity retrieval by identity
// /// - Query-based entity search
// /// - Domain-specific query implementations
// ///
// /// This interface follows DDD principles by:
// /// - Abstracting persistence concerns
// /// - Supporting domain-specific queries
// /// - Maintaining entity encapsulation
// ///
// /// Example usage:
// /// ```dart
// /// class UserRepository implements IRepository<User> {
// ///   @override
// ///   User findById(IIdentity identity) {
// ///     // Implementation
// ///   }
// ///
// ///   @override
// ///   List<User> find(IQuery query) {
// ///     // Implementation
// ///   }
// /// }
// /// ```
// abstract class IRepository<T extends Entity> {
//   /// Retrieves an entity by its identity.
//   ///
//   /// Parameters:
//   /// - [identity]: The unique identifier of the entity
//   ///
//   /// Returns:
//   /// The entity if found, null otherwise
//   T findById(IIdentity identity);
//
//   /// Finds entities matching the given query.
//   ///
//   /// Parameters:
//   /// - [query]: The query specification
//   ///
//   /// Returns:
//   /// List of matching entities
//   List<T> find(IQuery query);
// }
//
// /// Defines a query specification for entity retrieval.
// ///
// /// The [IQuery] class provides:
// /// - Query criteria definition
// /// - Domain-specific query implementations
// /// - Query composition support
// ///
// /// Example usage:
// /// ```dart
// /// final query = UserQuery(
// ///   criteria: Criteria<User>(
// ///     filter: UserNameFilter('John'),
// ///     sort: NameSort(SortDirection.asc),
// ///   ),
// /// );
// /// ```
// abstract class IQuery<T extends Entity> {
//   /// The criteria for this query.
//   final ICriteria<T> criteria;
//
//   /// Creates a new query with the given [criteria].
//   const IQuery({criteria}) : criteria = criteria;
// }
//
// /// Example implementation of a domain-specific query.
// class UserQuery extends IQuery<User> {
//   /// Creates a new user query with the given [criteria].
//   const UserQuery({super.criteria});
// }
//
// /// Defines criteria for filtering and sorting entities.
// ///
// /// The [ICriteria] class provides:
// /// - Filter conditions
// /// - Sorting specifications
// /// - Logical operations (AND, OR, NOT)
// ///
// /// Example usage:
// /// ```dart
// /// final criteria = Criteria<User>(
// ///   filter: UserNameFilter('John'),
// ///   sort: NameSort(SortDirection.asc),
// /// );
// /// ```
// abstract class ICriteria<T extends Entity> {
//   /// The filter conditions for this criteria.
//   late IFilter<T> filter;
//
//   /// The sorting specification for this criteria.
//   late ISort<T> sort;
//
//   /// Combines this criteria with another using AND.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria to combine with
//   ///
//   /// Returns:
//   /// A new criteria combining both conditions
//   ICriteria<T> and(ICriteria<T> criteria);
//
//   /// Combines this criteria with another using OR.
//   ///
//   /// Parameters:
//   /// - [criteria]: The criteria to combine with
//   ///
//   /// Returns:
//   /// A new criteria combining both conditions
//   ICriteria<T> or(ICriteria<T> criteria);
//
//   /// Negates this criteria.
//   ///
//   /// Returns:
//   /// A new criteria with negated conditions
//   ICriteria<T> not();
// }
//
// /// Defines sorting behavior for entities.
// ///
// /// The [ISort] class provides:
// /// - Sort attribute specifications
// /// - Sort direction control
// /// - Entity comparison logic
// ///
// /// Example usage:
// /// ```dart
// /// class NameSort implements ISort<User> {
// ///   @override
// ///   List<IAttribute<User>> attributes = [
// ///     UserNameAttribute(SortDirection.asc),
// ///   ];
// ///
// ///   @override
// ///   bool sort(User entity) {
// ///     // Implementation
// ///   }
// /// }
// /// ```
// abstract class ISort<T extends Entity> {
//   /// The attributes to sort by.
//   late List<IAttribute<T>> attributes;
//
//   /// Determines if an entity should be sorted.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to evaluate
//   ///
//   /// Returns:
//   /// true if the entity should be included in sorting
//   bool sort(T entity);
// }
//
// /// Represents a logical AND operation between criteria.
// abstract class And<T> extends Operand {
//   /// Creates a new AND operation between [left] and [right] criteria.
//   And(super.left, super.right);
// }
//
// /// Defines an attribute for entity operations.
// ///
// /// The [IAttribute] class provides:
// /// - Attribute value access
// /// - Type safety
// /// - Domain-specific implementations
// ///
// /// Example usage:
// /// ```dart
// /// class UserNameAttribute implements IAttribute<User> {
// ///   @override
// ///   late String value;
// /// }
// /// ```
// abstract class IAttribute<T> {
//   /// The value of this attribute.
//   late T value;
// }
//
// /// Defines filtering behavior for entities.
// ///
// /// The [IFilter] class provides:
// /// - Filter conditions
// /// - Entity evaluation
// /// - Domain-specific implementations
// ///
// /// Example usage:
// /// ```dart
// /// class UserNameFilter implements IFilter<User> {
// ///   @override
// ///   bool filter(User entity) {
// ///     return entity.name.contains('John');
// ///   }
// /// }
// /// ```
// abstract class IFilter<T extends Entity> {
//   /// Determines if an entity matches the filter.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to evaluate
//   ///
//   /// Returns:
//   /// true if the entity matches the filter
//   bool filter(T entity);
// }
//
// /// Base class for domain entities.
// ///
// /// The [Entity] class provides:
// /// - Identity management
// /// - Domain behavior
// /// - Entity lifecycle
// ///
// /// Example usage:
// /// ```dart
// /// class User extends Entity {
// ///   final String name;
// ///
// ///   User({required this.name});
// /// }
// /// ```
// abstract class Entity with IIdentity {}
//
// /// Provides identity management for entities.
// ///
// /// The [IIdentity] mixin provides:
// /// - Unique identifier
// /// - Identity comparison
// /// - Type safety
// ///
// /// Example usage:
// /// ```dart
// /// class UserId implements IIdentity<String> {
// ///   @override
// ///   late String id;
// /// }
// /// ```
// mixin IIdentity<T> {
//   /// The unique identifier.
//   late T id;
// }
//
// /// Example implementation of a domain entity.
// class User extends Entity {
//   /// The user's name.
//   final name;
//
//   /// Creates a new user with the given [name].
//   User({
//     required this.name,
//   });
// }
//
// /// Represents a contains operation for string matching.
// class Contains {
//   /// The value to match against.
//   final String value;
//
//   /// Creates a new contains operation with the given [value].
//   Contains(this.value);
// }
//
// /// Represents a binary operation between values.
// ///
// /// The [Operand] class provides:
// /// - Left and right operands
// /// - Operation composition
// /// - Value comparison
// ///
// /// Example usage:
// /// ```dart
// /// final operand = And(
// ///   IsEqual('John'),
// ///   Contains('Doe'),
// /// );
// /// ```
// class Operand<T> {
//   /// The left operand.
//   final T left;
//
//   /// The right operand, if any.
//   final T? right;
//
//   /// Creates a new operand with [left] and optional [right] values.
//   const Operand(this.left, this.right);
//
//   @override
//   bool operator ==(Object other) {
//     if (other is Operand) {
//       return left == other.left && right == other.right;
//     }
//     return false;
//   }
// }
//
// /// Represents an equality comparison operation.
// class IsEqual extends Operand<String> {
//   /// The value to compare against.
//   final String value;
//
//   /// Creates a new equality comparison with the given [value].
//   IsEqual(this.value) : super(value, value);
//
//   @override
//   bool operator ==(Object other) {
//     if (other is IsEqual) {
//       return value == other.value;
//     }
//     return false;
//   }
// }
//
// /// Defines sorting behavior for entities.
// ///
// /// The [Sort] class provides:
// /// - Sort attribute specifications
// /// - Sort direction control
// /// - Entity comparison logic
// ///
// /// Example usage:
// /// ```dart
// /// final sort = Sort([
// ///   SortAttribute(
// ///     value: user.name,
// ///     direction: SortDirection.asc,
// ///   ),
// /// ]);
// /// ```
// class Sort {
//   /// The attributes to sort by.
//   final List<SortAttribute> attributes;
//
//   /// Creates a new sort with the given [attributes].
//   Sort(this.attributes);
// }
//
// /// Defines the direction of sorting.
// enum SortDirection {
//   /// Sort in ascending order.
//   asc,
//
//   /// Sort in descending order.
//   desc,
// }
//
// /// Defines a sort attribute with direction.
// ///
// /// The [SortAttribute] class provides:
// /// - Attribute value
// /// - Sort direction
// /// - Type safety
// ///
// /// Example usage:
// /// ```dart
// /// final attribute = SortAttribute(
// ///   value: user.name,
// ///   direction: SortDirection.asc,
// /// );
// /// ```
// class SortAttribute<T> {
//   /// The value to sort by.
//   final T value;
//
//   /// The direction to sort in.
//   final SortDirection direction;
//
//   /// Creates a new sort attribute with [value] and [direction].
//   SortAttribute({
//     required this.value,
//     required this.direction,
//   });
// }

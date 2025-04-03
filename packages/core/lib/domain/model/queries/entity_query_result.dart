// part of ednet_core;
//
// /// Represents a query result specifically for entity operations.
// ///
// /// This class extends the standard [QueryResult] to provide capabilities
// /// specifically designed for working with entities, including support for
// /// converting results to [Entities] collections.
// ///
// /// Type parameters:
// /// - [T]: The type of entity this result contains
// ///
// /// Example usage:
// /// ```dart
// /// final result = EntityQueryResult.success<Task>(
// ///   taskEntities,
// ///   concept: taskConcept,
// ///   metadata: {'totalCount': 42}
// /// );
// ///
// /// // Convert to Entities collection
// /// final entities = result.asEntities;
// /// ```
// class EntityQueryResult<T extends Entity<T>> extends QueryResult<List<T>> {
//   /// The concept that defines the entities in this result.
//   final Concept concept;
//
//   /// Creates a new entity query result.
//   ///
//   /// Parameters:
//   /// - [isSuccess]: Whether the query was successful
//   /// - [entities]: List of entities in the result (null if query failed)
//   /// - [errorMessage]: Error message (null if query succeeded)
//   /// - [concept]: The concept defining the entities
//   /// - [metadata]: Additional metadata for the result
//   EntityQueryResult({
//     required bool isSuccess,
//     List<T>? entities,
//     String? errorMessage,
//     required this.concept,
//     Map<String, dynamic> metadata = const {},
//   }) : super(
//     isSuccess: isSuccess,
//     data: entities,
//     errorMessage: errorMessage,
//     metadata: metadata,
//     conceptCode: concept.code,
//   );
//
//   /// Creates a successful entity query result.
//   ///
//   /// Parameters:
//   /// - [entities]: List of entities in the result
//   /// - [concept]: The concept defining the entities
//   /// - [metadata]: Additional metadata for the result
//   factory EntityQueryResult.success(
//     List<T> entities, {
//     required Concept concept,
//     Map<String, dynamic> metadata = const {},
//   }) {
//     return EntityQueryResult(
//       isSuccess: true,
//       entities: entities,
//       concept: concept,
//       metadata: metadata,
//     );
//   }
//
//   /// Creates a failed entity query result.
//   ///
//   /// Parameters:
//   /// - [errorMessage]: The error message
//   /// - [concept]: The concept defining the entities
//   /// - [metadata]: Additional metadata for the result
//   factory EntityQueryResult.failure(
//     String errorMessage, {
//     required Concept concept,
//     Map<String, dynamic> metadata = const {},
//   }) {
//     return EntityQueryResult(
//       isSuccess: false,
//       errorMessage: errorMessage,
//       concept: concept,
//       metadata: metadata,
//     );
//   }
//
//   /// Creates an empty successful entity query result.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept defining the entities
//   /// - [metadata]: Additional metadata for the result
//   factory EntityQueryResult.empty({
//     required Concept concept,
//     Map<String, dynamic> metadata = const {},
//   }) {
//     return EntityQueryResult(
//       isSuccess: true,
//       entities: [],
//       concept: concept,
//       metadata: metadata,
//     );
//   }
//
//   /// Converts the result data to an [Entities] collection.
//   ///
//   /// This provides a convenient way to work with the result in the
//   /// EDNet Core entity framework, taking advantage of [Entities]
//   /// collection capabilities.
//   ///
//   /// Returns an [Entities] collection containing the result data.
//   Entities<T> get asEntities {
//     final result = Entities<T>();
//     result.concept = concept;
//     if (data != null) {
//       result.addAll(data!);
//     }
//     return result;
//   }
//
//   /// Creates a new result with updated pagination information.
//   ///
//   /// This overrides the base class method to ensure the returned
//   /// result is an [EntityQueryResult].
//   ///
//   /// Parameters:
//   /// - [page]: The current page number
//   /// - [pageSize]: The number of items per page
//   /// - [totalCount]: The total number of items
//   ///
//   /// Returns a new entity query result with updated metadata
//   @override
//   EntityQueryResult<T> withPagination({
//     required int page,
//     required int pageSize,
//     required int totalCount,
//   }) {
//     final newMetadata = Map<String, dynamic>.from(metadata)
//       ..addAll({
//         'page': page,
//         'pageSize': pageSize,
//         'totalCount': totalCount,
//         'totalPages': (totalCount / pageSize).ceil(),
//       });
//
//     return EntityQueryResult(
//       isSuccess: isSuccess,
//       entities: data,
//       errorMessage: errorMessage,
//       concept: concept,
//       metadata: newMetadata,
//     );
//   }
// }
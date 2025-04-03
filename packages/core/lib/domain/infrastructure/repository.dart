// /// Repository implementations for data persistence.
// ///
// /// This library provides repository implementations for managing domain entities:
// /// - Generic repository interface
// /// - Destructive repository for mutable data
// /// - Non-destructive repository for immutable data
// /// - Repository utilities and helpers
// ///
// /// The repository system supports:
// /// - CRUD operations on domain entities
// /// - Different persistence strategies
// /// - Transaction management
// /// - Query capabilities
// ///
// /// Example usage:
// /// ```dart
// /// import 'package:ednet_core/domain/infrastructure/repository.dart';
// ///
// /// // Create a repository
// /// final repository = DestructiveRepository<Order>();
// ///
// /// // Perform operations
// /// await repository.save(order);
// /// final orders = await repository.findAll();
// /// ```
// library repository;
//
// /// Exports destructive repository implementation for mutable data.
// part 'repository/destructive/destructive_repository.dart';
//
// /// Exports repository interfaces and contracts.
// part 'repository/interfaces/repository.dart';
//
// /// Exports non-destructive repository implementation for immutable data.
// part 'repository/non_destructive/non_destructive_repository.dart';

/// EDNet Drift repository package.
///
/// This package provides Drift/SQLite repository implementations for EDNet Core.
library drift;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:ednet_core/ednet_core.dart';

// Main components
part 'src/ednet_drift_repository.dart';
part 'src/ednet_drift_repository_factory.dart';

// Query-specific components
part 'src/drift_query.dart';
part 'src/drift_query_handler.dart';

/// Creates a new Drift repository factory.
///
/// Parameters:
/// - [domain]: The domain model
/// - [sqlitePath]: The path to the SQLite database file
/// - [schemaVersion]: Optional schema version for the database
/// - [queryDispatcher]: Optional query dispatcher
///
/// Returns:
/// A new Drift repository factory
RepositoryFactory createDriftRepositoryFactory({
  required Domain domain,
  required String sqlitePath,
  int? schemaVersion,
  QueryDispatcher? queryDispatcher,
}) {
  return EDNetDriftRepositoryFactory(
    domain: domain,
    sqlitePath: sqlitePath,
    schemaVersion: schemaVersion,
    queryDispatcher: queryDispatcher,
  );
}

/// Creates a Drift query for a specific concept.
///
/// Parameters:
/// - [name]: The name of the query
/// - [concept]: The concept to query
/// - [rawSql]: Optional raw SQL WHERE clause
/// - [sqlVariables]: Optional variables for the raw SQL query
/// - [parameters]: Optional query parameters
///
/// Returns:
/// A Drift query
DriftQuery createDriftQuery(
  String name,
  Concept concept, {
  String? rawSql,
  List<Variable>? sqlVariables,
  Map<String, dynamic> parameters = const {},
}) {
  return DriftQuery.forConcept(
    name,
    concept,
    rawSql: rawSql,
    sqlVariables: sqlVariables,
    parameters: parameters,
  );
}

/// Creates a Drift repository for a specific concept.
///
/// Parameters:
/// - [domain]: The domain model
/// - [concept]: The concept to create a repository for
/// - [sqlitePath]: The path to the SQLite database file
/// - [schemaVersion]: Optional schema version for the database
/// - [queryDispatcher]: Optional query dispatcher
///
/// Returns:
/// A Drift repository
Repository<Entity> createDriftRepository({
  required Domain domain,
  required Concept concept,
  required String sqlitePath,
  int? schemaVersion,
  QueryDispatcher? queryDispatcher,
}) {
  return EDNetDriftRepository(
    domain: domain,
    sqlitePath: sqlitePath,
    schemaVersion: schemaVersion,
    queryDispatcher: queryDispatcher,
    concept: concept,
  );
} 
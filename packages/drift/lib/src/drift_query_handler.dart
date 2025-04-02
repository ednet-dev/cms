import 'dart:async';

import 'package:drift/drift.dart';
import 'package:ednet_core/ednet_core.dart';

import 'drift_query.dart';
import 'ednet_drift_repository.dart';

/// Query handler for Drift repositories that integrates with EDNet Core's unified query system.
///
/// This handler translates EDNet queries into Drift/SQLite queries, handling both
/// static typed tables and dynamic concept-based tables.
///
/// Type parameters:
/// - [T]: The entity type
/// - [Q]: The query type
/// - [R]: The result type
///
/// Example usage:
/// ```dart
/// final handler = DriftQueryHandler<User, FindUserQuery, EntityQueryResult<User>>(
///   driftRepository,
///   tableName: 'users',
///   isStatic: true,
///   mapToEntity: (row) => User.fromRow(row),
/// );
///
/// queryDispatcher.registerHandler<FindUserQuery, EntityQueryResult<User>>(handler);
/// ```
class DriftQueryHandler<T extends Entity, Q extends IQuery, R extends EntityQueryResult<T>>
    extends ApplicationQueryHandler<Q, R> {
  
  /// The drift repository instance.
  final EDNetDriftRepository repository;
  
  /// The table name in the database.
  final String tableName;
  
  /// Whether this is a static table or a dynamic concept table.
  final bool isStatic;
  
  /// The associated EDNet concept.
  final Concept? concept;
  
  /// Function to map query parameters to SQL WHERE clauses.
  final Expression<bool> Function(Q query)? buildWhereExpression;
  
  /// Function to map database rows to entity objects.
  final T Function(Map<String, dynamic> row) mapToEntity;
  
  /// Creates a new drift query handler.
  ///
  /// Parameters:
  /// - [repository]: The drift repository
  /// - [tableName]: The name of the table in the database
  /// - [isStatic]: Whether this is a static table or a dynamic concept table
  /// - [concept]: The associated concept (optional, required for concept queries)
  /// - [buildWhereExpression]: Optional function to build WHERE expressions
  /// - [mapToEntity]: Function to map database rows to entity objects
  DriftQueryHandler({
    required this.repository,
    required this.tableName,
    required this.isStatic,
    required this.mapToEntity,
    this.concept,
    this.buildWhereExpression,
  });
  
  @override
  Future<R> processQuery(Q query) async {
    try {
      final db = repository.database;
      final parameters = query is Query ? query.getParameters() : <String, dynamic>{};
      
      // Handle DriftQuery specifically
      if (query is DriftQuery) {
        return await _processDriftQuery(query);
      }
      
      // Extract pagination parameters
      final page = parameters['page'] as int?;
      final pageSize = parameters['pageSize'] as int?;
      
      // Extract sorting parameters
      final sortBy = parameters['sortBy'] as String?;
      final sortDirection = parameters['sortDirection'] as String?;
      final isAscending = sortDirection != 'desc';
      
      // Build the query
      List<Map<String, dynamic>> rows;
      int totalCount = 0;
      
      if (isStatic) {
        // For static tables, use the typed API if possible
        // This is a simplified approach - in practice, you'd need to handle
        // different static tables with specific logic
        
        // Build a select statement using the custom select API
        final stmt = db.customSelect(
          'SELECT * FROM $tableName',
        );
        
        // Apply WHERE clause if needed
        if (buildWhereExpression != null) {
          // Note: In a real implementation, you'd need to convert the Expression to SQL
          // This is a simplification for the example
          final whereClause = 'WHERE ...'; // Convert expression to SQL
          stmt.query = 'SELECT * FROM $tableName $whereClause';
        } else {
          // Apply filters from parameters
          final whereClauses = <String>[];
          final variables = <Variable>[];
          
          parameters.forEach((key, value) {
            if (!['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key) && value != null) {
              whereClauses.add('$key = ?');
              variables.add(Variable(value));
            }
          });
          
          if (whereClauses.isNotEmpty) {
            final whereClause = whereClauses.join(' AND ');
            stmt.query = 'SELECT * FROM $tableName WHERE $whereClause';
            stmt.variables = variables;
          }
        }
        
        // Handle sorting
        if (sortBy != null) {
          final orderByClause = '$sortBy ${isAscending ? 'ASC' : 'DESC'}';
          stmt.query += ' ORDER BY $orderByClause';
        }
        
        // Handle pagination
        if (page != null && pageSize != null) {
          final offset = (page - 1) * pageSize;
          stmt.query += ' LIMIT $pageSize OFFSET $offset';
          
          // Get total count for pagination metadata
          final countStmt = db.customSelect(
            'SELECT COUNT(*) as count FROM $tableName',
          );
          final countResult = await countStmt.getSingle();
          totalCount = countResult.read<int>('count');
        }
        
        // Execute the query
        rows = await stmt.get();
      } else {
        // For dynamic concept tables
        if (concept == null) {
          throw ArgumentError('Concept must be provided for dynamic tables');
        }
        
        // Use the repository's dynamic entity query capabilities
        final entities = await repository.getAllDynamicEntities(concept.name);
        
        // Filter based on query parameters
        final filteredEntities = entities.where((entity) {
          // Apply filters from parameters
          for (final entry in parameters.entries) {
            final key = entry.key;
            final value = entry.value;
            
            // Skip standard parameters
            if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
              continue;
            }
            
            // If entity doesn't have the attribute or value doesn't match, filter it out
            if (!entity.data.containsKey(key) || entity.data[key] != value) {
              return false;
            }
          }
          
          return true;
        }).toList();
        
        totalCount = filteredEntities.length;
        
        // Sort if needed
        if (sortBy != null) {
          filteredEntities.sort((a, b) {
            final aValue = a.data[sortBy];
            final bValue = b.data[sortBy];
            
            // Handle null values
            if (aValue == null && bValue == null) return 0;
            if (aValue == null) return isAscending ? -1 : 1;
            if (bValue == null) return isAscending ? 1 : -1;
            
            // Compare values
            int comparison;
            if (aValue is Comparable && bValue is Comparable) {
              comparison = aValue.compareTo(bValue);
            } else {
              comparison = aValue.toString().compareTo(bValue.toString());
            }
            
            return isAscending ? comparison : -comparison;
          });
        }
        
        // Apply pagination
        var paginatedEntities = filteredEntities;
        if (page != null && pageSize != null) {
          final start = (page - 1) * pageSize;
          final end = start + pageSize;
          
          if (start < filteredEntities.length) {
            paginatedEntities = filteredEntities.sublist(
              start,
              end > filteredEntities.length ? filteredEntities.length : end,
            );
          } else {
            paginatedEntities = [];
          }
        }
        
        // Convert to row format to maintain consistency
        rows = paginatedEntities.map((e) => e.data).toList();
      }
      
      // Map rows to entities
      final entities = rows.map(mapToEntity).toList();
      
      // Create metadata
      final metadata = <String, dynamic>{};
      if (page != null && pageSize != null) {
        metadata['page'] = page;
        metadata['pageSize'] = pageSize;
        metadata['totalCount'] = totalCount;
      }
      
      // Create success result
      return EntityQueryResult<T>.success(
        entities,
        concept: concept,
        conceptCode: concept?.code,
        metadata: metadata,
      ) as R;
    } catch (e) {
      // Create failure result
      return EntityQueryResult<T>.failure(
        'Error executing drift query: $e',
        concept: concept,
        conceptCode: concept?.code,
      ) as R;
    }
  }
  
  /// Process a DriftQuery with specialized Drift features.
  ///
  /// This method handles the Drift-specific query capabilities.
  Future<R> _processDriftQuery(DriftQuery query) async {
    try {
      final db = repository.database;
      
      // Start building the SQL query
      var sql = 'SELECT * FROM $tableName';
      final variables = <Variable>[];
      
      // Add joins if specified
      if (query.joins != null && query.joins!.isNotEmpty) {
        for (final join in query.joins!) {
          sql += ' $join';
        }
      }
      
      // Add WHERE clause
      var whereClause = '';
      
      // 1. Use raw SQL if provided
      if (query.rawSql != null && query.rawSql!.isNotEmpty) {
        whereClause = query.rawSql!;
        if (query.sqlVariables != null) {
          variables.addAll(query.sqlVariables!);
        }
      }
      // 2. Otherwise build from parameters
      else {
        final whereClauses = <String>[];
        
        // Add standard parameters
        final standardParams = query.getParameters();
        for (final entry in standardParams.entries) {
          final key = entry.key;
          final value = entry.value;
          
          if (!['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key) && value != null) {
            whereClauses.add('$key = ?');
            variables.add(Variable(value));
          }
        }
        
        // Add Drift-specific parameters
        for (final entry in query.driftParameters.entries) {
          final key = entry.key;
          final value = entry.value;
          
          // If value is already a Variable, use it directly
          if (value is Variable) {
            whereClauses.add('$key = ?');
            variables.add(value);
          }
          // Otherwise, create a Variable from the value
          else if (value != null) {
            whereClauses.add('$key = ?');
            variables.add(Variable(value));
          }
        }
        
        // Combine all clauses
        if (whereClauses.isNotEmpty) {
          whereClause = whereClauses.join(' AND ');
        }
      }
      
      // Add the WHERE clause to the query if non-empty
      if (whereClause.isNotEmpty) {
        sql += ' WHERE $whereClause';
      }
      
      // Add sorting
      final sortBy = query.getParameters()['sortBy'] as String?;
      final sortDirection = query.getParameters()['sortDirection'] as String?;
      final isAscending = sortDirection != 'desc';
      
      if (sortBy != null) {
        final orderByClause = '$sortBy ${isAscending ? 'ASC' : 'DESC'}';
        sql += ' ORDER BY $orderByClause';
      }
      
      // Add pagination
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      int totalCount = 0;
      if (page != null && pageSize != null) {
        final offset = (page - 1) * pageSize;
        sql += ' LIMIT $pageSize OFFSET $offset';
        
        // Get total count for pagination metadata
        var countSql = 'SELECT COUNT(*) as count FROM $tableName';
        if (whereClause.isNotEmpty) {
          countSql += ' WHERE $whereClause';
        }
        final countStmt = db.customSelect(countSql, variables: variables);
        final countResult = await countStmt.getSingle();
        totalCount = countResult.read<int>('count');
      }
      
      // Execute the query
      final stmt = db.customSelect(sql, variables: variables);
      final rows = await stmt.get();
      
      // Map rows to entities
      final entities = rows.map(mapToEntity).toList();
      
      // Create metadata
      final metadata = <String, dynamic>{};
      if (page != null && pageSize != null) {
        metadata['page'] = page;
        metadata['pageSize'] = pageSize;
        metadata['totalCount'] = totalCount;
      }
      
      // Create success result
      return EntityQueryResult<T>.success(
        entities,
        concept: concept,
        conceptCode: concept?.code,
        metadata: metadata,
      ) as R;
    } catch (e) {
      // Create failure result
      return EntityQueryResult<T>.failure(
        'Error executing drift query: $e',
        concept: concept,
        conceptCode: concept?.code,
      ) as R;
    }
  }
} 
import 'dart:async';
import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // or whichever drift backend
import 'dart:io';

import 'package:ednet_core/ednet_core.dart';
import 'drift_query.dart';
import 'drift_query_handler.dart';

// -------------------------------------------------------------
// EDNet Core-Like Model (Concept / Attribute / DomainEntity)
// -------------------------------------------------------------


class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  BoolColumn get isAdmin =>
      boolean().named('is_admin').withDefault(const Constant(false))();

// If you prefer storing date times as text or timestamps:
// DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

// By default, the table name is the class name "users" in lower_case.
// You can override with "String get tableName => 'users';"
}

// -------------------------------------------------------------
// Drift Database
//
// Uses typed approach for known stable concepts (like "Users"),
// but also supports dynamic table creation for unknown domain concepts.
// -------------------------------------------------------------

@DriftDatabase(tables: [Users]) // referencing our typed table
class EDNetDriftDatabase extends _$EDNetDriftDatabase {
  final Domain domain; // The EDNet domain model for dynamic concepts
  EDNetDriftDatabase(this.domain, QueryExecutor e) : super(e);

  // Bump this whenever you change the schema in a breaking way.
  @override
  int get schemaVersion => 1;

  // Since drift 2.0, we no longer use SqlTypeSystem, etc. for type resolution.
  // We can override migrations with onCreate, onUpgrade, etc.
  @override
  MigrationStrategy get migration =>
      MigrationStrategy(
        onCreate: (m) async {
          // Create typed tables (like "users")
          await m.createAll();

          // Create dynamic tables for non-static concepts
          await _createDynamicTables(m.database, domain.models.map((m)     => m.concepts)
              .expand((c) => c)
              .where((c) => !c.entryConcept)
              .toList());  },
        onUpgrade: (m, from, to) async {
          // 1) rename any old dynamic tables if the concept changed name
          for (final c in domain.concepts.where((c) => !c.isStatic)) {
            if (c.oldTableName != null) {
              final oldName = c.oldTableName!;
              final newName = c.name.toLowerCase();
              // If the old name differs from new name
              if (oldName.toLowerCase() != newName) {
                // rename
                final row = await m.database.customSelect(
                  "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
                  variables: [Variable(oldName)],
                ).get();
                if (row.isNotEmpty) {
                  // rename it
                  await m.database.customStatement(
                      'ALTER TABLE $oldName RENAME TO $newName;');
                }
              }
            }
          }

          // 2) create typed tables that might have been newly added
          //    or add columns for typed tables if they're missing
          await m.createAll(); // ensures new typed tables appear

          // 3) create or alter dynamic tables
          await _createDynamicTables(m.database, domain.concepts
              .where((c) => !c.isStatic)
              .toList());

          // Optionally check columns for dynamic concepts and add if missing
          // for each concept, compare existing columns with concept attributes, etc.
          for (final c in domain.concepts.where((c) => !c.isStatic)) {
            await _alterTableForConceptIfNeeded(m.database, c);
          }
        },
        beforeOpen: (details) async {
          // e.g. enable foreign_keys
          await customStatement('PRAGMA foreign_keys = ON;');

          // If no create or upgrade, we can still do a check for newly added dynamic columns
          if (!details.wasCreated && !details.hadUpgrade) {
            for (final c in domain.concepts.where((c) => !c.isStatic)) {
              // Possibly create the table if it doesn't exist
              await _createOrEnsureTable(m.database, c);
              // Then check columns
              await _alterTableForConceptIfNeeded(m.database, c);
            }
          }
        },
      );

  @override
  int get schemaVersionFromDart => schemaVersion;

  // (This accessor helps drift internally, you typically just define get schemaVersion => <int>.)

  // For typed usage, we have a generated .g.dart part that includes a class
  // named _$EDNetDriftDatabase.
  // For demonstration, let's pretend it's below. In reality, you'd run build_runner to generate.
  // -------------------------------------------------------------
  // The rest is "manually" mimicking what build_runner would do.
  // -------------------------------------------------------------

  // Helper: create dynamic tables for the list of concepts.
  Future<void> _createDynamicTables(QueryExecutor db,
      List<Concept> concepts) async {
    for (final c in concepts) {
      await _createOrEnsureTable(db, c);
    }
  }

  Future<void> _createOrEnsureTable(QueryExecutor db, Concept concept) async {
    final tableName = concept.name.toLowerCase();

    // Check if table already exists
    final existing = await db.customSelect(
      'SELECT name FROM sqlite_master WHERE type="table" AND name=?',
      variables: [Variable(tableName)],
    ).get();
    if (existing.isNotEmpty) {
      return; // table is there
    }

    // build and run CREATE TABLE
    final createSql = _buildCreateTableSql(concept);
    await db.customStatement(createSql);

    // optionally create indexes for any attributes that are .isIndexed
    for (final attr in concept.attributes) {
      if (attr.isIndexed) {
        final indexName = 'idx_${tableName}_${attr.name}';
        await db.customStatement(
          'CREATE INDEX IF NOT EXISTS $indexName ON $tableName(${attr.name})',
        );
      }
    }
  }

  Future<void> _alterTableForConceptIfNeeded(QueryExecutor db,
      Concept concept) async {
    final tableName = concept.name.toLowerCase();
    // check existing columns
    final colInfo = await db
        .customSelect('PRAGMA table_info($tableName)')
        .get();
    final existingCols = colInfo
        .map((row) => row.read<String>('name'))
        .toSet();

    // check for missing or renamed columns
    for (final attr in concept.attributes) {
      if (attr.oldName != null && existingCols.contains(attr.oldName!)) {
        // rename column if oldName is different from new name
        final old = attr.oldName!;
        final newCol = attr.name;
        if (!existingCols.contains(newCol)) {
          // rename the column if sqlite >= 3.25
          await db.customStatement(
              'ALTER TABLE $tableName RENAME COLUMN $old TO $newCol;');
        }
      } else if (!existingCols.contains(attr.name)) {
        // add the new column
        final colDef = _buildColumnDef(attr);
        await db.customStatement('ALTER TABLE $tableName ADD COLUMN $colDef;');
      }
    }

    // You could also handle dropping columns that no longer appear in the concept.
    // However, SQLite doesn't allow drop column before 3.35 or so, and it can be tricky for migrations.
  }

  String _buildCreateTableSql(Concept concept) {
    final tableName = concept.name.toLowerCase();
    final sb = StringBuffer('CREATE TABLE IF NOT EXISTS $tableName (');
    bool hasPk = concept.primaryKeyAttributes.isNotEmpty;

    // define columns
    for (int i = 0; i < concept.attributes.length; i++) {
      final attr = concept.attributes[i];
      sb.write(_buildColumnDef(attr, isPartOfCreate: true));
      if (hasPk && attr.isPrimaryKey) {
        sb.write(' PRIMARY KEY');
      }
      if (attr.isUnique) {
        sb.write(' UNIQUE');
      }
      if (i < concept.attributes.length - 1) {
        sb.write(', ');
      }
    }

    // if no explicit primary key, add "id INTEGER PRIMARY KEY AUTOINCREMENT" or similar
    if (!hasPk) {
      if (concept.attributes.isNotEmpty) sb.write(', ');
      sb.write('id INTEGER PRIMARY KEY AUTOINCREMENT');
    }
    sb.write(');');
    return sb.toString();
  }

  String _buildColumnDef(Attribute attr, {bool isPartOfCreate = false}) {
    final typeSql = _driftAttrTypeToSql(attr.type);
    // Additional constraints
    // isUnique can be appended if needed, but typically we'd do that in the CREATE TABLE clause itself.
    return '${attr.name} $typeSql';
  }

  String _driftAttrTypeToSql(DriftAttributeType t) {
    switch (t) {
      case DriftAttributeType.integer:
        return 'INTEGER';
      case DriftAttributeType.real:
        return 'REAL';
      case DriftAttributeType.text:
        return 'TEXT';
      case DriftAttributeType.boolean:
        return 'INTEGER'; // store bool as 0/1
      case DriftAttributeType.datetime:
        return 'INTEGER'; // or 'TEXT' if storing iso8601
    }
  }

// *** EXAMPLE CRUD on typed table (Users) can be done with standard drift:
// e.g. Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
// e.g. Stream<List<User>> watchAllUsers() => select(users).watch();
}

// The part file generated by drift (build_runner) for typed queries, e.g.:
part 'ednet_drift_database.g.dart';

/// Typically you'd see something like:
/// class _$EDNetDriftDatabase extends GeneratedDatabase {
///   ...
/// }

// -------------------------------------------------------------
// The EDNetDriftRepository Implementation
//
// This repository instance ties everything together:
// - Access to typed queries for stable domain concepts
// - Dynamic creation and CRUD for unknown domain concepts
// - Reactive streams for dynamic tables via StreamQueryStore or manual approach
// - Transaction and batch usage
// - Integration with EDNet Core's unified query system
// -------------------------------------------------------------

class EDNetDriftRepository {
  final Domain _domain;
  late final EDNetDriftDatabase _db;
  
  /// Query dispatcher for handling unified queries.
  final QueryDispatcher? queryDispatcher;

  // For dynamic concept watchers, we can keep a local StreamQueryStore or
  // keep references to StreamControllers. We'll do the simpler approach
  // with drift's "notifyUpdates" for dynamic tables.
  // We'll track the tableName -> set of watchers approach:
  final Map<String,
      StreamController<List<DomainEntity>>> _dynamicControllers = {};

  EDNetDriftRepository({
    required Domain domain,
    required String sqlitePath,
    int? schemaVersion,
    this.queryDispatcher,
  }) : _domain = domain {
    // Initialize the underlying drift database:
    final executor = NativeDatabase(File(sqlitePath));
    _db = EDNetDriftDatabase(domain, executor);

    // If you want to override the schemaVersion:
    if (schemaVersion != null) {
      // we can do: _db.schemaVersion override, or pass it in constructor if you adopt a custom approach.
      // For demonstration, we keep the default.
    }
    
    // Register query handlers if a dispatcher is provided
    if (queryDispatcher != null) {
      _registerQueryHandlers();
    }
  }

  /// Ensure the DB is open and migrations are done.
  Future<void> open() async {
    // The first query will trigger migrations.
    await _db.customSelect('SELECT 1').get();
  }

  // *** TYPED CRUD EXAMPLE: Users ***
  // Drift automatically generates typed CRUD for the "users" table.
  // We can do:
  Future<int> insertUser(UsersCompanion userCompanion) {
    return _db.into(_db.users).insert(userCompanion);
  }

  Stream<List<User>> watchAllUsers() {
    return _db.select(_db.users).watch();
  }

  // *** DYNAMIC CRUD ***

  /// Insert or update a [DomainEntity] for a dynamic concept.
  Future<void> saveDynamicEntity(DomainEntity entity) async {
    final c = entity.concept;
    if (c.isStatic) {
      throw ArgumentError(
          'Concept ${c.name} is static. Use typed approach instead.');
    }
    final tableName = c.name.toLowerCase();
    final pkAttrs = c.primaryKeyAttributes;
    // If we have a primary key, try to see if the row exists. If so, update.
    if (pkAttrs.isNotEmpty) {
      final pk = pkAttrs.first;
      final pkVal = entity.data[pk.name];
      if (pkVal != null) {
        // check if row exists
        final res = await _db.customSelect(
          'SELECT COUNT(*) as cnt FROM $tableName WHERE ${pk.name} = ?',
          variables: [Variable(pkVal)],
        ).getSingle();
        final count = (res.readNullable<int>('cnt') ?? 0);
        if (count > 0) {
          // update
          await _updateDynamic(tableName, pk.name, pkVal, entity);
          _db.markTableAsModified(tableName, UpdateKind.update);
          return;
        }
      }
      // If we don't find existing row, insert
      await _insertDynamic(tableName, entity);
      _db.markTableAsModified(tableName, UpdateKind.insert);
    } else {
      // No primary key - just insert with an auto-inc ID or something.
      await _insertDynamic(tableName, entity);
      _db.markTableAsModified(tableName, UpdateKind.insert);
    }
  }

  Future<void> _insertDynamic(String tableName, DomainEntity entity) async {
    final cols = entity.data.keys.toList();
    final placeholders = List.filled(cols.length, '?').join(', ');
    final colList = cols.join(', ');
    final vars = cols.map((k) => Variable(entity.data[k])).toList();
    await _db.customInsert(
      'INSERT INTO $tableName ($colList) VALUES ($placeholders)',
      variables: vars,
    );
  }

  Future<void> _updateDynamic(String tableName, String pkCol, dynamic pkVal,
      DomainEntity entity) async {
    // Build a set of "col = ?" for all but the pk
    final updates = <String>[];
    final vars = <Variable>[];
    entity.data.forEach((col, val) {
      if (col != pkCol) {
        updates.add('$col = ?');
        vars.add(Variable(val));
      }
    });
    // where pkCol = pkVal
    vars.add(Variable(pkVal));

    final setClause = updates.join(', ');
    final sql = 'UPDATE $tableName SET $setClause WHERE $pkCol = ?';
    await _db.customUpdate(sql, variables: vars, updateKind: UpdateKind.update);
  }

  /// Fetch dynamic entities for the [conceptName].
  Future<List<DomainEntity>> getAllDynamicEntities(String conceptName) async {
    final concept = _domain.findConcept(conceptName);
    if (concept == null) {
      throw ArgumentError('Unknown concept: $conceptName');
    }
    if (concept.isStatic) {
      throw ArgumentError(
          'Concept $conceptName is static. Use typed approach.');
    }
    final tableName = concept.name.toLowerCase();
    final rows = await _db.customSelect('SELECT * FROM $tableName').get();
    return rows.map((row) {
      final map = <String, dynamic>{};
      row.data.forEach((key, value) {
        // If you store booleans as integers, you can manually map them to bool. Etc.
        map[key] = value;
      });
      return DomainEntity(concept, map);
    }).toList();
  }

  // *** REACTIVE QUERIES FOR DYNAMIC TABLES ***
  // We'll rely on drift's notifyUpdates approach:
  // `_db.markTableAsModified(tableName, UpdateKind)`.
  // Then we can create a simpler watch that re-fetches.

  Stream<List<DomainEntity>> watchDynamicEntities(String conceptName) {
    final concept = _domain.findConcept(conceptName);
    if (concept == null || concept.isStatic) {
      return Stream.error(
          'Cannot watch dynamic for unknown or static concept: $conceptName');
    }
    final tableName = concept.name.toLowerCase();

    // We'll create a QueryStreamFetcher from drift to re-run "SELECT *" each time
    // the table is updated. This is a more advanced approach using StreamQueryStore.
    // Alternatively, we can do a manual approach with a local StreamController.

    // We'll do the simpler approach:
    final controller = StreamController<List<DomainEntity>>.broadcast();
    Future<void> _emit() async {
      final list = await getAllDynamicEntities(conceptName);
      if (!controller.isClosed) controller.add(list);
    }

    // Listen to drift's table update notifications
    final sub = _db.streamQueries
        .updatesForSync(TableUpdateQuery.onTableName(tableName))
        .listen((_) => _emit());

    // Also emit initial
    _emit();

    // Close logic
    controller.onCancel = () {
      sub.cancel();
    };

    return controller.stream;
  }

  // *** TRANSACTIONS & BATCH EXAMPLES ***

  Future<void> runInTransaction(FutureOr<void> Function() action) {
    return _db.transaction(action);
  }

  /// For typed approach, you can do drift's standard:
  ///   await batch((b) => b.insertAll(...));
  /// For dynamic approach, let's do a custom single statement with multiple rows if needed.

  // *** UNIFIED QUERY SYSTEM INTEGRATION ***

  /// Registers query handlers with the query dispatcher.
  ///
  /// This method registers handlers for both static typed tables and
  /// dynamic concept tables based on the domain model.
  void _registerQueryHandlers() {
    if (queryDispatcher == null) return;

    // Register handlers for dynamic concepts
    for (final concept in _domain.concepts.where((c) => !c.isStatic)) {
      final tableName = concept.name.toLowerCase();
      
      // Define a mapper function for this concept
      T Function<T extends Entity>(Map<String, dynamic> row) mapper = <T extends Entity>(row) {
        if (T == DomainEntity) {
          return DomainEntity(concept, Map<String, dynamic>.from(row)) as T;
        } else {
          // For other entity types, you would need a custom mapper
          throw ArgumentError('Cannot map to type $T - only DomainEntity is supported for dynamic concepts');
        }
      };
      
      // Register a concept query handler
      queryDispatcher!.registerConceptHandler<ConceptQuery, EntityQueryResult<DomainEntity>>(
        concept.code,
        'FindAll',
        DriftQueryHandler<DomainEntity, ConceptQuery, EntityQueryResult<DomainEntity>>(
          repository: this,
          tableName: tableName,
          isStatic: false,
          concept: concept,
          mapToEntity: (row) => DomainEntity(concept, Map<String, dynamic>.from(row)),
        ),
      );
      
      // Register a handler for drift-specific queries
      queryDispatcher!.registerHandler<DriftQuery, EntityQueryResult<DomainEntity>>(
        DriftQueryHandler<DomainEntity, DriftQuery, EntityQueryResult<DomainEntity>>(
          repository: this,
          tableName: tableName,
          isStatic: false,
          concept: concept,
          mapToEntity: (row) => DomainEntity(concept, Map<String, dynamic>.from(row)),
        ),
      );
    }
    
    // Register handlers for static tables
    // For the Users table as an example
    queryDispatcher!.registerConceptHandler<ConceptQuery, EntityQueryResult<User>>(
      'Users',
      'FindAll',
      DriftQueryHandler<User, ConceptQuery, EntityQueryResult<User>>(
        repository: this,
        tableName: 'users',
        isStatic: true,
        concept: _domain.findConcept('Users'),
        mapToEntity: (row) => User.fromJson(row),
      ),
    );
  }
  
  /// Executes a query using the unified query system.
  ///
  /// This method provides a convenient way to execute queries against
  /// this repository without manually setting up handlers.
  ///
  /// Parameters:
  /// - [query]: The query to execute
  ///
  /// Returns:
  /// A Future with the query result
  Future<IQueryResult> executeQuery(IQuery query) async {
    if (queryDispatcher == null) {
      throw StateError('Cannot execute query: no query dispatcher provided');
    }
    
    return queryDispatcher!.dispatch(query);
  }
  
  /// Executes a concept query using the unified query system.
  ///
  /// This method provides a convenient way to execute concept queries
  /// without having to create a ConceptQuery manually.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [queryName]: The name of the query to execute
  /// - [parameters]: Optional parameters for the query
  ///
  /// Returns:
  /// A Future with the query result
  Future<IQueryResult> executeConceptQuery(
    String conceptCode,
    String queryName, [
    Map<String, dynamic>? parameters,
  ]) async {
    if (queryDispatcher == null) {
      throw StateError('Cannot execute query: no query dispatcher provided');
    }
    
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return QueryResult.failure('Unknown concept: $conceptCode');
    }
    
    final query = ConceptQuery(queryName, concept);
    if (parameters != null) {
      query.withParameters(parameters);
    }
    
    return queryDispatcher!.dispatch(query);
  }
  
  /// Creates a DriftQuery for more advanced query capabilities.
  ///
  /// This method provides a convenient way to create a DriftQuery
  /// with Drift-specific features.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [conceptCode]: The code of the concept to query
  /// - [rawSql]: Optional raw SQL WHERE clause
  /// - [sqlVariables]: Optional variables for the raw SQL
  /// - [parameters]: Optional standard parameters
  ///
  /// Returns:
  /// A DriftQuery ready to be executed
  DriftQuery createDriftQuery(
    String name,
    String conceptCode, {
    String? rawSql,
    List<Variable>? sqlVariables,
    Map<String, dynamic>? parameters,
  }) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Unknown concept: $conceptCode');
    }
    
    return DriftQuery(
      name,
      conceptCode: conceptCode,
      rawSql: rawSql,
      sqlVariables: sqlVariables,
      parameters: parameters ?? {},
    );
  }

  // *** UTILITY ***

  EDNetDriftDatabase get database => _db;
  
  /// Gets the domain model.
  Domain get domain => _domain;
}

/// Extension method for User to convert from JSON.
extension UserJsonMapping on User {
  /// Creates a User from a JSON map.
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }
  
  /// Converts this User to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_admin': isAdmin,
    };
  }
}


import 'dart:io';
import 'package:ednet_core/ednet_core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// A Drift-backed implementation of the EDNet Core repository.
///
/// This repository dynamically generates database tables based on the
/// EDNet Core domain model (Concept metadata). It supports generic CRUD
/// operations on any domain [Entity], managing persistence and enforcing
/// basic domain rules (identifiers, references, and timestamps).
class DriftCoreRepository extends CoreRepository {
  /// Underlying Drift database connection.
  late final _DriftDomainDatabase _db;

  /// In-memory index of domains by code for quick lookup.
  final Map<String, Domain> _domainsByCode = {};

  /// Current schema version for migrations. Increase if the domain model changes.
  final int schemaVersion;

  /// Creates a repository with an optional [path] for the database
  /// (or in-memory if null) plus optional [domains] to register initially.
  DriftCoreRepository({
    String? path,
    Iterable<Domain>? domains,
    this.schemaVersion = 1,
  }) {
    // Initialize the Drift database.
    final executor =
        (path != null) ? NativeDatabase(File(path)) : NativeDatabase.memory();
    _db = _DriftDomainDatabase(executor, this);

    // Register initial domains.
    if (domains != null) {
      for (var domain in domains) {
        addDomain(domain);
      }
    }
  }

  /// Registers a [domain] and ensures its schema (tables) exist in the DB.
  void addDomain(Domain domain) {
    // NOTE: If your `CoreRepository` has a `void addDomain(Domain)` method,
    // you can call `super.addDomain(domain)` here. Otherwise, remove or rename.
    // super.addDomain(domain); // <-- remove or define in CoreRepository

    _domainsByCode[domain.code] = domain;
    _ensureDomainSchema(domain);
  }

  /// Retrieves a [Domain] by its [domainCode], or null if not found.
  Domain? getDomain(String domainCode) => _domainsByCode[domainCode];

  /// Inserts a new [entity] into the repository and the underlying database.
  ///
  /// Assigns a new OID (auto-increment) if needed, sets lifecycle timestamps,
  /// and enforces essential fields/parents.
  Future<void> insertEntity<E extends Entity<E>>(E entity) async {
    final concept = entity.concept;
    if (concept == null) {
      throw Exception("Cannot insert entity without a concept.");
    }
    final tableName = _tableNameForConcept(concept);

    // Prepare columns/values for the INSERT statement.
    final Map<String, dynamic> values = {};

    // For each attribute (must do .whereType<Attribute>()):
    for (var attr in concept.attributes.whereType<Attribute>()) {
      final name = attr.code!;
      final val = entity.getAttribute(name);
      if (_isValueMissing(val) && attr.essential == true) {
        throw Exception("Cannot insert: required attribute '$name' missing.");
      }
      if (val != null) {
        values[name] = _toColumnValue(val, attr);
      }
    }

    // For each parent (must do .whereType<Parent>()):
    for (var parent in concept.parents.whereType<Parent>()) {
      final refName = parent.code!;
      final parentObject = entity.getParent(refName);
      if (parentObject == null) {
        if (parent.essential == true) {
          throw Exception("Cannot insert: required parent '$refName' missing.");
        }
      } else {
        final parentEntity = parentObject as Entity?;
        if (parentEntity?.oid == null) {
          throw Exception(
            "Parent entity for '$refName' has no OID. Must insert it first.",
          );
        }
        values["${refName}_oid"] = parentEntity!.oid.timeStamp;
      }
    }

    // Possibly store `entity.code`.
    if (entity.code != null) {
      values["code"] = entity.code;
    }

    // Lifecycle timestamps:
    final now = DateTime.now();
    if (concept.updateWhen == true) {
      entity.whenAdded = now;
      entity.whenSet = now;
    }
    values["when_added"] = entity.whenAdded?.toUtc().toIso8601String();
    values["when_set"] = entity.whenSet?.toUtc().toIso8601String();
    values["when_removed"] = null;

    // Execute the INSERT.
    final cols = values.keys.map((col) => "\"$col\"").join(", ");
    final placeholders = List.filled(values.length, "?").join(", ");
    final sql = "INSERT INTO $tableName ($cols) VALUES ($placeholders)";
    await _db.customStatement(sql, values.values.toList());

    // Retrieve auto-generated OID from SQLite.
    final result =
        await _db.customSelect("SELECT last_insert_rowid() AS id").getSingle();
    final newId = result.data["id"] as int;
    entity.oid = Oid.ts(newId);

    // Add to in-memory Entities.
    final dom = getDomain(concept.model.domain.code);
    if (dom != null) {
      final domainModels = getDomainModels(dom.code);
      final modelEntries = domainModels?.getModelEntries(concept.model.code);
      if (modelEntries != null) {
        final Entities<E>? entities =
            modelEntries.getEntry(concept.code!) as Entities<E>?;
        entities?.add(entity);
      }
    }
  }

  /// Updates [entity] in the DB. Only updatable attributes/parents change.
  /// Refreshes `whenSet` if allowed.
  Future<void> updateEntity<E extends Entity<E>>(E entity) async {
    final concept = entity.concept;
    if (concept == null) {
      throw Exception("Cannot update entity without concept.");
    }
    final tableName = _tableNameForConcept(concept);
    final oid = entity.oid;
    if (oid == null) {
      throw Exception("Cannot update: entity has no OID (not persisted yet).");
    }

    final updates = <String>[];
    final args = <dynamic>[];

    // For each attribute:
    for (var attr in concept.attributes.whereType<Attribute>()) {
      final name = attr.code!;
      // If code not updatable, skip:
      if (name == "code" && !concept.updateCode) continue;

      final newVal = entity.getAttribute(name);
      if (_isValueMissing(newVal)) {
        if (attr.essential == true) {
          throw Exception(
            "Cannot update: required attr '$name' cannot be null.",
          );
        }
        updates.add("\"$name\" = NULL");
      } else {
        if (!attr.update) {
          throw Exception("Attribute '$name' is not updatable.");
        }
        updates.add("\"$name\" = ?");
        args.add(_toColumnValue(newVal, attr));
      }
    }

    // For each parent:
    for (var parent in concept.parents.whereType<Parent>()) {
      final refName = parent.code!;
      final parentObject = entity.getParent(refName);
      if (parentObject == null) {
        if (parent.essential == true) {
          throw Exception(
            "Cannot remove required parent '$refName' on update.",
          );
        }
        updates.add("\"${refName}_oid\" = NULL");
      } else {
        if (!parent.update) {
          throw Exception("Parent reference '$refName' is not updatable.");
        }
        final parentEntity = parentObject as Entity?;
        updates.add("\"${refName}_oid\" = ?");
        args.add(parentEntity?.oid.timeStamp);
      }
    }

    // Possibly update code if concept allows:
    if (concept.updateCode) {
      updates.add("\"code\" = ?");
      args.add(entity.code);
    }

    // Update whenSet if concept allows:
    if (concept.updateWhen) {
      entity.whenSet = DateTime.now();
    }
    updates.add("\"when_set\" = ?");
    args.add(entity.whenSet?.toUtc().toIso8601String());

    // Final UPDATE statement:
    final setClause = updates.join(", ");
    final sql = "UPDATE $tableName SET $setClause WHERE oid = ?";
    args.add(oid.timeStamp);
    await _db.customStatement(sql, args);
  }

  /// Deletes [entity] from DB, ensuring no essential children remain.
  Future<void> deleteEntity<E extends Entity<E>>(E entity) async {
    final concept = entity.concept;
    if (concept == null) {
      throw Exception("Cannot delete entity with no concept.");
    }
    final tableName = _tableNameForConcept(concept);
    final oid = entity.oid?.timeStamp;
    if (oid == null) return;

    // Check essential children (must do .whereType<Child>()).
    for (var childRel in concept.children.whereType<Child>()) {
      if (childRel.essential) {
        final childTable = _tableNameForConcept(childRel.destinationConcept);
        final childCol = "\"${childRel.code}_oid\"";
        final result =
            await _db.customSelect(
              "SELECT COUNT(*) AS count FROM $childTable WHERE $childCol = ?",
              [oid],
            ).getSingle();
        final count = result.data["count"] as int;
        if (count > 0) {
          throw Exception(
            "Cannot delete: $count dependent '${childRel.code}' children exist.",
          );
        }
      }
    }

    // If concept.updateWhen => set whenRemoved
    if (concept.updateWhen) {
      entity.whenRemoved = DateTime.now();
    }
    await _db.customStatement("DELETE FROM $tableName WHERE oid = ?", [oid]);

    // Remove from in-memory collection
    final dom = getDomain(concept.model.domain.code);
    if (dom != null) {
      final domainModels = getDomainModels(dom.code);
      final modelEntries = domainModels?.getModelEntries(concept.model.code);
      final Entities<E>? entities =
          modelEntries?.getEntry(concept.code!) as Entities<E>?;
      entities?.remove(entity);
    }
  }

  /// Ensure all tables for [domain] exist in the DB.
  void _ensureDomainSchema(Domain domain) {
    for (final modelEntries in domain.models) {
      for (final entry in modelEntries.entries) {
        final concept = entry.concept;
        if (concept != null) {
          _createTableForConcept(concept);
        }
      }
    }
  }

  /// Creates a table for [concept] if it does not exist, adding columns & constraints.
  Future<void> _createTableForConcept(Concept concept) async {
    final tableName = _tableNameForConcept(concept);

    final columnDefs = <String>[];
    // OID primary key:
    columnDefs.add("oid INTEGER PRIMARY KEY AUTOINCREMENT");

    // Attributes:
    for (var attr in concept.attributes.whereType<Attribute>()) {
      final name = attr.code!;
      final sqlType = _sqlTypeForAttribute(attr);
      var colDef = "\"$name\" $sqlType";
      if (attr.essential == true) {
        colDef += " NOT NULL";
      }
      if (attr.identifier) {
        colDef += " UNIQUE";
      }
      columnDefs.add(colDef);
    }

    // code column:
    columnDefs.add("\"code\" TEXT");
    // lifecycle columns:
    columnDefs.addAll([
      "\"when_added\" TEXT",
      "\"when_set\" TEXT",
      "\"when_removed\" TEXT",
    ]);

    // parent FKs:
    final fkClauses = <String>[];
    for (var parent in concept.parents.whereType<Parent>()) {
      final refCol = "\"${parent.code}_oid\"";
      var fkColDef = "$refCol INTEGER";
      if (parent.essential) {
        fkColDef += " NOT NULL";
      }
      columnDefs.add(fkColDef);

      final parentTable = _tableNameForConcept(parent.destinationConcept);

      // Choose an ON DELETE action (cascade vs restrict vs set null):
      String onDelete;
      if ( /*some composition rule*/ false) {
        onDelete = "CASCADE";
      } else if (parent.essential) {
        onDelete = "RESTRICT";
      } else {
        onDelete = "SET NULL";
      }
      fkClauses.add(
        "FOREIGN KEY($refCol) REFERENCES $parentTable(oid) ON DELETE $onDelete",
      );
    }

    final colsSql = columnDefs.join(", ");
    final fksSql = fkClauses.isNotEmpty ? ", ${fkClauses.join(", ")}" : "";
    final sql = "CREATE TABLE IF NOT EXISTS $tableName ($colsSql$fksSql)";
    await _db.customStatement(sql);
  }

  /// Builds a table name from [concept] by snake-casing its plural code.
  String _tableNameForConcept(Concept concept) => concept.codesLowerUnderscore;

  /// Maps a Dart [value] to a DB-friendly representation based on [attr.type].
  dynamic _toColumnValue(Object? value, Attribute attr) {
    if (value == null) return null;
    final tcode = attr.type?.code;
    switch (tcode) {
      case "String":
      case null:
        return value.toString();
      case "int":
      case "Integer":
        return (value is int) ? value : int.parse(value.toString());
      case "double":
      case "Double":
      case "num":
        return (value is num)
            ? value.toDouble()
            : double.parse(value.toString());
      case "bool":
      case "Boolean":
        return (value is bool
                ? value
                : value.toString().toLowerCase() == 'true')
            ? 1
            : 0;
      case "DateTime":
        final dt =
            (value is DateTime) ? value : DateTime.parse(value.toString());
        return dt.toUtc().toIso8601String();
      default:
        // fallback: store as text
        return value.toString();
    }
  }

  /// True if value is null or empty string.
  bool _isValueMissing(Object? val) =>
      val == null || (val is String && val.isEmpty);
}

/// Internal Drift database class to manage migrations, etc.
class _DriftDomainDatabase extends GeneratedDatabase {
  final DriftCoreRepository _repo;

  _DriftDomainDatabase(QueryExecutor e, this._repo)
    : super(SqlTypeSystem.defaultInstance, e);

  @override
  int get schemaVersion => _repo.schemaVersion;

  @override
  Iterable<TableInfo> get allTables => const []; // no compile-time tables

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Create tables for any domains added so far.
      for (var domain in _repo._domainsByCode.values) {
        for (var modelEntries in domain.models) {
          for (var entry in modelEntries.entries) {
            final concept = entry.concept;
            if (concept != null) {
              await _repo._createTableForConcept(concept);
            }
          }
        }
      }
    },
    onUpgrade: (m, from, to) async {
      // Check each concept's table for missing columns, etc.
      for (var domain in _repo._domainsByCode.values) {
        for (var modelEntries in domain.models) {
          for (var entry in modelEntries.entries) {
            final concept = entry.concept;
            if (concept == null) continue;

            // Ensure table is created:
            await _repo._createTableForConcept(concept);

            // Now add any newly introduced columns:
            final tableName = _repo._tableNameForConcept(concept);
            final existingCols = <String>{};

            final colInfo =
                await customSelect("PRAGMA table_info($tableName)").get();
            for (var row in colInfo) {
              existingCols.add(row.read<String>('name'));
            }

            // Build list of expected columns:
            final expectedCols = <String>[
              "oid",
              "code",
              "when_added",
              "when_set",
              "when_removed",
            ];
            for (var attr in concept.attributes.whereType<Attribute>()) {
              expectedCols.add(attr.code!);
            }
            for (var parent in concept.parents.whereType<Parent>()) {
              expectedCols.add("${parent.code}_oid");
            }

            // Add any missing columns:
            for (var col in expectedCols) {
              if (!existingCols.contains(col)) {
                String colDef;
                if (col == "oid") {
                  colDef = "oid INTEGER PRIMARY KEY AUTOINCREMENT";
                } else if (col == "code") {
                  colDef = "\"code\" TEXT";
                } else if (col == "when_added" ||
                    col == "when_set" ||
                    col == "when_removed") {
                  colDef = "\"$col\" TEXT";
                } else if (col.endsWith("_oid")) {
                  colDef = "\"$col\" INTEGER";
                } else {
                  // It's an attribute code:
                  final a = concept.attributes
                      .whereType<Attribute>()
                      .firstWhere((x) => x.code == col);
                  colDef = "\"$col\" ${_repo._sqlTypeForAttribute(a)}";
                }
                await customStatement(
                  "ALTER TABLE $tableName ADD COLUMN $colDef",
                );
              }
            }
          }
        }
      }
    },
  );
}
